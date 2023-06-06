// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.6;
pragma abicoder v2;

import "../../contracts/priceProviders/uniswapV3/UniswapV3PriceProvider.sol";

contract UniswapV3PriceProviderHarness is UniswapV3PriceProvider {
    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        IUniswapV3Factory _factory,
        PriceCalculationData memory _priceCalculationData
    ) UniswapV3PriceProvider(
        _priceProvidersRepository,
        _factory,
        _priceCalculationData
    ) {}

    function getPeriodForAvgPrice() external view returns (uint32) {
        return priceCalculationData.periodForAvgPrice;
    }

    function getChangeBlockTime() external view returns (uint8) {
        return priceCalculationData.blockTime;
    }
}
