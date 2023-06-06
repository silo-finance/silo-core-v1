using SiloRepository as repository

methods {
    initRepository(address)
    createShareCollateralToken(string, string, address)
    createShareDebtToken(string, string, address)

    // getters
    siloRepository() returns address envfree
    tokensFactoryPing() returns bytes4 envfree

    repository.isSilo(address) returns bool envfree
}

rule VC_TokensFactory_siloRepository_change(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    require siloRepository() == 0;
    f(e, args);
    address sr = siloRepository();

    assert sr != 0 => f.selector == initRepository(address).selector,
        "silo repository address changed as a result of function other than expected";
}

rule HLP_TokensFactory_siloRepository_change(env e, address repo1, address repo2) {
    require siloRepository() == 0;
    require repo1 != 0 && repo2 != 0 && repo1 != repo2;

    initRepository(e, repo1);

    assert siloRepository() == repo1,
        "invalid repository address after initialization";
    
    initRepository@withrevert(e, repo2);

    assert lastReverted, "silo repository can be intialized twice";
}

rule UT_TokensFactory_createShareCollateralToken_only_silo(env e, address asset) {
    require e.msg.value == 0;

    string n = "n"; string s = "s";
    createShareCollateralToken@withrevert(e, n, s, asset);

    bool reverted = lastReverted;
    bool isSilo = repository.isSilo(e.msg.sender);
    assert !isSilo => reverted,
        "Do not revert when msg.sender is a silo";
}

rule UT_TokensFactory_createShareDebtToken_only_silo(env e, address asset) {
    require e.msg.value == 0;

    string n = "n"; string s = "s";
    createShareDebtToken@withrevert(e, n, s, asset);

    bool reverted = lastReverted;
    bool isSilo = repository.isSilo(e.msg.sender);
    assert !isSilo => reverted,
        "Do not revert when msg.sender is not a silo";
}

rule RA_TokensFactory_siloRepository_not_zero(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address repoBefore = siloRepository();
    f(e, args);
    address repoAfter = siloRepository();

    assert repoBefore != 0 => repoBefore == repoAfter,
        "silo repository address can't be updated";
}

rule RA_TokensFactory_any_silo_can_create_shares(env e1, env e2, address asset1, address asset2) {
    require repository.isSilo(e1.msg.sender) == true;
    require repository.isSilo(e2.msg.sender) == true;

    require e1.msg.value == 0 && e2.msg.value == 0;

    storage initialStorage = lastStorage;

    string n = "n"; string s = "s";
    createShareCollateralToken(e1, n, s, asset1);
    createShareCollateralToken@withrevert(e2, n, s, asset1) at initialStorage;
    
    bool reverted1 = lastReverted;
    assert !reverted1, "any silo should be able to create a shares collateral token";

    storage initialStorage2 = lastStorage;

    createShareDebtToken(e1, n, s, asset2) at initialStorage;
    createShareDebtToken@withrevert(e2, n, s, asset2) at initialStorage;

    bool reverted2 = lastReverted;
    assert !reverted2, "any silo should be able to create a shares debt token";
}
