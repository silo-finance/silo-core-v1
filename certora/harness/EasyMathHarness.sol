// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/lib/EasyMath.sol";

contract EasyMathHarness {
    using EasyMath for uint256;

    function toShareWrapped(uint256 amount, uint256 totalAmount, uint256 totalShares) external pure returns (uint256) {
        return amount.toShare(totalAmount, totalShares);
    }

    function toAmountWrapped(uint256 share, uint256 totalAmount, uint256 totalShares) external pure returns (uint256) {
        return share.toAmount(totalAmount, totalShares);
    }
}
