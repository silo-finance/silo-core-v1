// Two bridge assets, two removed bridge assets. Length of the arrays is below three so it will be possible to unroll loops in 
// depth of three. There are no duplicates of bridge assets in the set, no duplicates in removed bridge assets.
// Specification requires to define it manually.
function validBridgeAssetsState() returns bool {
    return bridgeAssetsAmountHarness() == 2 && removedBridgeAssetsAmountHarness() == 2 && 
        getBridgeAssetHarness(0) != getBridgeAssetHarness(1) && getRemovedBridgeAssetHarness(0) != getRemovedBridgeAssetHarness(1);
}
