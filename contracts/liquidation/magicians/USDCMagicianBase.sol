// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./_common/UniswapBaseMagicianBase.sol";

contract USDCMagicianBase is UniswapBaseMagicianBase {
    constructor() UniswapBaseMagicianBase(
        0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913, // USDC
        500 // FEE
    ) {}
}
