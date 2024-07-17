// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesBaseFetcher.sol";
import "../interfaces/ICurveMainRegistryLike.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve LP Tokens details fetcher for Main Registry
/// @dev Registry id `0` in the Curve address provider
contract CurveMainRegistryFetcher is CurveRegistriesBaseFetcher {
    /// @dev Number of coins by the Curve Main Registry interface
    uint256 constant internal _MAX_NUMBER_OF_COINS = 8;

    /// @dev Constructor is required for indirect CurveRegistriesBaseFetcher and
    /// PriceProvidersRepositoryManager initialization. Arguments for CurveRegistriesBaseFetcher
    /// initialization are given in the modifier-style in the derived constructor.
    /// CurveMainRegistryFetcher constructor body should be empty as we need to do nothing.
    /// @param _repository Price providers repository address
    /// @param _addressProvider Curve address provider address
    constructor(
        IPriceProvidersRepository _repository,
        ICurveAddressProviderLike _addressProvider
    )
        PriceProvidersRepositoryManager(_repository)
        CurveRegistriesBaseFetcher(_addressProvider, RegistryId.MAIN_REGISTRY_0)
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
        ICurveMainRegistryLike mainRegistry = ICurveMainRegistryLike(registry);
        details.pool.addr = mainRegistry.get_pool_from_lp_token(_lpToken);

        if (details.pool.addr == address(0)) {
            return (details, data);
        }

        details.pool.isMeta = mainRegistry.is_meta(details.pool.addr);

        uint256 numberOfCoins = 0;
        address[_MAX_NUMBER_OF_COINS] memory poolCoins = mainRegistry.get_coins(details.pool.addr);

        while (numberOfCoins < _MAX_NUMBER_OF_COINS) {
            if (poolCoins[numberOfCoins] == address(0)) break;

            // Because of the condition `numberOfCoins < 8` we can ignore overflow check
            unchecked { numberOfCoins++; }
        }

        details.coins = new address[](numberOfCoins);
        uint256 i = 0;

        while (i < numberOfCoins) {
            details.coins[i] = poolCoins[i];
            // Because of the condition `i < numberOfCoins` we can ignore overflow check
            unchecked { i++; }
        }
    }
}
