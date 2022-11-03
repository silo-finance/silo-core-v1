// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../PriceProvider.sol";
import "./../../lib/TokenHelper.sol";

/// @dev Simplified version of the gOHM token interface with the method that is required for the gOHM price calculation.
interface IgOHMLike {
    /// @dev Rebase index, 1e9 base unit is used.
    function index() external view returns (uint256);
}

/// @title GOHMPriceProvider
/// @notice GOHMPriceProvider is the price provider for gOHM token. Price calculations depends
/// on the price of OHMv2. Price providers repository must be ready to provide the OHMv2 price.
/// @custom:security-contact security@silo.finance
contract GOHMPriceProvider is PriceProvider {
    /// @dev Base units for the rebase index value
    uint256 public constant OHM_INDEX_BASE_UNITS = 1e9;

    /// @dev Original rebasing token, OHMv2
    // solhint-disable-next-line var-name-mixedcase
    address public immutable OHM;

    /// @dev gOHM is a wrapper of the rebasing OHM token
    // solhint-disable-next-line var-name-mixedcase
    IgOHMLike public immutable GOHM;

    error AssetNotSupported();
    error InvalidGOHMAddress();
    error InvalidOHMAddress();

    /// @dev Inside constructor there is a check of gOHM address.
    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        address _ohm,
        IgOHMLike _gOhm
    ) PriceProvider(_priceProvidersRepository) {
        // Sanity check to verify if gOHM token `index` method will return data and will not revert.
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory data) = address(_gOhm).staticcall(abi.encodeCall(IgOHMLike.index, ()));
        if (!success || data.length == 0) revert InvalidGOHMAddress();

        if (keccak256(abi.encode(TokenHelper.symbol(address(_gOhm)))) != keccak256(abi.encode("gOHM"))) {
            revert InvalidGOHMAddress();
        }

        if (keccak256(abi.encode(TokenHelper.symbol(_ohm))) != keccak256(abi.encode("OHM"))) {
            revert InvalidOHMAddress();
        }

        OHM = _ohm;
        GOHM = _gOhm;
    }

    /// @notice Returns the current index of rebasing token per one wrapped token (total amount of rebases) in
    /// OHM_INDEX_BASE_UNITS
    function index() external view virtual returns (uint256) {
        return GOHM.index();
    }

    /// @notice Only gOHM token is supported, false otherwise.
    /// @param _asset address of an asset
    function assetSupported(address _asset) public view virtual override returns (bool) {
        return _asset == address(GOHM);
    }

    /// @inheritdoc IPriceProvider
    function getPrice(address _asset) public view virtual override returns (uint256 gOhmPrice) {
        if (!assetSupported(_asset)) revert AssetNotSupported();

        gOhmPrice = priceProvidersRepository.getPrice(OHM) * GOHM.index();

        // We can uncheck safely to save some gas. OHM_INDEX_BASE_UNITS is a non-zero constant number.
        unchecked {
            gOhmPrice = gOhmPrice / OHM_INDEX_BASE_UNITS;
        }
    }
}
