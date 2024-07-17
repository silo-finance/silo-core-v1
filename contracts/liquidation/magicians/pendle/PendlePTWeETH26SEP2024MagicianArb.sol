// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../interfaces/IMagician.sol";
import "./PendleUniswapMagician.sol";

contract PendlePTWeETH26SEP2024MagicianArb is PendleUniswapMagician {
    address public constant WEETH = 0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe;
    address public constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

    constructor() PendleUniswapMagician(
        0xE592427A0AEce92De3Edee1F18E0157C05861564, // Uniswap router
        100, // fee
        0xb8b0a120F6A68Dd06209619F62429fB1a8e92feC, // PT Token
        0xf9F9779d8fF604732EBA9AD345E6A27EF5c2a9d6  // PT Market
    ) {}

    function _fromToken() internal pure override returns (address) {
        return WEETH;
    }

    function _toToken() internal pure override returns (address) {
        return WETH;
    }
}
