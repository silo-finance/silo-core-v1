// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

/// @notice A simplified interface of the Curve LP Token.
/// @dev Includes only methods required to retrieve LP token details as are necessary for a price calculation.
interface ICurveLPTokenMinterLike {
    /// @return pool address of the LP Token
    function minter() external view returns (address pool);
}
