# Properties of SiloRepository

## Types of Properties

- Valid States
- Variable Changes
- Unit Tests

### Valid States

- Solvency precision decimals are 10e18 and can not be changed.\
  Implementation: invariant `VS_solvencyPrecisionDecimals`

- Default liquidation threshold ∈ (0, 10^18].\
  Implementation: invariant `VS_defaultLiquidationThreshold`

- For every Silo and every asset assetConfig liquidation threshold ∈ (0, 10^18].\
  Implementation: invariant `VS_siloLiquidationThreshold`

- Default max loan to value ∈ (0, 10^18].\
  Implementation: invariant `VS_defaultMaxLTV`

- For every Silo and every asset assetConfig max loan to value ∈ (0, 10^18].\
  Implementation: invariant `VS_siloMaxLTV`

- Default liquidation threshold is greater than default max loan to value.\
  Implementation: invariant `VS_defaultLiquidationThresholdGreaterMaxLTV`

- For every Silo and every asset assetConfig liquidation threshold is greater than max loan to value.\
  Implementation: invariant `VS_siloLiquidationThresholdGreaterMaxLTV`

- For every Silo and every asset assetConfig.liquidationThreshold == 0 <=> assetConfig.maxLoanToValue == 0.\
  Implementation: invariant `VS_halfOfAssetConfigIsNeverEmpty`

- Entry fee ∈ (0, Solvency._PRECISION_DECIMALS].\
  Implementation: invariant `VS_entryFee`

- Protocol share fee ∈ (0, Solvency._PRECISION_DECIMALS].\
  Implementation: invariant `VS_protocolShareFee`

- Protocol liquidation fee ∈ (0, Solvency._PRECISION_DECIMALS].\
  Implementation: invariant `VS_protocolLiquidationFee`

- Protocol liquidation fee ∈ (0, Solvency._PRECISION_DECIMALS].\
  Implementation: invariant `VS_protocolLiquidationFee`

- Default Silo factory is never equal to zero address. If the factory version for an asset is not the default one, the Silo factory for this asset can be zero only if unregisterSiloVersion() is called. State after constructor call is not proved, but checked manually.\
  Implementation: rule `VS_complexInvariant_siloFactory`

### Variable Changes

- Default liquidation threshold can be set only by setDefaultLiquidationThreshold. ((Default liquidation threshold changed) <=> (f.selector == setDefaultLiquidationThreshold && msg.sender == owner)).\
  Implementation: rule `VCH_setDefaultLiquidationThresholdOnlyOwner`

- Default max loan to value can be set only by setDefaultLiquidationThreshold. ((default max loan to value changed) <=> (f.selector == setDefaultMaximumLTV && msg.sender == owner)).\
  Implementation: rule `VCH_setDefaultMaximumLTVOnlyOwner`

- Default interest rate model can be set only by setDefaultInterestRateModel. ((default max loan to value changed) <=> (f.selector == setDefaultInterestRateModel && msg.sender == owner)).\
  Implementation: rule `VCH_setDefaultInterestRateModelOnlyOwner`

- Price providers repository can be set only by setPriceProvidersRepository. ((price provider repository changed) <=> (f.selector == setPriceProvidersRepository && msg.sender == owner)).\
  Implementation: rule `VCH_setPriceProvidersRepositoryOnlyOwner`

- Router can be set only by setRouter. ((router changed) <=> (f.selector == setRouter && msg.sender == owner)).\
  Implementation: rule `VCH_setRouterOnlyOwner`

- Notification receiver can be set only by setNotificationReceiver. ((notification receiver changed) <=> (f.selector == setNotificationReceiver && msg.sender == owner)).\
  Implementation: rule `VCH_setNotificationReceiverOnlyOwner`

- Tokens factory can be set only by setTokensFactory. ((tokens factory changed) <=> (f.selector == setTokensFactory && msg.sender == owner)).\
  Implementation: rule `VCH_setTokensFactoryOnlyOwner`

- Asset config updated <=> msg.sender is the owner.\
  Implementation: rule `VCH_assetConfigOnlyOwner`

- ((new asset in getBridgeAssets()) <=> (f.selector == addBridgeAsset && msg.sender == owner)) && ((asset is removed from getBridgeAssets()) <=> (f.selector == removeBridgeAsset && msg.sender == owner)).\
  Implementation: rule `VCH_bridgeAssets`

- ((new asset in getRemovedBridgeAssets()) <=> (f.selector == removeBridgeAsset && msg.sender == owner)) && ((asset is removed from getRemovedBridgeAssets()) <=> (f.selector == addBridgeAsset && msg.sender == owner)).\
  Implementation: rule `VCH_removedBridgeAssets`

- When registerSiloVersion(..., isDefault) is called. msg.sender == owner && (latest version is default <=> isDefault == true).\
  Implementation: rule `VCH_registerSiloVersionDefaultIsLatest`

- If the default Silo version is changed to newDefaultSiloVersion, then msg.sender == owner && (f.selector == registerSiloVersion(...,isDefault = true) || f.selector == setDefaultSiloVersion(..., siloVersion = newDefaultSiloVersion)).\
  Implementation: rule `VCH_defaultSiloVersion`

### Unit Tests

- For every asset (getSilo(asset) == 0 || siloReverse(getSilo(asset)) == asset || getSilo(asset) == bridgePool()).\
  Implementation: invariant `UT_getSiloReverseSilo`

- If the asset is a removed bridge asset, it is not a bridge asset.\
  Implementation: invariant `UT_removedBridgeAssetIsNotBridge`

- If the asset is a bridge asset, it is not a removed bridge asset.\
  Implementation: invariant `UT_bridgeAssetIsNotRemoved`

- Silo can be created for an asset in all cases, except (getSilo(asset) != 0 || assetIsABridge && (bridgeAssetsAmount == 1 || bridgePool != 0)). State after constructor call is not proved, but checked manually.\
  Implementation: invariant `UT_complexInvariant_ensureCanCreateSiloFor`

- If the asset is a bridge asset, then Silo for this asset is not yet created or the Silo is a bridge pool.\
  Implementation: invariant `UT_assetIsBridgeThenSiloIsBridgePool`

- If the asset is a removed bridge asset, then Silo for this asset is not yet created or the Silo is NOT a bridge pool.\
  Implementation: rule `UT_assetIsBridgeThenSiloIsBridgePool`
