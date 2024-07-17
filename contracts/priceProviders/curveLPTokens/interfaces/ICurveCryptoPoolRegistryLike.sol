// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve Crypto Pool Registry.
/// @dev As curve protocol is implemented with Vyper programming language and we don't use
/// all the methods present in the Curve address provider. We'll have a solidity version of the interface
/// that includes only methods required to retrieve LP token details as are necessary for a price calculation.
interface ICurveCryptoPoolRegistryLike {
    /// @param _pool Pool address to fetch coins for
    /// @return A list of coins in the pool
    //  solhint-disable-next-line func-name-mixedcase
    function get_coins(address _pool) external view returns (address[2] memory);
}
