// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesBaseFetcher.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";
import "../interfaces/ICurveMetaPoolFactoryLike.sol";

/// @title Curve LP Tokens details fetcher for Meta Pool Factory
/// @dev Registry id `3` in the Curve address provider
contract CurveMetaPoolFactoryFetcher is CurveRegistriesBaseFetcher {
    /// @dev Number of coins by the Curve Meta Pool Factory interface
    uint256 constant internal _MAX_NUMBER_OF_COINS = 4;

    /// @dev Constructor is required for indirect CurveRegistriesBaseFetcher and
    /// PriceProvidersRepositoryManager initialization. Arguments for CurveRegistriesBaseFetcher
    /// initialization are given in the modifier-style in the derived constructor.
    /// CurveMetaPoolFactoryFetcher constructor body should be empty as we need to do nothing.
    /// @param _repository Price providers repository address
    /// @param _addressProvider Curve address provider address
    constructor(
        IPriceProvidersRepository _repository,
        ICurveAddressProviderLike _addressProvider
    )
        PriceProvidersRepositoryManager(_repository)
        CurveRegistriesBaseFetcher(_addressProvider, RegistryId.META_POOL_FACTORY_3)
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
        uint256 numberOfCoins = 0;
        ICurveMetaPoolFactoryLike metaPoolFactory = ICurveMetaPoolFactoryLike(registry);
        address[_MAX_NUMBER_OF_COINS] memory poolCoins = metaPoolFactory.get_coins(_lpToken);

        if (poolCoins[0] == address(0)) {
            return (details, data);
        }

        while (numberOfCoins < _MAX_NUMBER_OF_COINS) {
            if (poolCoins[numberOfCoins] == address(0)) break;

            // Because of the condition `numberOfCoins < _MAX_NUMBER_OF_COINS` we can ignore overflow check
            unchecked { numberOfCoins++; }
        }

        details.coins = new address[](numberOfCoins);
        uint256 i = 0;

        while (i < numberOfCoins) {
            details.coins[i] = poolCoins[i];

            // Because of the condition `i < numberOfCoins` we can ignore overflow check
            unchecked { i++; }
        }

        // In the Curve Meta Pool Factory LP Tokens are pools
        details.pool.addr = _lpToken;
        details.pool.isMeta = metaPoolFactory.is_meta(_lpToken);
    }
}
