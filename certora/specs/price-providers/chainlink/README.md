# Properties of Chainlink price provider

## Types of Properties

- Variable Changes
- Unit Tests

### Variable Changes

- The heartbeat for an asset can only be configured by the setupAsset or setHeartbeatThreshold functions.\
  Implementation: rule `VC_Chainlink_assetData_heartbeat`

- The forceFallback bool for an asset can only change by the setupAsset, setAggregator or emergencyDisable functions.\
  Implementation: rule `VC_Chainlink_assetData_forceFallback`

- The convertToQuote boolean for an asset can only be configured by the setupAsset or setAggregator functions.\
  Implementation: rule `VC_Chainlink_assetData_convertToQuote`

- The aggregator for an asset can only be configured by the setupAsset or setAggregator functions.\
  Implementation: rule `VC_Chainlink_assetData_aggregator`

- The fallbackProvider for an asset can only be configured by the setupAsset or setFallbackPriceProvider functions.\
  Implementation: rule `VC_Chainlink_assetData_fallbackProvider`

- The emergencyManager can only be changed by the setEmergencyManager function. \
  Implementation: rule `VC_Chainlink_emergencyManager`
### Unit Tests

- Only the manager can configure an asset. \
  Implementation: rule `UT_Chainlink_setupAsset_only_manager`

- Only the manager can configure the aggregator for an asset. \
  Implementation: rule `UT_Chainlink_setAggregator_only_manager`

- Only the manager can configure the fallback price provider for an asset. \
  Implementation: rule `UT_Chainlink_setFallbackPriceProvider_only_manager`

- Only the manager can configure the heartbeat for an asset. \
  Implementation: rule `UT_Chainlink_setHeartbeatThreshold_only_manager`

- Only the manager can configure the emergency manager. \
  Implementation: rule `UT_Chainlink_setEmergencyManager_only_manager`

- Only the emergency manager can call the emergencyDisable function. \
  Implementation: rule `UT_Chainlink_emergencyDisable_only_emergencyManager`

- Emergency disabling reverts if there is no price provided by aggregator. \
  Implementation: rule `UT_Chainlink_emergencyDisable_no_price`

- Emergency disabling reverts if there is a small price difference between aggregator and fallback. \
  Implementation: rule `UT_Chainlink_emergencyDisable_small_price_difference`