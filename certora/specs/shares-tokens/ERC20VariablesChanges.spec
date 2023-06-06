methods {
    totalSupply() returns uint256 envfree
    balanceOf(address account) returns uint256 envfree
    allowance(address owner, address spender) returns uint256 envfree

    transfer(address to, uint256 amount)
    transferFrom(address from, address to, uint256 amount)
    approve(address spender, uint256 amount)
}

ghost mathint sumAllFunds {
	init_state axiom sumAllFunds == 0; 
}

hook Sstore _balances[KEY address a] uint256 newBalance (uint256 old_balance) STORAGE {
  sumAllFunds = sumAllFunds + newBalance - old_balance;
}

invariant VS_Shares_totalSupply_balances()
    sumAllFunds == totalSupply()

rule VC_Shares_totalSupply_change(method f) filtered { f -> !f.isView && !f.isFallback } {
    env e;
    calldataarg args;

    uint256 totalSupplyBefore = totalSupply();

    f(e, args);
    uint256 totalSupplyAfter = totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => 
        (f.selector == mint(address, uint256).selector || f.selector == burn(address, uint256).selector),
        "total supply changed as a result of function other than expected";
}

rule VC_Shares_totalSupply_increase(method f) filtered { f -> !f.isView && !f.isFallback } {
    env e;
    calldataarg args;

    uint256 totalSupplyBefore = totalSupply();

    f(e, args);
    uint256 totalSupplyAfter = totalSupply();

    assert totalSupplyBefore < totalSupplyAfter => f.selector == mint(address, uint256).selector,
        "tokens have been minted in the other than #mint fn";
}

rule VC_Shares_totalSupply_decrease(method f) filtered { f -> !f.isView && !f.isFallback } {
    env e;
    calldataarg args;

    uint256 totalSupplyBefore = totalSupply();

    f(e, args);
    uint256 totalSupplyAfter = totalSupply();

    assert totalSupplyBefore > totalSupplyAfter => f.selector == burn(address, uint256).selector,
        "tokens have been burned in the other than #burn fn";
}

rule VC_Shares_balance_change(method f, address account)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    uint256 balanceBefore = balanceOf(account);

    f(e, args);
    uint256 balanceAfter = balanceOf(account);

    assert balanceBefore != balanceAfter => (
            f.selector == burn(address, uint256).selector ||
            f.selector == mint(address, uint256).selector ||
            f.selector == transfer(address, uint256).selector ||
            f.selector == transferFrom(address, address, uint256).selector
        ),
        "balance has been updated in the other function than expected";
}

rule VC_Shares_balance_increase(method f, address account)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    uint256 balanceBefore = balanceOf(account);

    f(e, args);
    uint256 balanceAfter = balanceOf(account);

    assert balanceBefore < balanceAfter => (
            f.selector == mint(address, uint256).selector ||
            f.selector == transfer(address, uint256).selector ||
            f.selector == transferFrom(address, address, uint256).selector
        ),
        "balance has been increased in the other function than expected";
}

rule VC_Shares_balance_decrease(method f, address account)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    uint256 balanceBefore = balanceOf(account);

    f(e, args);
    uint256 balanceAfter = balanceOf(account);

    assert balanceBefore > balanceAfter => (
            f.selector == burn(address, uint256).selector ||
            f.selector == transfer(address, uint256).selector ||
            f.selector == transferFrom(address, address, uint256).selector
        ),
        "balance has been decreased in the other function than expected";
}

rule VC_Shares_allowance_change(method f, address owner, address spender)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    uint256 allowanceBefore = allowance(owner, spender);

    f(e, args);
    uint256 allowanceAfter = allowance(owner, spender);

    assert allowanceBefore != allowanceAfter => (
            f.selector == approve(address, uint256).selector ||
            f.selector == transferFrom(address, address, uint256).selector ||
            f.selector == increaseAllowance(address, uint256).selector ||
            f.selector == decreaseAllowance(address, uint256).selector

        ),
        "allowance has been changed in the other function than expected";
}
