// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../interfaces/IMagician.sol";
import "./PendleUniswapMagician.sol";

contract PendlePTweETH27JUN2024MagicianArb is PendleUniswapMagician {
    address public constant WEETH = 0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe;
    address public constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

    constructor() PendleUniswapMagician(
        0xE592427A0AEce92De3Edee1F18E0157C05861564, // Uniswap router
        3000, // fee
        0x1c27Ad8a19Ba026ADaBD615F6Bc77158130cfBE4, // PT Token
        0x952083cde7aaa11AB8449057F7de23A970AA8472  // PT Market
    ) {}

    function _fromToken() internal pure override returns (address) {
        return WEETH;
    }

    function _toToken() internal pure override returns (address) {
        return WETH;
    }
}
