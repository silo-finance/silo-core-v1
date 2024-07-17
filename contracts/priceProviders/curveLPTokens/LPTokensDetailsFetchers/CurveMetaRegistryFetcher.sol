// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesBaseFetcher.sol";
import "../interfaces/ICurveCryptoSwapRegistryLike.sol";
import "../interfaces/ICurveAddressProviderLike.sol";
import "../interfaces/ICurveLPTokensDetailsFetcher.sol";
import "../../_common/PriceProvidersRepositoryManager.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve LP Tokens details fetcher for  Meta registry
/// @dev Registry id `7` in the Curve address provider
contract CurveMetaRegistryFetcher is PriceProvidersRepositoryManager, ICurveLPTokensDetailsFetcher {
    /// @dev Number of coins by the Curve Meta registry interface
    uint256 constant internal _MAX_NUMBER_OF_COINS = 8;
    /// @dev The registry identifier that this fetcher is designed for
    uint256 public constant REGISTRY_ID = 7; // solhint-disable-line var-name-mixedcase
    /// @dev Curve address provider
    ICurveAddressProviderLike public immutable ADDRESS_PROVIDER; // solhint-disable-line var-name-mixedcase
    /// @dev Curve registry address pulled from the Curve address provider.
    /// ICurveCryptoSwapRegistryLike is the same as we need for the MetaRegistry
    ICurveCryptoSwapRegistryLike public registry;

    /// @dev Revert if address provider address is empty
    error EmptyAddressProvider();
    /// @dev Revert if Curve registry is not changed
    error RegistryIsTheSame();
    /// @dev Revert if in the Curve address provider the registry is not found by the provided registry id
    error RegistryNotFoundById(uint256 id);

    /// @dev Emitted on creation
    /// @param curveAddressProvider The Curve address provider for a data fetcher
    /// @param registryId The Curve registry identifier in the Curve address provider for a data fetcher
    event DataFetcherCreated(ICurveAddressProviderLike curveAddressProvider, uint256 registryId);

    /// @param _repository Price providers repository address
    /// @param _addressProvider Curve address provider address
    constructor(
        IPriceProvidersRepository _repository,
        ICurveAddressProviderLike _addressProvider
    )
        PriceProvidersRepositoryManager(_repository)
    {
        if (address(_addressProvider) == address(0)) revert EmptyAddressProvider();

        ADDRESS_PROVIDER = _addressProvider;

        _updateRegistry();

        emit DataFetcherCreated(ADDRESS_PROVIDER, REGISTRY_ID);
    }

    /// @inheritdoc ICurveLPTokensDetailsFetcher
    function getLPTokenDetails(
        address _lpToken,
        bytes memory
    )
        external
        virtual
        view
        returns (
            LPTokenDetails memory details,
            bytes memory data
        )
    {
        details.pool.addr = registry.get_pool_from_lp_token(_lpToken);

        if (details.pool.addr == address(0)) {
            return (details, data);
        }

        uint256 length = 0;
        address[_MAX_NUMBER_OF_COINS] memory poolCoins = registry.get_coins(details.pool.addr);

        while (length < _MAX_NUMBER_OF_COINS) {
            if (poolCoins[length] == address(0)) break;

            // Because of the condition `length < 8` we can ignore overflow check
            unchecked { length++; }
        }

        details.coins = new address[](length);
        uint256 i = 0;

        while (i < length) {
            details.coins[i] = poolCoins[i];

            // Because of the condition `i < length` we can ignore overflow check
            unchecked { i++; }
        }
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
        address newRegistry = ADDRESS_PROVIDER.get_address(REGISTRY_ID);

        if (newRegistry == address(0)) revert RegistryNotFoundById(REGISTRY_ID);
        if (address(registry) == newRegistry) revert RegistryIsTheSame();

        registry = ICurveCryptoSwapRegistryLike(newRegistry);

        emit RegistryUpdated(newRegistry);
    }
}
