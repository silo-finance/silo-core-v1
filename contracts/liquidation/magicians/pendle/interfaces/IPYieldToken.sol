// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface IPYieldToken {
    function redeemPY(address receiver) external returns (uint256 amountSyOut);
}
