// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

interface ISiloModule {
    function deposit(address silo, uint256 xaiAmount) external;
}