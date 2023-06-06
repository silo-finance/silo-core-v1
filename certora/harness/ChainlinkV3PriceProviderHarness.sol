// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../../contracts/priceProviders/chainlinkV3/ChainlinkV3PriceProvider.sol";

contract ChainlinkV3PriceProviderHarness is ChainlinkV3PriceProvider {
    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        address _emergencyManager,
        AggregatorV3Interface _quoteAggregator,
        uint256 _quoteAggregatorHeartbeat
    ) ChainlinkV3PriceProvider(
        _priceProvidersRepository,
        _emergencyManager,
        _quoteAggregator,
        _quoteAggregatorHeartbeat
    ) {}


    function getLatestRoundData(address asset) external view returns(uint80, int256, uint256, uint256, uint80) {
        return assetData[asset].aggregator.latestRoundData();
    }

    function getFallbackPrice(address asset) external view returns(uint256) {
        return assetData[asset].fallbackProvider.getPrice(asset);
    }

    function getAggregatorDecimals(address asset) external view returns(uint8) {
        return assetData[asset].aggregator.decimals();
    }

    function getQuoteTokenDecimals() external view returns(uint8) {
        return IERC20LikeV2(quoteToken).decimals();
    }
}
