// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../_common/CurveLPTokenDetailsBaseCache.sol";

/// @dev PAP - pegged assets pools
abstract contract CurveLPTokensPAPBaseCache is CurveLPTokenDetailsBaseCache {
    /// @dev Revert in the case when we will try to initialize a pool with two LP Tokens
    /// as Metapools can have only one LP underlying
    error UnsupportedPoolWithTwoLPs();

    /// @notice Emitted when Curve LP token was enabled in the price provider
    /// @param pool Pool address of the Curve LP token
    /// @param token Curve LP token address that has been enabled in the price provider
    event LPTokenEnabled(address indexed pool, address indexed token);

    /// @notice Enable Curve LP token in the price provider
    /// @dev Reverts if the token is already initialized
    /// @param _lpToken Curve LP Token address that will be enabled in the price provider
    function _setupAsset(address _lpToken) internal {
        if (coins[_lpToken].length != 0) revert TokenAlreadyInitialized();

        bool result = _setUp(_lpToken);

        if (!result) revert PoolForLPTokenNotFound();
    }

    /// @notice Enable Curve LP token in the price provider
    /// @param _lpToken Curve LP Token address that will be enabled in the price provider
    /// @return `true` if `_lpToken` has been enabled in the price provider, or already
    /// has been initialized before, `false` if a pool not found for `_lpToken`.
    function _setUp(address _lpToken) internal returns (bool) {
        if (coins[_lpToken].length != 0) {
            // In the case, if `_lpToken` has already been initialized
            return true;
        }

        bytes memory data; // We'll use it as an `input` and `return` data
        LPTokenDetails memory details;

        (details, data) = _FETCHERS_REPO.getLPTokenDetails(_lpToken, data);

        if (details.pool.addr == address(0)) {
            return false;
        }

        uint256 i = 0;
        bool alreadyWithLPToken;

        while (i < details.coins.length) {
            bool isLPToken = _addCoin(_lpToken, details.coins[i], details.pool.isMeta);

            if (isLPToken && alreadyWithLPToken) revert UnsupportedPoolWithTwoLPs();

            if (!alreadyWithLPToken) {
                alreadyWithLPToken = isLPToken;
            }

            // Because of the condition `i < details.coins.length` we can ignore overflow check
            unchecked { i++; }
        }

        lpTokenPool[_lpToken] = details.pool;

        if (coins[_lpToken].length < _MIN_COINS) revert InvalidNumberOfCoinsInPool();

        emit LPTokenEnabled(lpTokenPool[_lpToken].addr, _lpToken);

        return true;
    }

    /// @notice Cache a coin in the price provider storage to avoid
    /// multiple external requests (save gas) during a price calculation.
    /// @param _lpToken Curve LP Token address
    /// @param _coin Coin from the `_lpToken` pool
    /// @param _isMetaPool `true` if the `_lpToken` pool is meta pool
    function _addCoin(address _lpToken, address _coin, bool _isMetaPool) internal returns (bool isLPToken) {
        PoolCoin memory coin = PoolCoin({
            addr: _coin,
            // If a pool is a meta pool, it can contain other Curve LP tokens.
            // We need to try to set up a coin, so we will know if the coin is an LP token or not.
            isLPToken: _isMetaPool ? _setUp(_coin) : false
        });

        // Some of the Curve pools for ether use 'Null Address' which we are not
        // able to use for the price calculation. To be able to calculate an LP Token
        // price for this kind of pools we will use wETH address instead.
        if (coin.addr == _NULL_ADDRESS) {
            coin.addr = _NATIVE_WRAPPED_ADDRESS;
        }

        coins[_lpToken].push(coin);

        isLPToken = coin.isLPToken;
    }
}
