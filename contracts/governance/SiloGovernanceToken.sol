// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @title Silo Governance Token
/// @notice Official Silo token that governs Silo treasury and protocol (TBD)
/// @custom:security-contact security@silo.finance
contract SiloGovernanceToken is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
    constructor()
        ERC20("Silo Governance Token", "Silo")
        ERC20Permit("SiloGovernanceToken")
    {
        // mint 1B tokens to deployer
        _mint(msg.sender, 1e9 * 10 ** decimals());
    }

    /// @notice Mint new tokens. Callable only by owner.
    /// @dev Silo DAO will be made an owner and control minting.
    /// @param _to mint recipient
    /// @param _amount mint amount
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    /// @inheritdoc ERC20
    function _afterTokenTransfer(address _from, address _to, uint256 _amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(_from, _to, _amount);
    }

    /// @inheritdoc ERC20
    function _mint(address _to, uint256 _amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(_to, _amount);
    }

    /// @inheritdoc ERC20
    function _burn(address _account, uint256 _amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(_account, _amount);
    }
}
