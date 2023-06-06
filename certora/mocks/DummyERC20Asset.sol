// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;
import "./_interfaces/IERC20.sol";

contract DummyERC20Asset is IERC20 {
    uint supply;
    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowances;

    string public name;
    string public symbol;
    uint public decimals;

    function transfer(address recipient, uint amount) external override returns (bool) {
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool) {
        allowances[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        balances[sender] = balances[sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        allowances[sender][msg.sender] = allowances[sender][msg.sender] - amount;
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint) {
        return allowances[owner][spender];
    }

    function totalSupply() external view override returns (uint) {
        return supply;
    }
    
    function balanceOf(address account) external view override returns (uint) {
        return balances[account];
    }
}
