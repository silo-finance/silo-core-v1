// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../../../interfaces/IPriceProvider.sol";
import "../../../priceProviders/curveLPTokens/_common/CurveLPTokensDataTypes.sol";

interface ICurveLPTokensPriceProviderLike is IPriceProvider {
    function lpTokenPool(address _lpToken) external view returns (Pool memory);
    function getCoins(address _lpToken) external view returns (PoolCoin[] memory);
}
