// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../governance/SiloGovernor.sol";

/// @dev this is MOCK contract - DO NOT USE IT!
contract MockSiloGovernor is SiloGovernor {
    constructor(ERC20Votes _token, TimelockController _timelock) SiloGovernor(_token, _timelock) {
        // for faster QA, original value is 45K and that takes forever when minting blocks during QA
        _setVotingPeriod(45);
    }
}
