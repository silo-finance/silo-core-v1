// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve registry.
/// @dev Includes only methods for CurveLPTokensPriceProvider.
interface ICurveRegistryLike {
    /// @param _lpToken LP Token address to fetch a pool address for
    /// @return Pool address associated with `_lpToken`
    //  solhint-disable-next-line func-name-mixedcase
    function get_pool_from_lp_token(address _lpToken) external view returns (address);

    /// @notice Verifies whether a pool is meta pool
    /// @param _pool Pool address to be verified
    /// @return Boolean value that shows if a pool is a meta pool or not
    //  solhint-disable-next-line func-name-mixedcase
    function is_meta(address _pool) external view returns (bool);

    /// @param _pool Pool address to fetch coins for
    /// @return A list of coins in the pool
    //  solhint-disable-next-line func-name-mixedcase
    function get_coins(address _pool) external view returns (address[8] memory);
}
