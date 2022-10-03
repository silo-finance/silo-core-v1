// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve address provider for the registry contracts.
/// @dev As curve protocol is implemented with Vyper programming language and we don't use
/// all the methods present in the Curve address provider. We'll have a solidity version
/// of the interface that includes only methods required for Silo's Curve LP Tokens price providers.
interface ICurveAddressProviderLike {
    /// Description from Curve docs:
    /// @notice Fetch the address associated with `_id`
    /// @dev Returns ZERO_ADDRESS if `_id` has not been defined, or has been unset
    /// @param _id Identifier to fetch an address for
    /// @return Current address associated to `_id`
    //  solhint-disable-next-line func-name-mixedcase
    function get_address(uint256 _id) external view returns (address);
}
