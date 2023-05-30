// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "../PriceProvider.sol";
import "../IERC20LikeV2.sol";
import "../../external/dia/IDIAOracleV2.sol";
import "../../interfaces/IPriceProviderV2.sol";

contract DiaPriceProvider is IPriceProviderV2, PriceProvider {
    /// @dev price provider needs to return prices in ETH, but assets prices provided by DIA are in USD
    /// Under ETH_USD_KEY we will find ETH price in USD so we can convert price in USD into price in ETH
    string public constant ETH_USD_KEY = "ETH/USD";

    /// @dev decimals in DIA oracle
    uint256 public constant DIA_DECIMALS = 1e8;

    /// @dev decimals in Silo protocol
    uint256 public immutable EXPECTED_DECIMALS; // solhint-disable-line var-name-mixedcase

    /// @dev Oracle deployed for Silo by DIA, all our prices will be submitted to this contract
    IDIAOracleV2 public immutable DIA_ORACLEV2; // solhint-disable-line var-name-mixedcase

    /// @dev Address of asset that we will be using as reference for USD
    address public immutable USD_ASSET; // solhint-disable-line var-name-mixedcase

    /// @dev we accessing prices for assets by keys eg. "Jones/USD"
    mapping (address => string) public keys;

    /// @dev asset => fallbackProvider
    mapping(address => IPriceProvider) public liquidationProviders;

    event AssetSetup(address indexed asset, string key);

    event LiquidationProvider(address indexed asset, IPriceProvider indexed liquidationProvider);

    error MissingETHPrice();
    error InvalidKey();
    error CanNotSetEthKey();
    error OnlyUSDPriceAccepted();
    error PriceCanNotBeFoundForProvidedKey();
    error OldPrice();
    error MissingPriceOrSetup();
    error LiquidationProviderAlreadySet();
    error AssetNotSupported();
    error LiquidationProviderAssetNotSupported();
    error LiquidationProviderNotExist();
    error KeyDoesNotMatchSymbol();
    error FallbackPriceProviderNotSet();

    /// @param _priceProvidersRepository IPriceProvidersRepository
    /// @param _diaOracle IDIAOracleV2 address of DIA oracle contract
    /// @param _stableAsset address Address of asset that we will be using as reference for USD
    /// it has no affect on any price, this is only for be able to getPrice(_usdAsset) using `ETH_USD_KEY` key
    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        IDIAOracleV2 _diaOracle,
        address _stableAsset
    )
        PriceProvider(_priceProvidersRepository)
    {
        EXPECTED_DECIMALS = 10 ** IERC20LikeV2(_priceProvidersRepository.quoteToken()).decimals();
        USD_ASSET = _stableAsset;
        DIA_ORACLEV2 = _diaOracle;

        bool allowEthUsdKey = true;
        _setupAsset(_stableAsset, ETH_USD_KEY, IPriceProvider(address(0)), allowEthUsdKey);
    }

    /// @inheritdoc IPriceProvider
    function assetSupported(address _asset) public view virtual override returns (bool) {
        return bytes(keys[_asset]).length != 0;
    }

    /// @param _key string under this key asset price will be available in DIA oracle
    /// @return assetPriceInUsd uint128 asset price
    /// @return priceUpToDate bool TRUE if price is up to date (acceptable), FALSE otherwise
    function getPriceForKey(string memory _key)
        public
        view
        virtual
        returns (uint128 assetPriceInUsd, bool priceUpToDate)
    {
        uint128 priceTimestamp;
        (assetPriceInUsd, priceTimestamp) = DIA_ORACLEV2.getValue(_key);

        // price must be updated at least once every 24h, otherwise something is wrong
        uint256 oldestAcceptedPriceTimestamp;
        // block.timestamp is more than 1 day, so we can not underflow
        unchecked { oldestAcceptedPriceTimestamp = block.timestamp - 1 days; }

        // we not checking assetPriceInUsd != 0, because this is checked on setup, so it will be always some value here
        priceUpToDate = priceTimestamp > oldestAcceptedPriceTimestamp;
    }

    function getFallbackPrice(address _asset) public view virtual returns (uint256) {
        IPriceProvider fallbackProvider = liquidationProviders[_asset];

        if (address(fallbackProvider) != address(0)) {
            return fallbackProvider.getPrice(_asset);
        }

        revert FallbackPriceProviderNotSet();
    }

    /// @inheritdoc IPriceProvider
    function getPrice(address _asset) public view virtual override returns (uint256) {
        string memory key = keys[_asset];

        if (bytes(key).length == 0) revert AssetNotSupported();

        (uint128 assetPriceInUsd, bool priceUpToDate) = getPriceForKey(key);

        if (!priceUpToDate) {
            return getFallbackPrice(_asset);
        }

        if (_asset == USD_ASSET) {
            unchecked {
                // multiplication of decimals is safe, this are small values, division is safe as well
                return DIA_DECIMALS * EXPECTED_DECIMALS / assetPriceInUsd;
            }
        }

        (uint128 ethPriceInUsd, bool ethPriceUpToDate) = getPriceForKey(ETH_USD_KEY);

        if (!ethPriceUpToDate) {
            return getFallbackPrice(_asset);
        }

        return normalizePrice(assetPriceInUsd, ethPriceInUsd);
    }

    /// @dev Asset setup. Can only be called by the manager.
    /// Explanation from DIA team:
    ///     Updates will be done every time there is a deviation >1% btw the last onchain update and the current price.
    ///     We have a 24hrs default update though, so assuming the price remains completely flat you would still get
    ///     an update every 24hrs.
    /// @param _asset address Asset to setup
    /// @param _key string under this key asset price will be available in DIA oracle
    /// @param _liquidationProvider IPriceProvider on-chain provider that can help with liquidation
    /// it will not be use for providing price, it is only for liquidation process
    function setupAsset(
        address _asset,
        string calldata _key,
        IPriceProvider _liquidationProvider
    ) external virtual onlyManager {
        validateSymbol(_asset, _key);

        bool allowEthUsdKey;
        _setupAsset(_asset, _key, _liquidationProvider, allowEthUsdKey);
    }
    
    function setLiquidationProvider(address _asset, IPriceProvider _liquidationProvider) public virtual onlyManager {
        _setLiquidationProvider(_asset, _liquidationProvider);
    }

    function removeLiquidationProvider(address _asset) public virtual onlyManager {
        if (address(0) == address(liquidationProviders[_asset])) revert LiquidationProviderNotExist();

        delete liquidationProviders[_asset];

        emit LiquidationProvider(_asset, IPriceProvider(address(0)));
    }

    /// @dev for liquidation purposes and for compatibility with naming convention we already using in LiquidationHelper
    /// we have this method to return on-chain provider that can be useful for liquidation
    function getFallbackProvider(address _asset) external view virtual returns (IPriceProvider) {
        return liquidationProviders[_asset];
    }

    /// @dev _assetPriceInUsd uint128 asset price returned by DIA oracle (8 decimals)
    /// @dev _ethPriceInUsd uint128 ETH price returned by DIA oracle (8 decimals)
    /// @return assetPriceInEth uint256 18 decimals price in ETH
    function normalizePrice(uint128 _assetPriceInUsd, uint128 _ethPriceInUsd)
        public
        view
        virtual
        returns (uint256 assetPriceInEth)
    {
        uint256 withDecimals = _assetPriceInUsd * EXPECTED_DECIMALS;

        unchecked {
            // div is safe
            return withDecimals / _ethPriceInUsd;
        }
    }

    /// @dev checks if key has expected format.
    /// Atm provider is accepting only prices in USD, so key must end with "/USD".
    /// If key is invalid function will throw.
    /// @param _key string DIA key for asset
    function validateKey(string memory _key) public pure virtual {
        _validateKey(_key, false);
    }

    /// @dev checks if key match token symbol. Reverts if does not match.
    /// @param _asset address Asset to setup
    /// @param _key string under this key asset price will be available in DIA oracle
    function validateSymbol(address _asset, string memory _key) public view virtual {
        bytes memory symbol = bytes(IERC20Metadata(_asset).symbol());

        unchecked {
            // `+4` for `/USD`, we will never have key with length that will overflow
            if (symbol.length + 4 != bytes(_key).length) revert KeyDoesNotMatchSymbol();

            // we will never have key with length that will overflow, so i++ is safe
            for (uint256 i; i < symbol.length; i++) {
                if (symbol[i] != bytes(_key)[i]) revert KeyDoesNotMatchSymbol();
            }
        }
    }

    /// @dev this is info method for LiquidationHelper
    /// @return bool TRUE if provider is off-chain, means it is not a dex
    function offChainProvider() external pure virtual returns (bool) {
        return true;
    }

    /// @param _allowEthUsd bool use TRUE only when setting up `ETH_USD_KEY` key, FALSE in all other cases
    // solhint-disable-next-line code-complexity
    function _validateKey(string memory _key, bool _allowEthUsd) internal pure virtual {
        if (!_allowEthUsd) {
            if (keccak256(abi.encodePacked(_key)) == keccak256(abi.encodePacked(ETH_USD_KEY))) revert CanNotSetEthKey();
        }

        uint256 keyLength = bytes(_key).length;

        if (keyLength < 5) revert InvalidKey();

        unchecked {
            // keyLength is at least 5, based on above check, so it is safe to uncheck all below subtractions
            if (bytes(_key)[keyLength - 4] != "/") revert OnlyUSDPriceAccepted();
            if (bytes(_key)[keyLength - 3] != "U") revert OnlyUSDPriceAccepted();
            if (bytes(_key)[keyLength - 2] != "S") revert OnlyUSDPriceAccepted();
            if (bytes(_key)[keyLength - 1] != "D") revert OnlyUSDPriceAccepted();
        }
    }

    /// @param _asset Asset to setup
    /// @param _key string under this key asset price will be available in DIA oracle
    /// @param _liquidationProvider IPriceProvider on-chain provider that can help with liquidation
    /// it will not be use for providing price, it is only for liquidation process
    /// @param _allowEthUsd bool use TRUE only when setting up `ETH_USD_KEY` key, FALSE in all other cases
    function _setupAsset(
        address _asset,
        string memory _key,
        IPriceProvider _liquidationProvider,
        bool _allowEthUsd
    ) internal virtual {
        _validateKey(_key, _allowEthUsd);

        (uint128 latestPrice, bool priceUpToDate) = getPriceForKey(_key);

        if (latestPrice == 0) revert PriceCanNotBeFoundForProvidedKey();
        if (!priceUpToDate) revert OldPrice();

        keys[_asset] = _key;

        emit AssetSetup(_asset, _key);

        if (address(_liquidationProvider) != address(0)) {
            _setLiquidationProvider(_asset, _liquidationProvider);
        }
    }

    function _setLiquidationProvider(address _asset, IPriceProvider _liquidationProvider) internal virtual {
        if (!assetSupported(_asset)) revert AssetNotSupported();
        if (_liquidationProvider == liquidationProviders[_asset]) revert LiquidationProviderAlreadySet();
        if (!_liquidationProvider.assetSupported(_asset)) revert LiquidationProviderAssetNotSupported();

        liquidationProviders[_asset] = _liquidationProvider;

        emit LiquidationProvider(_asset, _liquidationProvider);
    }
}
