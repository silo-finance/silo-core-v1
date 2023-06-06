# Properties of UniswapV3 price provider

## Types of Properties

- Variable Changes
- Unit Tests

### Variable Changes

- An asset pool can be configured only by setupAsset fn.\
  Implementation: rule `VC_UniswapV3_asset_pool`

- priceCalculationData.periodForAvgPrice can be updated only\
  by changePeriodForAvgPrice fn.\
  Implementation: rule `VC_UniswapV3_periodForAvgPrice`

- priceCalculationData.blockTime can be updated only by changeBlockTime fn.\
  Implementation: rule `VC_UniswapV3_blockTime`

### Unit Tests

- Only the manager can configure an asset pool. \
  Implementation: rule `UT_UniswapV3_setupAsset_only_manager`

- Only the manager can configure a periodForAvgPrice. \
  Implementation: rule `UT_UniswapV3_changePeriodForAvgPrice_only_manager`

- Only the manager can configure a blockTime. \
  Implementation: rule `UT_UniswapV3_changeBlockTime_only_manager`
