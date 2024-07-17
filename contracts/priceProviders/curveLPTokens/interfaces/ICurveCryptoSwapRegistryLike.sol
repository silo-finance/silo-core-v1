// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve CryptoSwap Registry.
/// @dev As curve protocol is implemented with Vyper programming language and we don't use
/// all the methods present in the Curve address provider. We'll have a solidity version of the interface
/// that includes only methods required to retrieve LP token details as are necessary for a price calculation.
interface ICurveCryptoSwapRegistryLike {
    /// @param _lpToken LP Token address to fetch a pool address for
    /// @return Pool address associated with `_lpToken`
    //  solhint-disable-next-line func-name-mixedcase
    function get_pool_from_lp_token(address _lpToken) external view returns (address);

    /// @param _pool Curve pool address
    /// @return LP Token address associated with `_pool`
    //  solhint-disable-next-line func-name-mixedcase
    function get_lp_token(address _pool) external view returns (address);

    /// @param _pool Pool address to fetch coins for
    /// @return A list of coins in the pool
    //  solhint-disable-next-line func-name-mixedcase
    function get_coins(address _pool) external view returns (address[8] memory);
}
