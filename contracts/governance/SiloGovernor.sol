// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

/// @title Silo Governor
/// @notice Silo Goverannce contract
/// @custom:security-contact security@silo.finance
contract SiloGovernor is
    Governor,
    GovernorSettings,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    /// @param _token address of SiloGovernanceToken
    /// @param _timelock openzeppelin timelock contract
    constructor(ERC20Votes _token, TimelockController _timelock)
        Governor("SiloGovernor")
        GovernorSettings(1 /* 1 block */, 45818 /* 1 week */, 100000e18)
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(1)
        GovernorTimelockControl(_timelock)
    {}

    /// @inheritdoc IGovernor
    function propose(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        string memory _description
    )
        public
        override(Governor, IGovernor)
        returns (uint256)
    {
        return super.propose(_targets, _values, _calldatas, _description);
    }

    /// @inheritdoc IGovernor
    function votingDelay()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    /// @inheritdoc IGovernor
    function votingPeriod()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    /// @inheritdoc IGovernor
    function quorum(uint256 _blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(_blockNumber);
    }

    /// @inheritdoc IGovernor
    function getVotes(address _account, uint256 _blockNumber)
        public
        view
        override(IGovernor, GovernorVotes)
        returns (uint256)
    {
        return super.getVotes(_account, _blockNumber);
    }

    /// @inheritdoc Governor
    function state(uint256 _proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(_proposalId);
    }

    /// @inheritdoc Governor
    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    /// @inheritdoc Governor
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc Governor
    function _execute(
        uint256 _proposalId,
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        bytes32 _descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._execute(_proposalId, _targets, _values, _calldatas, _descriptionHash);
    }

    /// @inheritdoc Governor
    function _cancel(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        bytes32 _descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(_targets, _values, _calldatas, _descriptionHash);
    }

    /// @inheritdoc Governor
    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }


}
