methods {
    setLimitedMaxLiquidity(bool)
    setDefaultSiloMaxDepositsLimit(uint256)
    setSiloMaxDepositsLimit(address, address, uint256)
    setGlobalPause(bool)
    setSiloPause(address, address, bool)

    // getters
    manager() returns address envfree
    isSiloPaused(address, address) returns bool envfree
    getMaxSiloDepositsValue(address, address) returns uint256 envfree

    // harness
    getGlobalLimit() returns bool envfree
    getDefaultMaxLiquidity() returns uint256 envfree
    getGlobalPause() returns bool envfree
    getSiloMaxLiquidity(address, address) returns uint256 envfree
    getSiloPause(address, address) returns bool envfree
}

rule VC_GuardedLaunch_globalLimit(env e, method f, calldataarg args) {
    bool before = getGlobalLimit();
    f(e, args);
    bool after = getGlobalLimit();

    assert before != after => f.selector == setLimitedMaxLiquidity(bool).selector,
        "The globalLimit changed by the function another than expected";
}

rule VC_GuardedLaunch_defaultMaxLiquidity(env e, method f, calldataarg args) {
    uint256 before = getDefaultMaxLiquidity();
    f(e, args);
    uint256 after = getDefaultMaxLiquidity();

    assert before != after => f.selector == setDefaultSiloMaxDepositsLimit(uint256).selector,
        "The defaultMaxLiquidity changed by the function another than expected";
}

rule VC_GuardedLaunch_siloMaxLiquidity(env e, method f, calldataarg args) {
    address silo; address asset;

    uint256 before = getSiloMaxLiquidity(silo, asset);
    f(e, args);
    uint256 after = getSiloMaxLiquidity(silo, asset);

    assert before != after => f.selector == setSiloMaxDepositsLimit(address,address,uint256).selector,
        "The siloMaxLiquidity changed by the function another than expected";
}

rule VC_GuardedLaunch_globalPause(env e, method f, calldataarg args) {
    bool before = getGlobalPause();
    f(e, args);
    bool after = getGlobalPause();

    assert before != after => f.selector == setGlobalPause(bool).selector,
        "The globalPause changed by the function another than expected";
}

rule VC_GuardedLaunch_siloPause(env e, method f, calldataarg args) {
    address silo; address asset;

    bool before = getSiloPause(silo, asset);
    f(e, args);
    bool after = getSiloPause(silo, asset);

    assert before != after => f.selector == setSiloPause(address,address,bool).selector,
        "The globalPause changed by the function another than expected";
}

rule UT_GuardedLaunch_setLimitedMaxLiquidity_onlyManager(env e, bool globalLimit) {
    setLimitedMaxLiquidity@withrevert(e, globalLimit);
    bool reverted = lastReverted;

    assert e.msg.sender != manager() => reverted,
        "Another account than an manager can setLimitedMaxLiquidity";
}

rule UT_GuardedLaunch_setDefaultSiloMaxDepositsLimit_onlyManager(env e, uint256 maxDeposits) {
    setDefaultSiloMaxDepositsLimit@withrevert(e, maxDeposits);
    bool reverted = lastReverted;

    assert e.msg.sender != manager() => reverted,
        "Another account than an manager can setDefaultSiloMaxDepositsLimit";
}

rule UT_GuardedLaunch_setSiloMaxDepositsLimit_onlyManager(env e, address silo, address asset, uint256 maxDeposits) {
    setSiloMaxDepositsLimit@withrevert(e, silo, asset, maxDeposits);
    bool reverted = lastReverted;

    assert e.msg.sender != manager() => reverted,
        "Another account than an manager can setSiloMaxDepositsLimit";
}

rule UT_GuardedLaunch_setGlobalPause_onlyManager(env e, bool globalPause) {
    setGlobalPause@withrevert(e, globalPause);
    bool reverted = lastReverted;

    assert e.msg.sender != manager() => reverted,
        "Another account than an manager can setGlobalPause";
}

rule UT_GuardedLaunch_setSiloPause_onlyManager(env e, address silo, address asset, bool pauseValue) {
    setSiloPause@withrevert(e, silo, asset, pauseValue);
    bool reverted = lastReverted;

    assert e.msg.sender != manager() => reverted,
        "Another account than an manager can setSiloPause";
}

rule RA_GuardedLaunch_Silo_pause_unpause(env e, address silo, address asset, bool pauseValue) {
    require getSiloPause(silo, asset) == true;
    require pauseValue == false;

    setSiloPause(e, silo, asset, pauseValue);
    bool after = getSiloPause(silo, asset);

    assert !after, "Unable to unpause a silo"; 
}

rule RA_GuardedLaunch_Global_pause_unpause(env e, bool pauseValue) {
    require getGlobalPause() == true;
    require pauseValue == false;

    setGlobalPause(e, pauseValue);
    bool after = getGlobalPause();

    assert !after, "Unable to unpause a system"; 
}
