// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../_common/CurveLPTokensDataTypes.sol";
import "../interfaces/ICurveAddressProviderLike.sol";
import "../interfaces/ICurveLPTokensDetailsFetcher.sol";
import "../../_common/PriceProvidersRepositoryManager.sol";

/// @title Curve registries base fetcher
abstract contract CurveRegistriesBaseFetcher is PriceProvidersRepositoryManager, ICurveLPTokensDetailsFetcher {
    /// @dev The registry identifier that this fetcher is designed for
    RegistryId public immutable REGISTRY_ID; // solhint-disable-line var-name-mixedcase
    /// @dev Curve address provider
    ICurveAddressProviderLike public immutable ADDRESS_PROVIDER; // solhint-disable-line var-name-mixedcase
    /// @dev Curve registry address pulled from the Curve address provider.
    /// As Main Registry, CryptoSwap Registry, Metapool Factory, and Cryptopool Factory have different
    /// interfaces we will store registry as an address as it is a base contract that will be used for
    /// each registry and it must have a common type.
    address public registry;

    /// @dev Revert if address provider address is empty
    error EmptyAddressProvider();
    /// @dev Revert if Curve registry is not changed
    error RegistryIsTheSame();
    /// @dev Revert if in the Curve address provider the registry is not found by the provided registry id
    error RegistryNotFoundById(RegistryId id);

    /// @dev Emitted on creation
    /// @param curveAddressProvider The Curve address provider for a data fetcher
    /// @param registryId The Curve registry identifier in the Curve address provider for a data fetcher
    event DataFetcherCreated(ICurveAddressProviderLike curveAddressProvider, RegistryId registryId);

    /// @dev Curve address provider contract address is immutable and it’s address will never change.
    /// We do it configurable to make a code compliant with different networks in the case if 
    /// address will differs for them.
    /// @param _curveAddressProvider Curve address provider
    /// @param _id Curve registry identifier. See CurveLPTokensDataTypes.RegistryId
    constructor(ICurveAddressProviderLike _curveAddressProvider, RegistryId _id) {
        if (address(_curveAddressProvider) == address(0)) revert EmptyAddressProvider();

        REGISTRY_ID = _id;
        ADDRESS_PROVIDER = _curveAddressProvider;

        _updateRegistry();

        emit DataFetcherCreated(ADDRESS_PROVIDER, REGISTRY_ID);
    }

    /// @inheritdoc ICurveLPTokensDetailsFetcher
    function updateRegistry() external virtual onlyManager() {
        _updateRegistry();
    }

    /// @inheritdoc ICurveLPTokensDetailsFetcher
    function curveLPTokensDetailsFetcherPing() external virtual pure returns (bytes4) {
        return this.curveLPTokensDetailsFetcherPing.selector;
    }

    /// @notice Updates a registry address from the Curve address provider
    /// @dev Reverts if an address is not found or is the same as current address
    function _updateRegistry() internal {
        address newRegistry = ADDRESS_PROVIDER.get_address(uint256(REGISTRY_ID));

        if (newRegistry == address(0)) revert RegistryNotFoundById(REGISTRY_ID);
        if (registry == newRegistry) revert RegistryIsTheSame();

        registry = newRegistry;

        emit RegistryUpdated(newRegistry);
    }
}
