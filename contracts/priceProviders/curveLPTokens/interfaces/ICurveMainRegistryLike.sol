// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve Main Registry.
/// @dev As curve protocol is implemented with Vyper programming language and we don't use
/// all the methods present in the Curve address provider. We'll have a solidity version of the interface
/// that includes only methods required to retrieve LP token details as are necessary for a price calculation.
interface ICurveMainRegistryLike {
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
