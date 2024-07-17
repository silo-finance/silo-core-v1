// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveReentrancyCheck.sol";
import "./CurveLPTokensPAPBaseCache.sol";
import "../interfaces/ICurvePoolLike.sol";
import "../interfaces/ICurveLPTokensDetailsFetchersRepository.sol";
import "../interfaces/ICurveLPTokensPriceProvider.sol";
import "../../_common/PriceProviderPing.sol";
import "../../_common/PriceProvidersRepositoryQuoteToken.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";
import "../../../lib/MathHelpers.sol";

/// @title Curve pegged pools tokens price provider
/// @dev PAP - pegged assets pools
contract CurvePAPTokensPriceProvider is
    CurveReentrancyCheck,
    CurveLPTokensPAPBaseCache,
    PriceProvidersRepositoryQuoteToken,
    PriceProviderPing,
    ICurveLPTokensPriceProvider
{
    using MathHelpers for uint256[];

    /// @dev Maximal number of coins in the Curve pools
    uint256 constant internal _MAX_NUMBER_OF_COINS = 8;

    /// @dev Revert in the case when the `@nonreentrant('lock')` is activated in the Curve pool
    error NonreentrantLockIsActive();

    /// @dev Constructor is required for indirect CurveLPTokensPriceProvider initialization.
    /// Arguments for CurveLPTokensPriceProvider initialization are given in the
    /// modifier-style in the derived constructor. There are no requirements during
    /// CurvePAPTokensPriceProvider deployment, so the constructor body should be empty.
    constructor(
        IPriceProvidersRepository _providersRepository,
        ICurveLPTokensDetailsFetchersRepository _fetchersRepository,
        address _nullAddr,
        address _nativeWrappedAddr
    )
        PriceProvidersRepositoryManager(_providersRepository)
        CurveLPTokenDetailsBaseCache(_fetchersRepository, _nullAddr, _nativeWrappedAddr)
    {
        // The code will not compile without it. So, we need to keep an empty constructor.
    }

    /// @inheritdoc ICurveReentrancyCheck
    function setReentrancyVerificationConfig(
        address _pool,
        uint128 _gasLimit,
        N_COINS _nCoins
    )
        external
        virtual
        onlyManager
    {
        _setReentrancyVerificationConfig(_pool, _gasLimit, _nCoins);
    }

    /// @inheritdoc ICurveLPTokensPriceProvider
    function setupAsset(address _lpToken) external virtual onlyManager {
        _setUpAssetAndEnsureItIsSupported(_lpToken);
    }

    /// @inheritdoc ICurveLPTokensPriceProvider
    function setupAssets(address[] calldata _lpTokens) external virtual onlyManager {
        uint256 i = 0;

        while(i < _lpTokens.length) {
            _setUpAssetAndEnsureItIsSupported(_lpTokens[i]);

            // Ignoring overflow check as it is impossible
            // to have more than 2 ** 256 - 1 LP Tokens for initialization.
            unchecked { i++; }
        }
    }

    /// @inheritdoc IPriceProvider
    function assetSupported(address _lpToken) external virtual view returns (bool) {
        return lpTokenPool[_lpToken].addr != address(0);
    }

    /// @param _lpToken Curve LP Token address for which a price to be calculated
    /// @return price of the `_lpToken` denominated in the price providers repository quote token
    function getPrice(address _lpToken) external virtual view returns (uint256 price) {
        address pool = lpTokenPool[_lpToken].addr;

        if (pool == address(0)) revert NotSupported();

        if (isLocked(pool)) revert NonreentrantLockIsActive();

        uint256 minPrice = _lpTokenPoolCoinsPrices(_lpToken).minValue();
        uint256 virtualPrice = ICurvePoolLike(pool).get_virtual_price();

        // `_lpToken` price calculation
        // Expect a `virtualPrice` to be a value close to 10 ** 18.
        // So, to have an overflow here a `minPrice` value must be approximately > 10 ** 59.
        // About the price calculation algorithm:
        // https://news.curve.fi/chainlink-oracles-and-curve-pools/
        price = minPrice * virtualPrice;

        // It doesn't make sense to do any math check here because if a `price` < 1e18,
        // in any case, it will return 0. Otherwise, we are fine.
        unchecked { price = price / 1e18; }

        // Zero price is unacceptable
        if (price == 0) revert ZeroPrice();
    }

    /// @notice Getter that resolves a list of the underlying coins for an LP token pool,
    /// including coins of LP tokens if it is a metapool.
    /// @param _lpToken Curve LP Token address for which pool we need to prepare a coins list
    /// @dev As we don't know the total number of coins in the case with metapool,
    /// we use a fixed-size array for a return type with a maximum number of coins in the Curve protocol (8).
    /// In the case of the metapool, we'll ignore LP Tokens and add underlying pool coins instead.
    /// @return length Total number of coins in the pool
    /// @return coinsList List of the coins of the LP Tokens pool
    function getPoolUnderlyingCoins(address _lpToken)
        public
        virtual
        view
        returns (
            uint256 length,
            address[_MAX_NUMBER_OF_COINS] memory coinsList
        )
    {
        PoolCoin[] memory currentPoolCoins = coins[_lpToken];
        uint256 i = 0;

        while(i < currentPoolCoins.length) {
            if (currentPoolCoins[i].isLPToken) {
                (uint256 nestedCoinsLen, address[_MAX_NUMBER_OF_COINS] memory nestedPoolCoins)
                    = getPoolUnderlyingCoins(currentPoolCoins[i].addr);

                uint256 j = 0;

                while(j < nestedCoinsLen) {
                    coinsList[length] = nestedPoolCoins[j];

                    // Ignoring overflow check as it is impossible
                    // to have more than 2 ** 256 - 1 coins in the storage.
                    unchecked { j++; length++; }
                }

                // Ignoring overflow check as it is impossible
                // to have more than 2 ** 256 - 1 coins in the storage.
                 unchecked { i++; }

                continue;
            }

            coinsList[length] = currentPoolCoins[i].addr;

            // Ignoring overflow check as it is impossible
            // to have more than 2 ** 256 - 1 coins in the storage.
            unchecked { i++; length++; }
        }
    }

    /// @notice Enable Curve LP token in the price provider
    /// @param _lpToken Curve LP Token address that will be enabled in the price provider
    function _setUpAssetAndEnsureItIsSupported(address _lpToken) internal {
        _setupAsset(_lpToken);
        
        // Ensure that the get price function does not revert for initialized coins
        uint256 length = coins[_lpToken].length;
        uint256 i = 0;

        while(i < length) {
            // The price providers repository should revert if the provided coin is not supported
            _priceProvidersRepository.getPrice(coins[_lpToken][i].addr);

            // Ignoring overflow check as it is impossible
            // to have more than 2 ** 256 - 1 coins in the storage.
            unchecked { i++; }
        }
    }

    /// @notice Price is denominated in the quote token
    /// @param _lpToken Curve LP Token address for which pool coins we must select prices
    /// @return prices A list of the `_lpToken` pool coins prices
    function _lpTokenPoolCoinsPrices(address _lpToken) internal view returns (uint256[] memory prices) {
        uint256 length;
        address[_MAX_NUMBER_OF_COINS] memory poolCoins;

        (length, poolCoins) = getPoolUnderlyingCoins(_lpToken);

        prices = new uint256[](length);
        uint256 i = 0;

        while(i < length) {
            prices[i] = _priceProvidersRepository.getPrice(poolCoins[i]);

            // Ignoring overflow check as it is impossible
            // to have more than 2 ** 256 - 1 coins in the storage.
            unchecked { i++; }
        }
    }
}
