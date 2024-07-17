// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../_common/CurveLPTokensDataTypes.sol";
import "../../../interfaces/IPriceProvider.sol";

/// @notice A price provider for Curve LP Tokens
interface ICurveLPTokensPriceProvider is IPriceProvider {
    /// @notice Enable Curve LP token in the price provider
    /// @param _lpToken Curve LP Token address that will be enabled in the price provider
    function setupAsset(address _lpToken) external;

    /// @notice Enable a list of Curve LP tokens in the price provider
    /// @param _lpTokens List of Curve LP Tokens addresses that will be enabled in the price provider
    function setupAssets(address[] memory _lpTokens) external;
}
