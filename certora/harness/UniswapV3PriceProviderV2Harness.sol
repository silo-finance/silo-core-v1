// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.6;
pragma abicoder v2;

import "../../contracts/priceProviders/uniswapV3/UniswapV3PriceProviderV2.sol";

contract UniswapV3PriceProviderV2Harness is UniswapV3PriceProviderV2 {
    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        IUniswapV3Factory _factory,
        PriceCalculationData memory _priceCalculationData
    ) UniswapV3PriceProviderV2(
        _priceProvidersRepository,
        _factory,
        _priceCalculationData
    ) {}

    function getJustPool(address _asset, uint256 _ix) external view returns (address) {
        PricePath[] memory path = UniswapV3PriceProviderV2(this).pools(_asset);
        return address(path[_ix].pool);
    }

    function getPeriodForAvgPrice() external view returns (uint32) {
        return priceCalculationData.periodForAvgPrice;
    }

    function getBlockTime() external view returns (uint8) {
        return priceCalculationData.blockTime;
    }

    function verifyPoolsHarness(address _asset, IUniswapV3Pool[] calldata _pools) external view returns (uint256) {
        PricePath[] memory path = verifyPools(_asset, _pools);
        return path.length;
    }
}
