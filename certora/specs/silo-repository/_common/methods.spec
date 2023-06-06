methods {
    getLiquidationThreshold(address _silo, address _asset) returns (uint256) envfree
    getMaximumLTV(address _silo, address _asset) returns (uint256) envfree
    getInterestRateModel(address _silo, address _asset) returns (address) envfree
    entryFee() returns (uint256) envfree
    protocolShareFee() returns (uint256) envfree
    protocolLiquidationFee() returns (uint256) envfree
    priceProvidersRepository() returns (address) envfree
    router() returns (address) envfree
    getBridgeAssets() returns (address[]) envfree
    getSilo(address asset) returns (address) envfree
    siloReverse(address silo) returns (address) envfree
    bridgePool() returns (address) envfree
    tokensFactory() returns (address) envfree
    ensureCanCreateSiloFor(address _asset, bool _assetIsABridge) envfree
    owner() returns (address) envfree
    getVersionForAsset(address asset) returns (uint128) envfree
    siloFactory(uint256 version) returns (address) envfree
    getNotificationReceiver(address _silo) returns (address) envfree

    // HARNESS
    solvencyPrecisionDecimals() returns (uint256) envfree
    getDefaultLiquidationThreshold() returns (uint64) envfree
    getDefaultMaxLoanToValue() returns (uint64) envfree
    getDefaultInterestRateModel() returns (address) envfree
    getDefaultSiloVersion() returns (uint128) envfree
    getLatestSiloVersion() returns (uint128) envfree
    assetConfigLTVHarness(address _silo, address _asset) returns (uint64) envfree
    assetConfigLiquidationThresholdHarness(address _silo, address _asset) returns (uint64) envfree
    bridgeAssetsContainsHarness(address asset) returns (bool) envfree
    removedBridgeAssetsContainsHarness(address asset) returns (bool) envfree
    bridgeAssetsAmountHarness() returns (uint256) envfree
    removedBridgeAssetsAmountHarness() returns (uint256) envfree
    getRemovedBridgeAssetHarness(uint256 index) returns (address) envfree
    getBridgeAssetHarness(uint256 index) returns (address) envfree

    // DISPATCHERS
    syncBridgeAssets() => NONDET
    createSilo(address, uint128, bytes) => NONDET
}
