// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/utils/TwoStepOwnable.sol";

contract TwoStepOwnableHarness is TwoStepOwnable {
    constructor () TwoStepOwnable() {}
}
