// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./TreasuryVester.sol";

/// @title Silo Snapshot token
/// @notice Utility Silo tokens that adds unvested Silo tokens to account balance. It's used for snapshot voting
///         to allow unvested tokens to vote. It's not transferable.
/// @custom:security-contact security@silo.finance
contract SiloSnapshotWrapper is ERC20 {
    ERC20 public siloToken;
    address[] public vestingContracts;

    constructor(address _siloToken, address[] memory _vestingContracts) ERC20("Silo Snapshot Token", "snapshotSILO") {
        require(_siloToken != address(0), "empty _siloToken");

        for (uint256 i; i < _vestingContracts.length; i++) {
            require(_vestingContracts[i] != address(0), "empty address in _vestingContracts");
        }

        siloToken = ERC20(_siloToken);
        vestingContracts = _vestingContracts;
    }

    /// @inheritdoc IERC20
    function totalSupply() public view override returns (uint256) {
        return siloToken.totalSupply();
    }

    /// @inheritdoc IERC20
    function balanceOf(address _account) public view override returns (uint256) {
        return getCurrentBalance(_account) + getVestingBalance(_account);
    }

    /// @notice Calculates amount of token that are vesting for account
    /// @param _account address of account for which to calcualte amount of tokens
    /// @return userBalance amount of tokens vesting
    function getVestingBalance(address _account) public view returns (uint256 userBalance) {
        for (uint256 i = 0; i < vestingContracts.length; i++) {
            if (TreasuryVester(vestingContracts[i]).recipient() == _account) {
                userBalance += siloToken.balanceOf(vestingContracts[i]);
            }
        }
    }

    /// @notice Current token balance of account
    /// @param _account address of account for which to calcualte current balance
    /// @return current balance
    function getCurrentBalance(address _account) public view returns (uint256) {
        return siloToken.balanceOf(_account);
    }

    /// @inheritdoc ERC20
    function _beforeTokenTransfer(address, address, uint256) internal pure override {
        revert("Non-transferable");
    }
}
