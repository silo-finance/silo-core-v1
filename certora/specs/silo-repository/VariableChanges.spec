import "./_common/methods.spec"
import "./_common/definitions.spec"
import "./_common/functionSelectors.spec"
import "./_common/validStateHelper.spec"

rule VCH_setDefaultLiquidationThresholdOnlyOwner(method f)
    filtered { f -> !f.isView && !f.isFallback } 
{
    env e;
    calldataarg args;

    uint64 defaultThresholdBefore = getDefaultLiquidationThreshold();

    f(e, args);

    uint64 defaultThresholdAfter = getDefaultLiquidationThreshold();
    address ownerAddr = owner();

    assert (defaultThresholdBefore != defaultThresholdAfter) <=> 
            (f.selector == setDefaultLiquidationThresholdSig() && e.msg.sender == ownerAddr);
}

rule VCH_setDefaultMaximumLTVOnlyOwner(method f) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    uint64 defaultMaxLTVBefore = getDefaultMaxLoanToValue();

    f(e, args);

    uint64 defaultMaxLTVAfter = getDefaultMaxLoanToValue();
    address ownerAddr = owner();

    assert (defaultMaxLTVBefore != defaultMaxLTVAfter) <=> 
            (f.selector == setDefaultMaximumLTVSig() && e.msg.sender == ownerAddr);
}

rule VCH_setDefaultInterestRateModelOnlyOwner(method f) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    address defaultInterestRateModelBefore = getDefaultInterestRateModel();

    f(e, args);

    address defaultInterestRateModelAfter = getDefaultInterestRateModel();
    address ownerAddr = owner();

    assert (defaultInterestRateModelBefore != defaultInterestRateModelAfter) <=> 
            (f.selector == setDefaultInterestRateModelSig() && e.msg.sender == ownerAddr);
}

rule VCH_setPriceProvidersRepositoryOnlyOwner(method f) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    address priceProvidersRepositoryBefore = priceProvidersRepository();

    f(e, args);

    address priceProvidersRepositoryAfter = priceProvidersRepository();
    address ownerAddr = owner();

    assert (priceProvidersRepositoryBefore != priceProvidersRepositoryAfter) <=> 
            (f.selector == setPriceProvidersRepositorySig() && e.msg.sender == ownerAddr);
}

rule VCH_setRouterOnlyOwner(method f) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    address routerBefore = router();

    f(e, args);

    address routerAfter = router();
    address ownerAddr = owner();

    assert (routerBefore != routerAfter) <=> 
            (f.selector == setRouterSig() && e.msg.sender == ownerAddr);
}

rule VCH_setNotificationReceiverOnlyOwner(method f, address silo) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;

    address notificationReceiverBefore = getNotificationReceiver(silo);
    address notificationReceiver;
    SRFSNotificationReceiver(e, f, silo, notificationReceiver);

    address notificationReceiverAfter = getNotificationReceiver(silo);

    assert (notificationReceiverBefore != notificationReceiverAfter) <=>
            (f.selector == setNotificationReceiverSig() && e.msg.sender == owner() && notificationReceiver == notificationReceiverAfter);
}

rule VCH_setTokensFactoryOnlyOwner(method f) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;

    address tokensFactoryBefore = tokensFactory();
    address tokensFactory;
    SRFSTokensFactory(e, f, tokensFactory);

    address tokensFactoryAfter = tokensFactory();

    assert (tokensFactoryBefore != tokensFactoryAfter) => 
            (f.selector == setTokensFactorySig() && e.msg.sender == owner() && tokensFactory == tokensFactoryAfter);
}

rule VCH_assetConfigOnlyOwner(method f, address silo, address asset) 
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    address interestRateModelBefore = getInterestRateModel(silo, asset);
    uint256 maxLTVBefore = getMaximumLTV(silo, asset);
    uint256 liquidationThresholdBefore = getLiquidationThreshold(silo, asset);

    f(e, args);

    address interestRateModelAfter = getInterestRateModel(silo, asset);
    uint256 maxLTVAfter = getMaximumLTV(silo, asset);
    uint256 liquidationThresholdAfter = getLiquidationThreshold(silo, asset);

    assert (interestRateModelBefore != interestRateModelAfter || 
            maxLTVBefore != maxLTVAfter || 
            liquidationThresholdBefore != liquidationThresholdAfter) => 
            (e.msg.sender == owner());
}

rule VCH_bridgeAssets(method f, address asset) 
    filtered { f -> !f.isView && !f.isFallback }
{
    require validBridgeAssetsState();

    bool containsBefore = bridgeAssetsContainsHarness(asset);

    env e;
    SRFSBridgeAssets(e, f, asset);

    bool containsAfter = bridgeAssetsContainsHarness(asset);
    address ownerAddr = owner();

    assert (
        ((containsAfter && !containsBefore) <=> (f.selector == addBridgeAssetSig() && e.msg.sender == ownerAddr)) &&
        ((!containsAfter && containsBefore) <=> (f.selector == removeBridgeAssetSig() && e.msg.sender == ownerAddr))
    );
}

rule VCH_removedBridgeAssets(method f, address asset) 
    filtered { f -> !f.isView && !f.isFallback }
{
    require validBridgeAssetsState();

    bool containsBefore = removedBridgeAssetsContainsHarness(asset);

    env e;
    SRFSBridgeAssets(e, f, asset);

    bool containsAfter = removedBridgeAssetsContainsHarness(asset);
    address ownerAddr = owner();

    assert (
        ((containsAfter && !containsBefore) => (f.selector == removeBridgeAssetSig() && e.msg.sender == ownerAddr)) &&
        ((!containsAfter && containsBefore) => (f.selector == addBridgeAssetSig() && e.msg.sender == ownerAddr))
    );
}

rule VCH_registerSiloVersionDefaultIsLatest(address factory, bool isDefault) {
    env e;
    calldataarg args;

    require getDefaultSiloVersion() <= getLatestSiloVersion();

    registerSiloVersion(e, factory, isDefault);

    assert (isDefault <=> getDefaultSiloVersion() == getLatestSiloVersion()) && e.msg.sender == owner();
}

rule VCH_defaultSiloVersion(method f)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;
    
    uint128 defaultSiloVersionBefore = getDefaultSiloVersion();
    require getDefaultSiloVersion() <= getLatestSiloVersion();
    
    address asset;
    bool isDefault;
    uint128 siloVersion;

    SRFSSiloVersion(e, f, asset, isDefault, siloVersion);

    uint128 defaultSiloVersionAfter = getDefaultSiloVersion();
    address ownerAddr = owner();

    assert (defaultSiloVersionBefore != defaultSiloVersionAfter) => (
        e.msg.sender == ownerAddr && (
            f.selector == registerSiloVersionSig() && isDefault == true || 
            f.selector == setDefaultSiloVersionSig() && defaultSiloVersionAfter == siloVersion
        ) 
    );
}
