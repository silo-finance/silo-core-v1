// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesBaseHandler.sol";
import "../interfaces/ICurveMainRegistryLike.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve LP Tokens details handler for Main Regisry
/// @dev Registry id `0` in the Curve address provider
contract CurveMainRegistryHandler is CurveRegistriesBaseHandler {
    /// @dev Number of coins by the Curve Main Registry interface
    uint256 constant private _MAX_NUMBER_OF_COINS = 8;

    /// @dev Constructor is required for indirect CurveRegistriesBaseHandler and
    /// PriceProvidersRepositoryManager initialization. Arguments for CurveRegistriesBaseHandler
    /// initialization are given in the modifier-style in the derived constructor.
    /// CurveMainRegistryHandler constructor body should be empty as we need to do nothing.
    /// @param _repository Price providers repository address
    /// @param _addressProvider Curve address provider address
    constructor(
        IPriceProvidersRepository _repository,
        ICurveAddressProviderLike _addressProvider
    )
        PriceProvidersRepositoryManager(_repository)
        CurveRegistriesBaseHandler(_addressProvider, RegistryId._0)
    {
        /// @dev The code will not compile without it. So, we need to keep an empty constructor.
    }

    /// @inheritdoc ICurveLPTokensDetailsHandler
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
        ICurveMainRegistryLike registry = ICurveMainRegistryLike(registry());
        details.pool.addr = registry.get_pool_from_lp_token(_lpToken);

        if (details.pool.addr == address(0)) {
            return (details, data);
        }

        details.pool.isMeta = registry.is_meta(details.pool.addr);
        details.pool.registryId = registryId;

        uint8 length = 0;
        address[_MAX_NUMBER_OF_COINS] memory poolCoins = registry.get_coins(details.pool.addr);

        while (length < _MAX_NUMBER_OF_COINS) {
            if (poolCoins[length] == address(0)) break;

            /// Because of the condition `length < 8` we can ignore overflow check
            unchecked { length++; }
        }

        details.coins = new address[](length);
        uint8 i = 0;

        while (i < length) {
            details.coins[i] = poolCoins[i];
            /// Because of the condition `i < length` we can ignore overflow check
            unchecked { i++; }
        }
    }
}
