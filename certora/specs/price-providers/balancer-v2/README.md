# Properties of BalancerV2 price provider

## Types of Properties

- Variable Changes
- Valid state
- Unit Tests

### Variable Changes

- An asset pool can be configured only by setupAsset fn.\
  Implementation: rule `VC_BalancerV2_asset_pool`

- _state.periodForAvgPrice can be updated only by changePeriodForAvgPrice, changeSettings.\
  Implementation: rule `VC_BalancerV2_periodForAvgPrice`

- _state.secondsAgo can be updated only by changeSecondsAgo, changeSettings.\
  Implementation: rule `VC_BalancerV2_secondsAgo`

### Valid state

- _state.periodForAvgPrice can't be set to 0
  Implementation: rule `VS_BalancerV2_periodForAvgPrice_is_not_zero`

### Unit Tests

- Only the manager can configure an asset pool. \
  Implementation: rule `UT_BalancerV2_setupAsset_only_manager`

- Only the manager can configure a periodForAvgPrice. \
  Implementation: rule `UT_BalancerV2_changePeriodForAvgPrice_only_manager`

- Only the manager can configure a secondsAgo. \
  Implementation: rule `UT_BalancerV2_changeSecondsAgo_only_manager`

- Only the manager can change settings. \
  Implementation: rule `UT_BalancerV2_changeSettings_only_manager`

- getPrice fn should revert if a Price oracle is not configured for an asset. \
  Implementation: rule `UT_BalancerV2_getPrice_with_not_configured_pool`
