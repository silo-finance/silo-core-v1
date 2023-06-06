using PricePriovidersRepository076 as repository

methods {
    setupAsset(address, address)
    changePeriodForAvgPrice(uint32)
    changeBlockTime(uint8)

    // summarizations
    verifyPool(address asset, address pool) returns bool =>
        isValidPool(asset, pool)

    // harness
    getPeriodForAvgPrice() returns uint32 envfree
    getChangeBlockTime() returns uint8 envfree

    // getters
    pools(address) returns address envfree
    getPrice(address) returns uint256 envfree
    quoteToken() returns address envfree
    priceProvidersRepository() returns address envfree

    repository.manager() returns address envfree
}

function isValidPool(address asset, address pool) returns bool {
    return true;
}

rule VC_UniswapV3_asset_pool(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset;

    address before = pools(asset);
    f(e, args);
    address after = pools(asset);

    assert before != after => f.selector == setupAsset(address, address).selector,
        "An asset pool been configured by a method other than expected";
}

rule VC_UniswapV3_periodForAvgPrice(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint32 before = getPeriodForAvgPrice();
    f(e, args);
    uint32 after = getPeriodForAvgPrice();

    assert before != after => f.selector == changePeriodForAvgPrice(uint32).selector,
        "A periodForAvgPrice changed by the method other than expected";
}

rule VC_UniswapV3_blockTime(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint32 before = getChangeBlockTime();
    f(e, args);
    uint32 after = getChangeBlockTime();

    assert before != after => f.selector == changeBlockTime(uint8).selector,
        "A blockTime changed by the method other than expected";
}

rule UT_UniswapV3_setupAsset_only_manager(env e, address asset, address pool) {
    setupAsset@withrevert(e, asset, pool);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to configure an asset pool";
}

rule UT_UniswapV3_changePeriodForAvgPrice_only_manager(env e, uint32 period) {
    changePeriodForAvgPrice@withrevert(e, period);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to change periodForAvgPrice";
}

rule UT_UniswapV3_changeBlockTime_only_manager(env e, uint8 blockTime) {
    changeBlockTime@withrevert(e, blockTime);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to change blockTime";
}
