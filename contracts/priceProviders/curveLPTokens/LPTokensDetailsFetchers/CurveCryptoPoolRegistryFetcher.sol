// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesBaseFetcher.sol";
import "../interfaces/ICurveCryptoPoolRegistryLike.sol";
import "../_common/CurveMinterResolver.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve LP Tokens details fetcher for Cryptopool Registry
/// @dev Registry id `6` in the Curve address provider
contract CurveCryptoPoolRegistryFetcher is CurveRegistriesBaseFetcher {
    using CurveMinterResolver for address;

    /// @dev Number of coins by the Curve Main Registry interface
    uint256 constant public MAX_NUMBER_OF_COINS = 2;

    /// @dev Constructor is required for indirect CurveRegistriesBaseFetcher and
    /// PriceProvidersRepositoryManager initialization. Arguments for CurveRegistriesBaseFetcher
    /// initialization are given in the modifier-style in the derived constructor.
    /// CurveCryptoPoolRegistryFetcher constructor body should be empty as we need to do nothing.
    /// @param _repository Price providers repository address
    /// @param _addressProvider Curve address provider address
    constructor(
        IPriceProvidersRepository _repository,
        ICurveAddressProviderLike _addressProvider
    )
        PriceProvidersRepositoryManager(_repository)
        CurveRegistriesBaseFetcher(_addressProvider, RegistryId.CRYPTO_POOL_FACTORY_6)
    {
        // The code will not compile without it. So, we need to keep an empty constructor.
    }

    /// @inheritdoc ICurveLPTokensDetailsFetcher
    function getLPTokenDetails(
        address _lpToken,
        bytes memory
    )
        external
        view
        returns (
            LPTokenDetails memory details,
            bytes memory data
        )
    {
        details.pool.addr = _lpToken.getMinter();

        if (details.pool.addr == address(0)) {
            return (details, data);
        }

        ICurveCryptoPoolRegistryLike registry = ICurveCryptoPoolRegistryLike(registry);
        address[MAX_NUMBER_OF_COINS] memory poolCoins = registry.get_coins(details.pool.addr);

        if (poolCoins[0] == address(0)) {
            // Some pools have method `minter` to resolve a pool but registered in the different registry
            // For example tricrypto2. So, we need to check if we can get coins from the registry.
            details.pool.addr = address(0);

            return (details, data);
        }

        details.coins = new address[](MAX_NUMBER_OF_COINS);
        details.coins[0] = poolCoins[0];
        details.coins[1] = poolCoins[1];
    }
}
