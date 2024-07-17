// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../_common/CurveLPTokenDetailsBaseCache.sol";

/// @dev NPAP - non-pegged assets pools
abstract contract CurveLPTokensNPAPBaseCache is CurveLPTokenDetailsBaseCache {
    /// @notice Emitted when Curve LP token was enabled in the price provider
    /// @param pool Pool address of the Curve LP token
    /// @param token Curve LP token address that has been enabled in the price provider
    event LPTokenEnabled(address indexed pool, address indexed token);

    /// @dev Revert if the Curve LP tokens detail fetchers repository returned details
    /// with an `isMeta` flag equal to `true` for the pool with non-pegged assets.
    error CryptoPoolCantBeMetaPool();

    /// @notice Enable Curve LP token in the price provider
    /// @dev Reverts if the token is already initialized
    /// @param _lpToken Curve LP Token address that will be enabled in the price provider
    function _setupAsset(address _lpToken) internal virtual {
        if (coins[_lpToken].length != 0) revert TokenAlreadyInitialized();

        bytes memory data; // We'll use it as an `input` and `return` data
        LPTokenDetails memory details;

        (details, data) = _FETCHERS_REPO.getLPTokenDetails(_lpToken, data);

        if (details.pool.addr == address(0) || details.coins[0] == address(0)) {
            revert PoolForLPTokenNotFound();
        }

        if (details.coins.length < _MIN_COINS) revert InvalidNumberOfCoinsInPool();

        // Sanity check to ensure a data validity.
        // Crypto pools are not meta pools.
        if (details.pool.isMeta) revert CryptoPoolCantBeMetaPool();

        // For the pools with non-pegged asset we don't need to store all coins
        // as a price that pool will return will be denominated in the coins[0]
        PoolCoin memory coin = PoolCoin({ addr: details.coins[0], isLPToken: false });

        // Some of the Curve pools for ether use 'Null Address' which we are not
        // able to use for the price calculation. To be able to calculate an LP Token
        // price for this kind of pools we will use wETH address instead.
        if (coin.addr == _NULL_ADDRESS) {
            coin.addr = _NATIVE_WRAPPED_ADDRESS;
        }

        coins[_lpToken].push(coin);

        lpTokenPool[_lpToken] = details.pool;

        emit LPTokenEnabled(lpTokenPool[_lpToken].addr, _lpToken);
    }
}
