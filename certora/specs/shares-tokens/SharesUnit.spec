methods {
    silo() returns address envfree
}

rule UT_Shares_min_burn_permissions(method f, address to, uint256 amount)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;
    address silo = silo();

    f@withrevert(e, args);

    assert (
        e.msg.sender != silo &&
        (f.selector == mint(address, uint256).selector || f.selector == burn(address, uint256).selector)
    ) => lastReverted;
}
