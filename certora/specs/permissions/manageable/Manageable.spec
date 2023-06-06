methods {
    changeManager(address)

    // getters
    manager() returns address envfree
    owner() returns address envfree
}

rule VC_manager_change(env e, method f, calldataarg args) {
    address before = manager();
    f(e, args);
    address after = manager();

    assert before != after => f.selector == changeManager(address).selector,
        "A manager changed by another method than expected.";
}

rule VS_manager_is_not_0(env e, method f, calldataarg args) {
    require manager() != 0;
    f(e, args);
    assert manager() != 0, "A manager can't be an empty address";
}

rule VS_changeManager_only_owner_or_manager(env e, address newManager) {
    require manager() != 0;
    require owner() != 0;
    require manager() != newManager;

    address m = manager();
    address o = owner();

    changeManager@withrevert(e, newManager);
    bool reverted = lastReverted;

    assert e.msg.sender != m && e.msg.sender != o => reverted,
        "Another account than an owner or a manager can execute changeManager";
}
