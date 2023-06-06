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

rule HLP_Shares_transferFrom_allowance(method f, address owner, address account, uint256 amount) {
    env e;

    uint256 allowanceBefore = allowance(owner, e.msg.sender);

    transferFrom(e, owner, account, amount);

    uint256 allowanceAfter = allowance(owner, e.msg.sender);

    assert allowanceBefore - allowanceAfter == amount;
}

rule HLP_Shares_additive_transfer(address from, address to, uint256 amount1, uint256 amount2) {
    env e;

    storage initialStorage = lastStorage;

    transfer(e, to, amount1);
    transfer(e, to, amount2);

    uint256 balanceFrom1 = balanceOf(from);
    uint256 balanceTo1 = balanceOf(to);

    transfer(e, to, amount1 + amount2) at initialStorage;

    uint256 balanceFrom2 = balanceOf(from);
    uint256 balanceTo2 = balanceOf(to);

    assert balanceFrom1 == balanceFrom2 && balanceTo1 == balanceTo2, "transfer# is not additive";
}

rule HLP_Shares_additive_transferFrom(address from, address to, uint256 amount1, uint256 amount2) {
    env e;

    storage initialStorage = lastStorage;

    transferFrom(e, from, to, amount1);
    transferFrom(e, from, to, amount2);

    uint256 balanceFrom1 = balanceOf(from);
    uint256 balanceTo1 = balanceOf(to);

    transferFrom(e, from, to, amount1 + amount2) at initialStorage;

    uint256 balanceFrom2 = balanceOf(from);
    uint256 balanceTo2 = balanceOf(to);

    assert balanceFrom1 == balanceFrom2 && balanceTo1 == balanceTo2, "transferFrom# is not additive";
}

rule HLP_Shares_additive_mint(address to, uint256 amount1, uint256 amount2) {
    env e;

    storage initialStorage = lastStorage;

    mint(e, to, amount1);
    mint(e, to, amount2);

    uint256 balanceTo1 = balanceOf(to);

    mint(e, to, amount1 + amount2) at initialStorage;

    uint256 balanceTo2 = balanceOf(to);

    assert balanceTo1 == balanceTo2, "mint# is not additive";
}

rule  HLP_Shares_additive_burn(address to, uint256 amount1, uint256 amount2) {
    env e;

    storage initialStorage = lastStorage;

    burn(e, to, amount1);
    burn(e, to, amount2);

    uint256 balanceTo1 = balanceOf(to);

    burn(e, to, amount1 + amount2) at initialStorage;

    uint256 balanceTo2 = balanceOf(to);

    assert balanceTo1 == balanceTo2, "burn# is not additive";
}

rule  HLP_Shares_additive_increaseAllowance(address to, uint256 amount1, uint256 amount2) {
    env e;

    require e.msg.sender != to;

    storage initialStorage = lastStorage;

    increaseAllowance(e, to, amount1);
    increaseAllowance(e, to, amount2);

    uint256 allowance1 = allowance(e.msg.sender, to);

    increaseAllowance(e, to, amount1 + amount2) at initialStorage;

    uint256 allowance2 = allowance(e.msg.sender, to);

    assert allowance1 == allowance2, "increaseAllowance# is not additive";
}

rule  HLP_Shares_additive_decreaseAllowance(address to, uint256 amount1, uint256 amount2) {
    env e;

    require e.msg.sender != to;

    storage initialStorage = lastStorage;

    decreaseAllowance(e, to, amount1);
    decreaseAllowance(e, to, amount2);

    uint256 allowance1 = allowance(e.msg.sender, to);

    decreaseAllowance(e, to, amount1 + amount2) at initialStorage;

    uint256 allowance2 = allowance(e.msg.sender, to);

    assert allowance1 == allowance2, "decreaseAllowance# is not additive";
}

rule HLP_Shares_integrity_mint(address to, uint256 amount) {
    env e;

    require e.msg.sender != to;

    uint256 balanceBefore = balanceOf(to);

    mint(e, to, amount);

    uint256 balanceAfter = balanceOf(to);

    assert balanceAfter == balanceBefore + amount, "integrity break mint#";
}

rule HLP_Shares_integrity_burn(address from, uint256 amount) {
    env e;

    require e.msg.sender != from;

    uint256 balanceBefore = balanceOf(from);

    burn(e, from, amount);

    uint256 balanceAfter = balanceOf(from);

    assert balanceAfter == balanceBefore - amount, "integrity break burn#";
}

rule HLP_Shares_integrity_transfer(address to, uint256 amount) {
    env e;

    require e.msg.sender != to;

    uint256 balanceBefore = balanceOf(to);

    transfer(e, to, amount);

    uint256 balanceAfter = balanceOf(to);

    assert balanceAfter == balanceBefore + amount, "integrity break transfer#";
}

rule HLP_Shares_integrity_transferFrom(address from, address to, uint256 amount) {
    env e;

    require e.msg.sender != to && e.msg.sender != from && from != to;

    uint256 balanceToBefore = balanceOf(to);
    uint256 balanceFromBefore = balanceOf(from);

    transferFrom(e, from, to, amount);

    uint256 balanceToAfter = balanceOf(to);
    uint256 balanceFromAfter = balanceOf(from);

    assert balanceToAfter == balanceToBefore + amount && balanceFromAfter == balanceFromBefore - amount,
        "integrity break transferFrom#";
}

rule  HLP_Shares_integrity_increaseAllowance(address to, uint256 amount) {
    env e;

    require e.msg.sender != to;

    uint256 allowanceBefore = allowance(e.msg.sender, to);

    increaseAllowance(e, to, amount);

    uint256 allowanceAfter = allowance(e.msg.sender, to);

    assert allowanceAfter == allowanceBefore + amount, "integrity break increaseAllowance#";
}

rule  HLP_Shares_integrity_decreaseAllowance(address to, uint256 amount) {
    env e;

    require e.msg.sender != to;

    uint256 allowanceBefore = allowance(e.msg.sender, to);

    decreaseAllowance(e, to, amount);

    uint256 allowanceAfter = allowance(e.msg.sender, to);

    assert allowanceAfter == allowanceBefore - amount, "integrity break decreaseAllowance#";
}

rule  HLP_Shares_integrity_approve(address to, uint256 amount) {
    env e;

    require e.msg.sender != to;

    approve(e, to, amount);

    uint256 allowanceAfter = allowance(e.msg.sender, to);

    assert allowanceAfter == amount, "integrity break approve#";
}
