// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface IPPrincipalToken {
    function transfer(address user, uint256 amount) external;
    function isExpired() external view returns (bool);
}
