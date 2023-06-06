
import "./definitions.spec"

using PriceProvidersRepository as repository

methods {
    setupAsset(address, address, address, uint256, bool)
    setAggregator(address, address, bool)
    setFallbackPriceProvider(address, address)
    setEmergencyManager(address)
    setHeartbeat(address, uint256)

    // harness
    getLatestRoundData(address) returns uint80,int256,uint256,uint256,uint80 envfree
    getFallbackPrice(address) returns uint256 envfree
    getAggregatorDecimals(address) returns uint8 envfree
    getQuoteTokenDecimals() returns uint8 envfree

    // getters
    assetData(address) returns uint256,bool,bool,address,address envfree
    getPrice(address) returns uint256 => PER_CALLEE_CONSTANT
    quoteToken() returns address envfree
    emergencyManager() returns address envfree
    priceProvidersRepository() returns address envfree

    // simplify private function
    _normalizeWithDecimals(uint256 _price, uint8 _decimals) returns uint256 =>
    _simplifiedNormalizeWithDecimals(_price, _decimals)

    repository.manager() returns address envfree

    // Chainlink aggregator
    latestRoundData() returns uint80,int256,uint256,uint256,uint80 envfree => PER_CALLEE_CONSTANT
    decimals() returns uint8 envfree => PER_CALLEE_CONSTANT
}

function abs_diff(uint256 x, uint256 y) returns uint256 {
    if (x < y) {
        return to_uint256(y - x);
    } else {
        return to_uint256(x - y);
    }
}

/// assume that _normalizeWithDecimals fn do nothing
function _simplifiedNormalizeWithDecimals(uint256 _price, uint8 _decimals) returns uint256 {
        return _price;
}

rule VC_Chainlink_assetData_heartbeat(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset; address aggregator;
    require asset != aggregator;

    uint256 heartbeatBefore;
    heartbeatBefore, _, _, _, _ = assetData(asset);

    f(e, args);

    uint256 heartbeatAfter;
    heartbeatAfter, _, _, _, _ = assetData(asset);

    assert heartbeatBefore != heartbeatAfter =>
        f.selector == setupAssetSig() || f.selector == setHeartbeatSig(),
        "Heartbeat was changed by a method other than expected";

}

rule VC_Chainlink_assetData_forceFallback(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset; address aggregator;
    require asset != aggregator;

    bool forceFallbackBefore;
    _, forceFallbackBefore, _, _, _ = assetData(asset);

    f(e, args);

    bool forceFallbackAfter;
    _, forceFallbackAfter, _, _, _ = assetData(asset);

    assert forceFallbackBefore != forceFallbackAfter =>
        f.selector == setupAssetSig() || f.selector == emergencyDisableSig() || f.selector == setAggregatorSig(),
        "forceFallback was changed by a method other than expected";
}

rule VC_Chainlink_assetData_convertToQuote(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset; address aggregator;
    require asset != aggregator;

    bool convertToQuoteBefore;
    _, _, convertToQuoteBefore, _, _ = assetData(asset);

    f(e, args);

    bool convertToQuoteAfter;
    _, _, convertToQuoteAfter, _, _ = assetData(asset);

    assert convertToQuoteBefore != convertToQuoteAfter =>
        f.selector == setupAssetSig() || f.selector == emergencyDisableSig() || f.selector == setAggregatorSig(),
        "convertToQuote was changed by a method other than expected";
}

rule VC_Chainlink_assetData_aggregator(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset; address aggregator;
    require asset != aggregator;

    address aggregatorBefore;
    _, _, _, aggregatorBefore, _ = assetData(asset);

    f(e, args);

    address aggregatorAfter;
    _, _, _, aggregatorAfter, _ = assetData(asset);

    assert aggregatorBefore != aggregatorAfter =>
        (f.selector == setupAssetSig() || f.selector == setAggregatorSig()),
        "Aggregator was changed by a method other than expected";
}

rule VC_Chainlink_assetData_fallbackProvider(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset; address aggregator;
    require asset != aggregator;

    address fallbackProviderBefore;
    _, _, _, _, fallbackProviderBefore = assetData(asset);

    f(e, args);

    address fallbackProviderAfter;
    _, _, _, _, fallbackProviderAfter = assetData(asset);

    assert fallbackProviderBefore != fallbackProviderAfter =>
        f.selector == setupAssetSig() || f.selector == setFallbackPriceProviderSig(),
        "Fallback provider was changed by a method other than expected";
}

rule VC_Chainlink_emergencyManager(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset; address aggregator;
    require asset != aggregator;

    address emergencyManagerBefore = emergencyManager();

    f(e, args);

    address emergencyManagerAfter = emergencyManager();

    assert emergencyManagerBefore != emergencyManagerAfter =>
        f.selector == setEmergencyManagerSig(),
        "Emergency manager was changed by a method other than expected";
}

rule UT_Chainlink_setupAsset_only_manager(
    env e,
    address asset,
    address aggregator,
    address fallbackProvider,
    uint256 heartbeat,
    bool convertToQuote
) {
    setupAsset@withrevert(e, asset, aggregator, fallbackProvider, heartbeat, convertToQuote);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to setup an asset";
}

rule UT_Chainlink_setAggregator_only_manager(env e, address asset, address aggregator, bool convertToQuote) {
    setAggregator@withrevert(e, asset, aggregator, convertToQuote);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to set an aggregator";
}

rule UT_Chainlink_setFallbackPriceProvider_only_manager(env e, address asset, address provider) {
    setFallbackPriceProvider@withrevert(e, asset, provider);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to set a fallbackProvider";
}

rule UT_Chainlink_setHeartbeat_only_manager(env e, address asset, uint256 heartbeat) {
    setHeartbeat@withrevert(e, asset, heartbeat);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to set a heartbeat";
}

rule UT_Chainlink_setEmergencyManager_only_manager(env e, address emergencyManager) {
    setEmergencyManager@withrevert(e, emergencyManager);
    bool reverted = lastReverted;

    assert e.msg.sender != repository.manager() => reverted,
        "Only the manager should be able to set the emergencyManager";
}

rule UT_Chainlink_emergencyDisable_only_emergencyManager(env e, address asset) {
    emergencyDisable@withrevert(e, asset);
    bool reverted = lastReverted;

    assert e.msg.sender != emergencyManager() => reverted,
        "Only the emergencyManager should be able to emergency disable an asset";
}

rule UT_Chainlink_emergencyDisable_no_price(env e, address asset) {
    require e.msg.sender == emergencyManager();

    int256 price;
    _, price, _, _, _ = getLatestRoundData(asset);

    emergencyDisable@withrevert(e, asset);
    bool reverted = lastReverted;


    assert price <= 0 => reverted,
        "Invalid price didn't cause a revert";
}

rule UT_Chainlink_emergencyDisable_small_price_difference(env e, address asset) {
    require e.msg.sender == emergencyManager();

    bool convertToQuote;
    _, _, convertToQuote, _, _ = assetData(asset);

    int256 aggPrice;
    _, aggPrice, _, _, _ = getLatestRoundData(asset);
    require aggPrice != 0;

    uint256 fallbackPrice = getFallbackPrice(asset);

    emergencyDisable@withrevert(e, asset);
    bool reverted = lastReverted;

    uint256 percentageDiff = abs_diff(to_uint256(aggPrice), fallbackPrice) * 100 * 1000000 / to_uint256(aggPrice);

    assert (!convertToQuote && percentageDiff < 10 * 1000000) => reverted,
        "Price difference didn't cause a revert";
}
