import "./_common/methods.spec"
import "./_common/validStateHelper.spec"

invariant UT_getSiloReverseSilo(address asset)
    validBridgeAssetsState() =>
        (getSilo(asset) == 0 || siloReverse(getSilo(asset)) == asset || getSilo(asset) == bridgePool())

invariant UT_removedBridgeAssetIsNotBridge(address asset)
    validBridgeAssetsState() =>
        (removedBridgeAssetsContainsHarness(asset) => !bridgeAssetsContainsHarness(asset))
        

invariant UT_bridgeAssetIsNotRemoved(address asset)
    validBridgeAssetsState() =>
        (bridgeAssetsContainsHarness(asset) => !removedBridgeAssetsContainsHarness(asset))

rule UT_complexInvariant_ensureCanCreateSiloFor(address asset, bool assetIsABridge) {
    env e;
    address silo = getSilo(asset);
    address bridge = bridgePool();
    uint256 bridgeAssetsAmount = bridgeAssetsAmountHarness();

    ensureCanCreateSiloFor@withrevert(asset, assetIsABridge);

    bool reverted = lastReverted;

    assert reverted <=> (silo != 0 || assetIsABridge && (bridgeAssetsAmount == 1 || bridge != 0));
}

invariant UT_assetIsBridgeThenSiloIsBridgePool(address asset)
    validBridgeAssetsState() =>
        (bridgeAssetsContainsHarness(asset) => (getSilo(asset) == 0 || getSilo(asset) == bridgePool()))

invariant UT_assetIsRemovedBridgeThenSiloIsNotBridgePool(address asset)
    validBridgeAssetsState() =>
        (removedBridgeAssetsContainsHarness(asset) => (getSilo(asset) == 0 || getSilo(asset) != bridgePool()))
