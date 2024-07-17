// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve pool.
/// @dev Includes only methods for CurveLPTokensPriceProviders.
interface ICurvePoolNonPeggedAssetsLike {
    /// Description from Curve docs:
    /// @notice Approximate LP token price
    /// @dev n * self.virtual_price * self.sqrt_int(self.internal_price_oracle()) / 10**18
    /// where n is a number of coins in the pool
    //  solhint-disable-next-line func-name-mixedcase
    function lp_price() external view returns (uint256);
}
