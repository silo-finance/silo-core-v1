// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @dev Identifiers of the Curve protocol registries in the Curve address provider
enum RegistryId { _0, _1, _2, _3, _4, _5, _6 }

/// @dev Storage struct that holds Curve pool coin details
struct PoolCoin {
    /// @dev Coin address
    address addr;
    /// @dev `true` if a coin is Curve LP Token (used in the meta pools)
    bool isLPToken;
}

/// @dev Storage struct that holds Curve pool details
struct Pool {
    /// @dev Pool address
    address addr;
    /// @dev `true` if a pool is the meta pool (the pool that contains other Curve LP Tokens)
    bool isMeta;
    /// @dev Pool identifier in the Curve address registry
    RegistryId registryId;
}

/// @dev Describes an LP Token with all the details required for the price calculation
struct LPTokenDetails {
    /// @dev A pool of the LP Token. See a Pool struct
    Pool pool;
    /// @dev A list of the LP token pool coins
    address[] coins;
}
