methods {
    initRepository(address)
    createSilo(address, uint128, bytes)

    // getters
    siloRepository() returns address envfree
}

rule VC_SiloFactory_siloRepository_change(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    require siloRepository() == 0;
    f(e, args);
    address sr = siloRepository();

    assert sr != 0 => f.selector == initRepository(address).selector,
        "silo repository address changed as a result of function other than expected";
}

rule HLP_SiloFactory_siloRepository_change(env e, address repo1, address repo2) {
    require siloRepository() == 0;
    require repo1 != 0 && repo2 != 0;

    initRepository(e, repo1);

    assert siloRepository() == repo1,
        "invalid repository address after initialization";
    
    initRepository@withrevert(e, repo2);

    assert lastReverted, "silo repository can be intialized twice";
}

rule UT_SiloFactory_createSilo_premissions(env e, uint128 version, bytes data, address asset) {
    require asset != siloRepository();

    createSilo@withrevert(e, asset, version, data);

    bool reverted = lastReverted;
    assert e.msg.sender != siloRepository() => reverted,
        "Do not revert when msg.sender is not a siloRepository";
}
