// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve pool.
/// @dev Includes only methods for CurveLPTokensPriceProviders.
interface ICurvePoolLike {
    /// Description from Curve docs:
    /// @notice Returns portfolio virtual price (for calculating profit) scaled up by 1e18
    //  solhint-disable-next-line func-name-mixedcase
    function get_virtual_price() external view returns (uint256);
}
