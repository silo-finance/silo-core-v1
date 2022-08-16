# How to create a Silo

Note: Every contract method comes with NatSpec documentation. Please visit etherscan to see details about methods and
params.

## Deploy a new Silo

Anyone can create new silo for asset:

1. Go to `SiloRepository` and use `getSilo(asset)` to check if there is already a Silo for the token asset in question.  
   If a Silo already exists, you can't create a new Silo. Only one Silo can exist for one token asset.
2. Execute `SiloRepository.newSilo`. Once executed, the Silo will be created but its functionality will be limited to
   depositing only.
   In order to get full functionality, a configuration process is required (see "Silo configuration" section).

## Pool to provide TWAP price

At the time of writing this document, the Silo protocol supports two price providers: UniswapV3 and BalancerV2.

If you choose a BalancerV2 pool, no acation is required.

In order to use a UniswapV3 pool, you need to check if you can use the pool.  
Call `UniswapV2PriceProvider.verifyPool()` to check if pool is ready to use.
If the return you get is `false`, you need to prepare the pool by calling
`UniswapV2PriceProvider.adjustOracleCardinality(IUniswapV3Pool)` (you need to call this only once per pool).
Once called, the pool needs some time to become ready (it might be minutes or hours depending on the's pool usage).
You can check if pool is ready by calling `verifyPool()` again.

## Silo configuration

Silo configuration is done via SiloDAO proposals.
Proposal needs to be sent to SiloDAO's `Governor` contract.
(tip: check `SiloRepository.owner()` to get the `Governor` address).

`Governor` allows to execute batch of transactions as a one and therefore all necessary methods that need to be executed can be packed in one proposal.  

Below you can find list of transactions that needs to be executed in order to fully configure the Silo.

Note: all transactions need to be executed as part of the proposal, not as direct transactions.

1. [required] Execute `setupAsset()` on selected provider.
    1. you can easily check if the token asset is already supported in the provider by simply calling `getPrice` on it.
       If the asset is already supported, you can skip this setup.
2. [required] Execute `PriceProvidersRepository.setPriceProviderForAsset`
    1. you can skip this step only, if `PriceProvidersRepository.getPrice(asset)` returns a price, and you agree to keep
       using the current provider.
3. [optional] Execute `SiloRepository.setAssetConfig`
    1. if you don't not setup dedicated configuration for the Silo, a default one will be used. You can check the default configuration by
       calling `SiloRepository.defaultAssetConfig()`
4. [optional] Execute `InterestRateModel.setConfig()`
    1. if you don't not setup dedicated configuration for your silo, a default one will be used. You can check the default config by
       calling `InterestRateModel.config(0x0, 0x0)` with empty addresses. The same result will be returner when you provide
       your Silo and asset addresses except when there is a dedicated configuration that is already set.

Create a DAO proposal with the above actions. Once the proposal is passed and executed, the Silo will be ready for use.
