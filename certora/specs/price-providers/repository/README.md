# Properties of Price providers repository

## Types of Properties

- Variable Changes
- Unit Tests

### Variable Changes

- Add to _allProviders array can only addPriceProvider.\
  Implementation: rule `VC_Price_providers_repository_add_provider`

- Remove from _allProviders array can only removePriceProvider.\
  Implementation: rule `VC_Price_providers_repository_remove_provider`

- Change priceProviders can only setPriceProviderForAsset. \
  Implementation: rule `VC_Price_providers_repository_priceProviders`

### Unit Tests

- Only the owner can add the price provider. \
  Implementation: rule `UT_Price_providers_repository_add_provider`

- Only the owner can remove the price provider. \
  Implementation: rule `UT_Price_providers_repository_remove_provider`

- Only the owner can set the price provider for an asset. \
  Implementation: rule `UT_Price_providers_repository_set_provider`
