// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./PendleCamelotMagician.sol";

contract PendlePTrsETH27JUN2024MagicianArb is PendleCamelotMagician {
    constructor() PendleCamelotMagician(
        0xAFD22F824D51Fb7EeD4778d303d4388AC644b026, // PT Token,
        0x6Ae79089b2CF4be441480801bb741A531d94312b, // PT Market,
        0x82aF49447D8a07e3bd95BD0d56f35241523fBab1, // WETH
        0x4186BFC76E2E237523CBC30FD220FE055156b41F, // RSETH
        0x1F721E2E82F6676FCE4eA07A5958cF098D339e18, // Camelot router V3
        0xb355ccE5CBAF411bd56e3b092F5AA10A894083ae  // Camelot pool
    ) {}
}
