// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesPoolsManagement.sol";
import "../interfaces/ICurveCryptoSwapRegistryLike.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve LP Tokens details fetcher for CryptoSwap Registry
/// @dev Registry id `5` in the Curve address provider
contract CurveCryptoSwapRegistryFetcher is CurveRegistriesPoolsManagement {
    /// @dev Number of coins by the Curve CryptoSwap Registry interface
    uint256 constant internal _MAX_NUMBER_OF_COINS = 8;

    /// @dev Constructor is required for indirect CurveRegistriesBaseFetcher and
    /// PriceProvidersRepositoryManager initialization. Arguments for CurveRegistriesBaseFetcher
    /// initialization are given in the modifier-style in the derived constructor.
    /// CurveCryptoSwapRegistryFetcher constructor body should be empty as we need to do nothing.
    /// @param _repository Price providers repository address
    /// @param _addressProvider Curve address provider address
    /// @param _pools A list of pools with details for a fetcher initialization
    constructor(
        IPriceProvidersRepository _repository,
        ICurveAddressProviderLike _addressProvider,
        Pool[] memory _pools
    )
        PriceProvidersRepositoryManager(_repository)
        CurveRegistriesBaseFetcher(_addressProvider, RegistryId.CRYPTO_SWAP_REGISTRY_5)
        CurveRegistriesPoolsManagement(_pools)
    {
        // The code will not compile without it. So, we need to keep an empty constructor.
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
        ICurveCryptoSwapRegistryLike registry = ICurveCryptoSwapRegistryLike(registry);
        details.pool.addr = registry.get_pool_from_lp_token(_lpToken);

        if (details.pool.addr == address(0)) {
            return (details, data);
        }

        RegisteredPool memory pool = registeredPools[details.pool.addr];

        // It can happen in the case when the Curve protocol team adds a new pool
        // via the `add_pool` function directly in the CryptoSwap Registry but, it is not
        // registered in the `CurveCryptoSwapRegistryFetcher` yet.
        // We need to call `CurveCryptoSwapRegistryFetcher.addPools`.
        if (!pool.isRegistered) {
            details.pool.addr = address(0);
            return (details, data);
        }

        details.pool.isMeta = pool.isMeta;

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
}
