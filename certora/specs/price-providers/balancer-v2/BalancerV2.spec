using PricePriovidersRepository076 as repository

methods {
    setupAsset(address, bytes32)
    changePeriodForAvgPrice(uint32)
    changeSecondsAgo(uint32)
    changeSettings(uint32, uint32)

    // summarizations
    verifyPool(bytes32 poolId, address asset) returns bool =>
        isValidPool(poolId, asset)

    resolvePoolAddress(bytes32 poolId) returns address =>
        resolvePoolAddressGhost(poolId)

    // getters
    secondsAgo() returns uint32 envfree
    periodForAvgPrice() returns uint32 envfree
    assetSupported(address) returns bool envfree
    quoteToken() returns address envfree
    getPrice(address) returns uint256 envfree
    priceProvidersRepository() returns address envfree

    ERC20Token.decimals() returns uint256 envfree
    repository.manager() returns address envfree
}

function isValidPool(bytes32 poolId, address asset) returns bool {
    return true;
}

ghost resolvePoolAddressGhost(bytes32) returns address;

rule VC_BalancerV2_asset_pool(env e, method f, calldataarg args, address asset)
    filtered { f -> !f.isView && !f.isFallback }
{
    require quoteToken() != asset;
    require assetSupported(asset) == false;

    f(e, args);

    bool supported = assetSupported(asset);

    assert supported => f.selector == setupAsset(address, bytes32).selector,
        "An asset pool been configured by a method other than expected";
}

rule VC_BalancerV2_periodForAvgPrice(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint256 before = periodForAvgPrice();
    f(e, args);
    uint256 after = periodForAvgPrice();

    assert before != after =>
        f.selector == changePeriodForAvgPrice(uint32).selector ||
        f.selector == changeSettings(uint32, uint32).selector,
        "periodForAvgPrice updated by the method other than expected";
}

rule VC_BalancerV2_secondsAgo(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint256 before = secondsAgo();
    f(e, args);
    uint256 after = secondsAgo();

    assert before != after =>
        f.selector == changeSecondsAgo(uint32).selector ||
        f.selector == changeSettings(uint32, uint32).selector,
        "secondsAgo updated by the method other than expected";
}

rule VS_BalancerV2_periodForAvgPrice_is_not_zero(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    require periodForAvgPrice() != 0;
    f(e, args);
    uint256 after = periodForAvgPrice();

    assert after != 0, "periodForAvgPrice can't be 0";
}

rule UT_BalancerV2_setupAsset_only_manager(env e, address asset, bytes32 poolId) {
    require priceProvidersRepository() == repository;

    setupAsset@withrevert(e, asset, poolId);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to configure an asset pool";
}

rule UT_BalancerV2_changePeriodForAvgPrice_only_manager(env e, uint32 period) {
    require priceProvidersRepository() == repository;
    changePeriodForAvgPrice@withrevert(e, period);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to change periodForAvgPrice";
}

rule UT_BalancerV2_changeSecondsAgo_only_manager(env e, uint32 ago) {
    require priceProvidersRepository() == repository;
    changeSecondsAgo@withrevert(e, ago);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to change secondsAgo";
}

rule UT_BalancerV2_changeSettings_only_manager(env e, uint32 period, uint32 ago) {
    require priceProvidersRepository() == repository;
    changeSettings@withrevert(e, period, ago);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to change settings";
}

rule UT_BalancerV2_getPrice_with_not_configured_pool(address token) {
    require quoteToken() != token;
    require assetSupported(token) == false;

    getPrice@withrevert(token);

    assert lastReverted, "An asset pool is not configured";
}
