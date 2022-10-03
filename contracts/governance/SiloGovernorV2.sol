// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./SiloGovernor.sol";

/// @title Silo Governor V2
/// @notice Silo Goverannce V2 contract
/// @custom:security-contact security@silo.finance
contract SiloGovernorV2 is SiloGovernor {
    /// @param _token address of SiloGovernanceToken
    /// @param _timelock openzeppelin timelock contract
    /// @param _initialVotingDelay Delay, in number of block, between the proposal is created and the vote starts.
    /// This can be increassed to leave time for users to buy voting power, of delegate it, before the voting
    /// of a proposal starts.
    /// @param _initialVotingPeriod Delay, in number of blocks, between the vote start and vote ends.
    /// NOTE: The {votingDelay} can delay the start of the vote. This must be considered when setting the voting
    /// duration compared to the voting delay.
    /// @param _initialProposalThreshold Part of the Governor Bravo's interface:
    /// _"The number of votes required in order for a voter to become a proposer"_.
    constructor(
        ERC20Votes _token,
        TimelockController _timelock,
        uint256 _initialVotingDelay,
        uint256 _initialVotingPeriod,
        uint256 _initialProposalThreshold
    )
        SiloGovernor(_token, _timelock)
    {
        _setVotingDelay(_initialVotingDelay);
        _setVotingPeriod(_initialVotingPeriod);
        _setProposalThreshold(_initialProposalThreshold);
    }
}
