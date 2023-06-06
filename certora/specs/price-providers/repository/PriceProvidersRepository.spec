methods {
    addPriceProvider(address)
    removePriceProvider(address)
    setPriceProviderForAsset(address, address)

    // getters
    providersCount() returns uint256 envfree
    providersReadyForAsset(address) returns bool envfree
    owner() returns address envfree
    manager() returns address envfree
    isPriceProvider(address) returns bool envfree

    assetSupported(address asset) returns bool => isSupported(asset)
}

ghost mapping(address => bool) isSupportedStorage;

function isSupported(address asset) returns bool {
    return isSupportedStorage[asset];
}

rule VC_Price_providers_repository_add_provider(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint256 before = providersCount();
    require before < max_uint128;
    f(e, args);
    uint256 after = providersCount();

    assert before < after => after == before + 1 &&
        f.selector == addPriceProvider(address).selector,
        "A price provider added by function other than expected";
}

rule VC_Price_providers_repository_remove_provider(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    uint256 before = providersCount();
    require before < max_uint128;
    f(e, args);
    uint256 after = providersCount();

    assert before > after => after == before - 1 &&
        f.selector == removePriceProvider(address).selector,
        "A price provider removed by function other than expected";
}

rule VC_Price_providers_repository_priceProviders(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback }
{
    address asset;
    require providersReadyForAsset(asset) == false;

    bool before = providersReadyForAsset(asset);
    f(e, args);
    bool after = providersReadyForAsset(asset);

    assert after =>
        f.selector == setPriceProviderForAsset(address,address).selector,
        "Provider for the asset configured by method other than expected";
}

rule UT_Price_providers_repository_add_provider(env e, address priceProvider) {
    addPriceProvider@withrevert(e, priceProvider);
    bool reverted = lastReverted;

    assert e.msg.sender != owner() => reverted,
        "Only the owner should be able to add a price provider";
}

rule UT_Price_providers_repository_remove_provider(env e, address priceProvider) {
    require isPriceProvider(priceProvider) == true;

    removePriceProvider@withrevert(e, priceProvider);
    bool reverted = lastReverted;

    assert e.msg.sender != owner() => reverted,
        "Only the owner should be able to remove a price provider";
}

rule UT_Price_providers_repository_set_provider(env e, address priceProvider, address asset) {
    require isPriceProvider(priceProvider) == true;

    setPriceProviderForAsset@withrevert(e, asset, priceProvider);
    bool reverted = lastReverted;

    assert e.msg.sender != manager() => reverted,
        "Only the manager should be able to set a price provider for an asset";
}
