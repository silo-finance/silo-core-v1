// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../_common/CurveLPTokensDataTypes.sol";
import "../interfaces/ICurveAddressProviderLike.sol";
import "../interfaces/ICurveLPTokensDetailsHandler.sol";
import "../../_common/PriceProvidersRepositoryManager.sol";

/// @title Curve registries base handler
abstract contract CurveRegistriesBaseHandler is PriceProvidersRepositoryManager, ICurveLPTokensDetailsHandler {
    /// @dev The registry identifier that this handler is designed for
    RegistryId public immutable registryId;
    /// @dev Curve address provider
    ICurveAddressProviderLike private immutable _addressProvider;
    /// @dev Curve registry address pulled from the Curve address provider.
    /// As Main Registry, CryptoSwap Registry, Metapool Factory, and Cryptopool Factory have different
    /// interfaces we will store registry as an address as it is a base contract that will be used for
    /// each registry and it must have a common type.
    address private _registry;

    /// @dev Revert if address provider address is empty
    error EmptyAddressProvider();
    /// @dev Revert if Curve registry is not changed
    error RegistryIsTheSame();
    /// @dev Revert if in the Curve address provider the registry is not found by the provided registry id
    error RegistryNotFoundById(RegistryId id);

    /// @dev Emitted on creation
    /// @param curveAddressProvider The Curve address provider for a data handler
    /// @param registryId The Curve registry identifier in the Curve address provider for a data handler
    event DataHandlerCreated(ICurveAddressProviderLike curveAddressProvider, RegistryId registryId);

    /// @dev Curve address provider contract address is immutable and it’s address will never change.
    /// We do it configurable to make a code compliant with different networks in the case if 
    /// address will differs for them.
    /// @param _curveAddressProvider Curve address provider
    /// @param _id Curve registry identifier. See CurveLPTokensDataTypes.RegistryId
    constructor(ICurveAddressProviderLike _curveAddressProvider, RegistryId _id) {
        if (address(_curveAddressProvider) == address(0)) revert EmptyAddressProvider();

        _addressProvider = _curveAddressProvider;

        registryId = _id;

        _updateRegistry();

        emit DataHandlerCreated(_addressProvider, registryId);
    }

    /// @inheritdoc ICurveLPTokensDetailsHandler
    function updateRegistry() external onlyManager() {
        _updateRegistry();
    }

    /// @return The Curve address provider
    function curveAddressProvider() external view returns (address) {
        return address(_addressProvider);
    }

    /// @inheritdoc ICurveLPTokensDetailsHandler
    function curveRegistryHandlerPing() external pure returns (bytes4) {
        return this.curveRegistryHandlerPing.selector;
    }

    /// @return The Curve registry address
    function registry() public view returns (address) {
        return _registry;
    }

    /// @notice Updates a registry address from the Curve address provider
    /// @dev Reverts if an address is not found or is the same as current address
    function _updateRegistry() internal {
        address newRegistry = _addressProvider.get_address(uint256(registryId));

        if (newRegistry == address(0)) revert RegistryNotFoundById(registryId);
        if (_registry == newRegistry) revert RegistryIsTheSame();

        _registry = newRegistry;

        emit RegistryUpdated(newRegistry);
    }
}
