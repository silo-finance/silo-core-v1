// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./_common/UniswapBaseMagicianOptimism.sol";

contract USDCMagicianOptimism is UniswapBaseMagicianOptimism {
    constructor() UniswapBaseMagicianOptimism(
        0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85, // USDC
        500 // FEE
    ) {}
}
