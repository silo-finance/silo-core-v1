methods {
    balanceOf(address account) returns uint256 envfree
}

rule RA_Shares_balances_update_correctness(method f, address account1, address account2, address other)
    filtered { f -> !f.isView && !f.isFallback }
{
    require account1 != account2;

    mathint balance1Before = balanceOf(account1);
    mathint balance2Before = balanceOf(account2);
    mathint balanceOtherBefore = balanceOf(other);

    env e;
    calldataarg args;
    f(e, args);

    mathint balance1After = balanceOf(account1);
    mathint balance2After = balanceOf(account2);
    mathint balanceOtherAfter = balanceOf(other);

    assert (balance1Before != balance1After && 
            balance2Before != balance2After && 
            balanceOtherBefore != balanceOtherAfter) => (
                other == account1 || other == account2
            );
}
