// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../interfaces/ICurveHackyPool.sol";
import "../interfaces/ICurveReentrancyCheck.sol";

/// @title Curve read-only reentrancy check
abstract contract CurveReentrancyCheck is ICurveReentrancyCheck {
    struct ReentrancyConfig {
        uint128 gasLimit;
        N_COINS nCoins;
    }

    /// @dev Minimal acceptable gas limit for the check
    // ~2700 - 5600 when we do a call to an invalid interface (depends on an input data size)
    // ~1800 if the pool is locked
    uint256 constant public MIN_GAS_LIMIT = 6500;

    mapping(address => ReentrancyConfig) public poolReentrancyConfig;

    /// @dev Revert if the pool reentrancy config is not configured
    error MissingPoolReentrancyConfig();
    /// @dev Revert on the invalid pool configuration
    error InvalidPoolConfiguration();
    /// @dev Pool interface validation
    error InvalidInterface();

    /// @dev Write info the log about the Curve pool reentrancy check config update
    event ReentrancyCheckConfigUpdated(address _pool, uint256 _gasLimit, N_COINS _nCoins);

    /// @notice Set/Update a pool configuration for the reentrancy check
    /// @param _pool address
    /// @param _gasLimit the gas limit to be set on the check execution
    /// @param _nCoins the number of the coins in the Curve pool (N_COINS)
    function _setReentrancyVerificationConfig(address _pool, uint128 _gasLimit, N_COINS _nCoins) internal virtual {
        if (_pool == address(0)) revert InvalidPoolConfiguration();
        if (_gasLimit < MIN_GAS_LIMIT) revert InvalidPoolConfiguration();
        if (_nCoins < N_COINS.TWO_COINS) revert InvalidPoolConfiguration();

        poolReentrancyConfig[_pool] = ReentrancyConfig({
            gasLimit: _gasLimit,
            nCoins: _nCoins
        });

        // The call to the pool with an invalid input also reverts with the gas consumption lower
        // than defined threshold. Approximately 2700 gas for an input with 3 coins and 5600 for 8.
        // We do a sanity check of the interface by checking if a pool is locked on a setup.
        // The call to the valid interface will consume more than `MIN_GAS_LIMIT`.
        if (isLocked(_pool)) revert InvalidInterface();

        emit ReentrancyCheckConfigUpdated(_pool, _gasLimit, _nCoins);
    }

    /// @notice Verifies if the `lock` is activate on the Curve pool
    // The idea is to measure the gas consumption of the `remove_liquidity` fn.
    // solhint-disable-next-line code-complexity
    function isLocked(address _pool) public virtual view returns (bool) {
        ReentrancyConfig memory config = poolReentrancyConfig[_pool];

        if (config.gasLimit == 0) revert MissingPoolReentrancyConfig();

        uint256 gasStart = gasleft();

        ICurveHackyPool pool = ICurveHackyPool(_pool);

        if (config.nCoins == N_COINS.TWO_COINS) {
            uint256[2] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        } else if (config.nCoins == N_COINS.THREE_COINS) {
            uint256[3] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        } if (config.nCoins == N_COINS.FOUR_COINS) {
            uint256[4] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        } else if (config.nCoins == N_COINS.FIVE_COINS) {
            uint256[5] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        } else if (config.nCoins == N_COINS.SIX_COINS) {
            uint256[6] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        } else if (config.nCoins == N_COINS.SEVEN_COINS) {
            uint256[7] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        } else if (config.nCoins == N_COINS.EIGHT_COINS) {
            uint256[8] memory amounts;
            try pool.remove_liquidity{gas: config.gasLimit}(0, amounts) {} catch (bytes memory) {}
        }

        uint256 gasSpent;
        // `gasStart` will be always > `gasleft()`
        unchecked { gasSpent = gasStart - gasleft(); }

        return gasSpent > config.gasLimit ? false /* is not locked */ : true /* locked */;
    }
}
