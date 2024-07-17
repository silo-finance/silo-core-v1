// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../../interfaces/IConvexSiloWrapper.sol";
import "./interfaces/IMagician.sol";

/// @dev ConvexSiloWrapperMagician Magician for unwrapping `ConvexSiloWrapper` tokens to
///     Curve LP tokens.
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
contract ConvexSiloWrapperMagician is IMagician {
    /// @dev revert when towardsAsset is called, because `ConvexSiloWrapper` is collateralOnly.
    ///     Liquidations of that collateral will not happen, because it can not be borrowed.
    error Unsupported();

    /// @dev revert when the asset is not ConvexSiloWrapper token.
    error InvalidAsset();

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount)
        external
        virtual
        returns (address tokenOut, uint256 amountOut)
    {
        tokenOut = address(IConvexSiloWrapper(_asset).underlyingToken());
        amountOut = _amount;
        IConvexSiloWrapper(_asset).withdrawAndUnwrap(_amount);
    }

    /// @inheritdoc IMagician
    function towardsAsset(address, uint256) external virtual returns (address, uint256) {
        revert Unsupported();
    }
}
