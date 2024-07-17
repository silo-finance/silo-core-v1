// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./../../lib/TokenHelper.sol";
import "../chainlinkV3/ChainlinkV3PriceProvider.sol";
import "./WSTETHPriceProvider.sol";
import "../../interfaces/IPriceProviderV2.sol";


/// @title WSTETHPriceByChainlinkArbitrum
/// @notice WSTETHPriceByChainlinkArbitrum is the price provider for wstETH token for Arbitrum.
/// Price calculations depends on the price of stETH and wstETH-stETH Exchange Rate.
/// @custom:security-contact security@silo.finance
/// @dev wstETH-stETH Exchange Rate rate reported by chainlink, means that for 1 wstETH we will get X of stETH
/// with stETH/ETH aggregator: 1 stETH will give us N ETH
/// wstETH price = X stETH price * N (STETH / ETH)
/// to reuse quote functionality: `_price * 10 ** _QUOTE_TOKEN_DECIMALS / uint256(aggregatorPrice);`
/// we need to change `/` to `*`
contract WSTETHPriceByChainlinkArbitrum is ChainlinkV3PriceProvider, IPriceProviderV2 {
    address public immutable WSTETH; // solhint-disable-line var-name-mixedcase

    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        address _emergencyManager,
        AggregatorV3Interface _stEthPriceAggregator,
        uint256 _stEthPriceAggregatorHeartbeat,
        address _wstETH
    )
        ChainlinkV3PriceProvider(
            _priceProvidersRepository,
            _emergencyManager,
            _stEthPriceAggregator,
            _stEthPriceAggregatorHeartbeat
        )
    {
        WSTETH = _wstETH;
    }

    /// @inheritdoc ChainlinkV3PriceProvider
    /// @notice this method overrides original to make sure `_convertToQuote` is always true, because we will be using
    /// `toQuote` to calculate wstETH price.
    function setupAsset(
        address _asset,
        AggregatorV3Interface _aggregator,
        IPriceProvider _fallbackProvider,
        uint256 _heartbeat,
        bool _convertToQuote
    ) external virtual override onlyManager {
        _convertToQuote = true;

        // This has to be done first so that `_setAggregator` works
        _setHeartbeat(_asset, _heartbeat);

        if (!_setAggregator(_asset, _aggregator, _convertToQuote)) revert AggregatorDidNotChange();

        // We don't care if this doesn't change
        _setFallbackPriceProvider(_asset, _fallbackProvider);
    }

    function getFallbackProvider(address _asset)
        external
        view
        override(ChainlinkV3PriceProvider, IPriceProviderV2)
        returns (IPriceProvider)
    {
        return assetData[_asset].fallbackProvider;
    }

    function offChainProvider() external pure returns (bool) {
        return true;
    }

    /// @dev this provider is only for wstETH
    function assetSupported(address _asset)
        public
        view
        virtual
        override(ChainlinkV3PriceProvider, IPriceProvider)
        returns (bool)
    {
        return _asset == WSTETH;
    }

    /// @dev to reuse quote functionality: `_price * 10 ** _QUOTE_TOKEN_DECIMALS / uint256(aggregatorPrice);`
    /// we need to change `/` to `*` for this provider.
    function _toQuote(uint256 _exchangeRate) internal view virtual override returns (uint256) {
        (
            /*uint80 roundID*/,
            int256 stEthPrice,
            /*uint256 startedAt*/,
            uint256 timestamp,
            /*uint80 answeredInRound*/
        ) = _QUOTE_AGGREGATOR.latestRoundData();

        // If an invalid price is returned
        if (!_isValidPrice(stEthPrice, timestamp, quoteAggregatorHeartbeat)) {
            revert AggregatorPriceNotAvailable();
        }

        // _price and aggregatorPrice should both have the same decimals so we normalize here
        return _exchangeRate * uint256(stEthPrice) / 10 ** _QUOTE_TOKEN_DECIMALS;
    }
}
