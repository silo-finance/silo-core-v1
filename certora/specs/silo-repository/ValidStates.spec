import "./_common/methods.spec"
import "./_common/definitions.spec"
import "./_common/functionSelectors.spec"

invariant VS_solvencyPrecisionDecimals()
    solvencyPrecisionDecimals() == 10^18

invariant VS_defaultLiquidationThreshold()
    getDefaultLiquidationThreshold() <= oneHundredPercent() && 
    getDefaultLiquidationThreshold() > 0

invariant VS_siloLiquidationThreshold(address silo, address asset)
    getLiquidationThreshold(silo, asset) <= oneHundredPercent() && 
    getLiquidationThreshold(silo, asset) > 0

invariant VS_defaultMaxLTV()
    getDefaultMaxLoanToValue() <= oneHundredPercent() && 
    getDefaultMaxLoanToValue() > 0

invariant VS_siloMaxLTV(address silo, address asset)
    getMaximumLTV(silo, asset) <= oneHundredPercent() && 
    getMaximumLTV(silo, asset) > 0

invariant VS_defaultLiquidationThresholdGreaterMaxLTV()
    getDefaultLiquidationThreshold() > getDefaultMaxLoanToValue()

invariant VS_siloLiquidationThresholdGreaterMaxLTV(address silo, address asset)
    getLiquidationThreshold(silo, asset) > getMaximumLTV(silo, asset)
    { 
		preserved with (env e) {
			requireInvariant VS_halfOfAssetConfigIsNeverEmpty(silo, asset);
		}
    }

invariant VS_halfOfAssetConfigIsNeverEmpty(address silo, address asset)
    assetConfigLTVHarness(silo, asset) == 0 <=> assetConfigLiquidationThresholdHarness(silo, asset) == 0

invariant VS_entryFee()
    entryFee() >= 0 && entryFee() <= solvencyPrecisionDecimals()

invariant VS_protocolShareFee()
    protocolShareFee() >= 0 && protocolShareFee() <= solvencyPrecisionDecimals()

invariant VS_protocolLiquidationFee()
    protocolLiquidationFee() >= 0 && protocolLiquidationFee() <= solvencyPrecisionDecimals()

rule VS_complexInvariant_siloFactory(method f, address asset) 
    filtered { f -> !f.isView && !f.isFallback } 
{
    require(getDefaultSiloVersion() > 0);

    uint128 versionForAssetBefore = getVersionForAsset(asset);
    require(siloFactory(getDefaultSiloVersion()) != 0);
    require(versionForAssetBefore != 0 => siloFactory(versionForAssetBefore) != 0);

    env e;
    calldataarg args;
    uint128 siloVersion;

    SRFSSiloVersion(e, f, asset, false, siloVersion);

    assert (
        (siloFactory(getDefaultSiloVersion()) != 0) && 
        (f.selector == unregisterSiloVersionSig() && siloVersion == versionForAssetBefore || (
            getVersionForAsset(asset) != 0 => siloFactory(getVersionForAsset(asset)) != 0
        ))
    );
}
