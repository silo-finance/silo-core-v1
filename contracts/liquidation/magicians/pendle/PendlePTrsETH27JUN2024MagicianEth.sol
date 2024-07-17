// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./PendleBlancerMagician.sol";

contract PendlePTrsETH27JUN2024MagicianEth is PendleBlancerMagician {
    constructor() PendleBlancerMagician(
        0xB05cABCd99cf9a73b19805edefC5f67CA5d1895E, // PT Token
        0x4f43c77872Db6BA177c270986CD30c3381AF37Ee, // PT Market
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, // WETH
        0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7, // rsETH
        0xBA12222222228d8Ba445958a75a0704d566BF2C8, // Balancer Vault
        0x58aadfb1afac0ad7fca1148f3cde6aedf5236b6d00000000000000000000067f // Pool ID
    ) {}
}
