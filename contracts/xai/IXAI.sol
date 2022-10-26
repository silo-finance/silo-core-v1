// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IXAI is IERC20 {
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
}