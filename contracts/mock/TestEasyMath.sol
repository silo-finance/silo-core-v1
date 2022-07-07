// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../lib/EasyMath.sol";

/// @dev this is MOCK contract - DO NOT USE IT!
contract TestEasyMath {
    function toShare(uint256 amount, uint256 totalAmount, uint256 totalShares) external pure returns (uint256) {
        return EasyMath.toShare(amount, totalAmount, totalShares);
    }

    function toShareRoundUp(uint256 amount, uint256 totalAmount, uint256 totalShares) external pure returns (uint256) {
        return EasyMath.toShareRoundUp(amount, totalAmount, totalShares);
    }

    function toAmount(uint256 share, uint256 totalAmount, uint256 totalShares) external pure returns (uint256) {
        return EasyMath.toAmount(share, totalAmount, totalShares);
    }

    function toAmountRoundUp(uint256 share, uint256 totalAmount, uint256 totalShares) external pure returns (uint256) {
        return EasyMath.toAmountRoundUp(share, totalAmount, totalShares);
    }
}
