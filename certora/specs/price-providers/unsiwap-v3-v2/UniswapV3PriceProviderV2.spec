import "./_common/UniswapV3PriceProviderV2Sig.spec"

using PricePriovidersRepository076 as repository

methods {
    setupAsset(address, address[])
    changePeriodForAvgPrice(uint32)
    changeBlockTime(uint8)

    // harness
    getPeriodForAvgPrice() returns uint32 envfree
    getBlockTime() returns uint8 envfree

    // getters
    pools(address) returns ((address,bool)[]) envfree
    getJustPool(address, uint256) returns address envfree
    getPrice(address) returns uint256
    quoteToken() returns address envfree
    priceProvidersRepository() returns address envfree
    assetSupported(address) returns bool envfree
    verifyPools(address, address[]) returns ((address,bool)[]) envfree
    verifyPoolsHarness(address, address[]) returns uint256 envfree

    repository.manager() returns address envfree

    balanceOf(address) returns (uint256) => PER_CALLEE_CONSTANT
    token1() returns (address) => PER_CALLEE_CONSTANT
    token0() returns (address) => PER_CALLEE_CONSTANT
    getPool(address, address, uint256) returns (address) => PER_CALLEE_CONSTANT
    fee() returns (uint24) => CONSTANT
    slot0() returns (uint160, int24, uint16, uint16, uint16, uint8, bool) => PER_CALLEE_CONSTANT
    getPrice(address) returns (uint) => CONSTANT
}

function initialize2Pools(address asset, address[] pools) {
    address pool1;
    address pool2;

    require pool1 != pool2;
    require asset != pool1;
    require asset != pool2;

    require pools[0] == pool1;
    require pools[1] == pool2;

    require pools.length == 2;
}

invariant VS_priceCalculationDataAlwaysValid()
  getPeriodForAvgPrice() / getBlockTime() <= max_uint16

rule VC_UniswapV3PriceProviderV2_assetPath(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset;
    address[] pools;

    initialize2Pools(asset, pools);

    address before0 = getJustPool(asset, 0);
    address before1 = getJustPool(asset, 1);

    bool assetWasSupported = assetSupported(asset);

    if (f.selector == setupAssetSig()) {
        setupAsset(e, asset, pools);
    } else {
        f(e, args);
    }

    bool reverted = lastReverted;

    address after0 = getJustPool(asset, 0);
    address after1 = getJustPool(asset, 1);

    bool stateChanged = before0 != after0 || before1 != after1;

    assert stateChanged => f.selector == setupAssetSig(),
        "An asset path been configured by a method other than expected";

    assert f.selector == setupAssetSig() && !reverted => assetSupported(asset), "asset not supported after setup";

    assert assetWasSupported => assetSupported(asset), "once asset is supported, it can't be reverted";
}

// priceCalculationData.periodForAvgPrice can be updated only by changePeriodForAvgPrice fn.
rule VC_UniswapV3PriceProviderV2_periodForAvgPrice(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint32 before = getPeriodForAvgPrice();
    f(e, args);
    uint32 after = getPeriodForAvgPrice();

    bool stateChanged = before != after;

    assert stateChanged => f.selector == changePeriodForAvgPrice(uint32).selector,
        "A periodForAvgPrice changed by the method other than expected";

    assert stateChanged => after == 0 || after < e.block.timestamp, "A periodForAvgPrice higher than expected";

    assert stateChanged => e.msg.sender == repository.manager(),
        "Only the manager should be able to change periodForAvgPrice";
}

rule VC_UniswapV3PriceProviderV2_blockTime(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint32 before = getBlockTime();
    f(e, args);
    uint32 after = getBlockTime();

    bool stateChanged = before != after;

    assert stateChanged => f.selector == changeBlockTime(uint8).selector,
        "A blockTime changed by the method other than expected";

    uint256 MAX_ACCEPTED_BLOCK_TIME = 60;
    assert stateChanged => after != 0 && after < MAX_ACCEPTED_BLOCK_TIME, "A blockTime higher than expected";

    assert stateChanged => e.msg.sender == repository.manager(),
        "Only the manager should be able to change blockTime";
}

rule UT_UniswapV3PriceProviderV2_verifyPools() {
    address asset;
    address[] pools;

    initialize2Pools(asset, pools);

    uint256 pathLength = verifyPoolsHarness@withrevert(asset, pools);

    assert !lastReverted => pathLength == 2, "when not reverted, we should have path";
}
