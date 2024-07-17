// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface ISiloConvexStateChangesHandler {
    /// @dev This function checkpoints two users rewards. This part of code can not be implemented in the Silo
    ///     because of the smart contract bytecode limit. Can be called from the Silo only.
    /// @param _firstToCheckpoint address to checkpoint, can be zero.
    /// @param _secondToCheckpoint address to checkpoint, can be zero.
    function beforeBalanceUpdate(address _firstToCheckpoint, address _secondToCheckpoint) external;

    /// @dev This function checks ConvexSiloWrapper `_wrapper`. Returns false if `_wrapper` is not registered in
    ///     `ConvexSiloWrapperFactory`. Returns false if Curve pool can not be fetched for `_wrapper` underlying
    ///     Curve LP token. Otherwise, returns true.
    /// @param _wrapper address.
    /// @return If the return argument is false, Silo contract must revert.
    function wrapperSetupVerification(address _wrapper) external view returns (bool);
}
