// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../interfaces/IMagician.sol";
import "./PendleUniswapMagician.sol";

contract PendlePTweETH27JUN2024MagicianEth is PendleUniswapMagician {
    address public constant WEETH = 0xCd5fE23C85820F7B72D0926FC9b05b43E359b7ee;
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    constructor() PendleUniswapMagician(
        0xE592427A0AEce92De3Edee1F18E0157C05861564, // Uniswap router
        500, // fee
        0xc69Ad9baB1dEE23F4605a82b3354F8E40d1E5966, // PT Token
        0xF32e58F92e60f4b0A37A69b95d642A471365EAe8  // PT Market
    ) {}

    function _fromToken() internal pure override returns (address) {
        return WEETH;
    }

    function _toToken() internal pure override returns (address) {
        return WETH;
    }
}
