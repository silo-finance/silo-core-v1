# Properties of UniswapV3 V2 price provider

## Types of Properties

- Valid States
- Variable Changes
- Unit Tests

### Valid States
- Setting for TWAP window must match the rule: `periodForAvgPrice / blocktime < max(uint16)`  
  Implementation: rule `VS_priceCalculationDataAlwaysValid`

### Variable Changes

- An `_assetPath` can be configured only by `setupAsset` fn. After successful configuration asset must be supported. 
  Once supported it can't be reverted. Configuration can be done only by manager.  
  Implementation: rule `VC_UniswapV3PriceProviderV2_assetPath`

- `priceCalculationData.periodForAvgPrice` can be updated only by `changePeriodForAvgPrice` fn. After update, 
  it must be less than current timestamp. Configuration can be done only by manager.  
  Implementation: rule `VC_UniswapV3PriceProviderV2_periodForAvgPrice`

- `priceCalculationData.blockTime` can be updated only by `changeBlockTime` fn. After update,
  it must be less than `MAX_ACCEPTED_BLOCK_TIME`. Configuration can be done only by manager.  
  Implementation: rule `VC_UniswapV3PriceProviderV2_blockTime`

### Unit Tests

- `verifyPools` returns valid pools path or reverts when invalid data.  
  Implementation: rule `UT_UniswapV3PriceProviderV2_verifyPools`
