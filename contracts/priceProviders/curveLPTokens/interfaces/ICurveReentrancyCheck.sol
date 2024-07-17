// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface ICurveReentrancyCheck {
    enum N_COINS { // solhint-disable-line contract-name-camelcase
        NOT_CONFIGURED,
        INVALID,
        TWO_COINS,
        THREE_COINS,
        FOUR_COINS,
        FIVE_COINS,
        SIX_COINS,
        SEVEN_COINS,
        EIGHT_COINS
    }

    /// @notice Set/Update a pool configuration for the reentrancy check
    /// @param _pool address
    /// @param _gasLimit the gas limit to be set on the check execution
    /// @param _nCoins the number of the coins in the Curve pool (N_COINS)
    function setReentrancyVerificationConfig(address _pool, uint128 _gasLimit, N_COINS _nCoins) external;
}
