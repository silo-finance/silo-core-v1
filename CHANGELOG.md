# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

## [1.51.0] - 2023-05-16
- SIP-75: Burn XAI credit line in RAI silo

## [1.50.0] - 2023-05-10
- SIP-72: Setup for wstETH and OHMv2 on Arbitrum
- SIP-73: Fix Setup for wstETH and OHM on Arbitrum
- SIP-74: Setup for PEPE, XDEFI, boxETH, BLUR on Mainnet

## [1.49.0] - 2023-05-09
- SIP-70 Update XAI config for USDC

## [1.48.0] - 2023-05-09
- Update XAI config

## [1.47.1] - 2023-04-28
### Changed
- merging two IRM models into one
- optimizing model behavior
- gas optimizations

## [1.47.0] - 2023-04-25
### Added
- SIP-53: Change rDPX oracle to DIA (Arbitrum)

## [1.46.0] - 2023-04-12
### Added
- SIP-52: Setup for WBTC and VELA on Arbitrum

## [1.45.0] - 2023-04-11
### Added
- DIA oracle
- SIP-50: Setup for JONES and SPA on Arbitrum
- SIP-51: proposal to change XAI price to USDC

## [1.44.1] - 2023-04-04
### Fixed
- fix changelog

## [1.44.0] - 2023-04-04
### Added
- SIP-48 ARB launch
- SIP-49 update ARB setup

## [1.43.0] - 2023-03-19
### Added
- SIP-47: launching PREMIA

## [1.42.0] - 2023-03-11
### Added
- SIP-46: Transfer admin functions to core team (emergency proposal)

## [1.41.0] - 2023-03-08
### Added
- SIP-45: Migrate rETH to Chainlink price oracle

## [1.40.2] - 2023-03-06
### Changed
- exclude `PREMIA` from SIP-44 and put it in separate SIP

## [1.40.1] - 2023-02-28
### Changed
- new address of `ethEmergencyMultisig`

### Fixed 
- fix vested dates for 8 new vesters

## [1.40.0] - 2023-02-27
### Added
- SIP-44: Setup for 3 assets on Arbitrum
- 8 new vesters contracts

## [1.39.0] - 2023-02-23
### Added
- SIP-42: Mint/Burn XAI (February)
- SIP-43: Set protocol fees to 25% (Arbitrum)

## [1.38.0] - 2023-02-23
### Added
- `SiloIncentivesController` - reward distributor
- SIP-41: Setup rewards notifications for Silos

## [1.37.1] - 2023-02-16
### Fixed
- fix silo unit tests

## [1.37.0] - 2023-02-10
### Added
- view method to calculate used deposits with interests
- `ManualLiquidation` contract

## [1.36.0] - 2023-02-07
### Added
- Arbitrum production
  - SIP-39 Initial Setup For Arbitrum
  - SIP-40 Phase 1: Assets Setup For Arbitrum

### Updated
- `LiquidationHelper`

## [1.35.0] - 2023-02-02
### Added
- SIP-37: Proposal to set protocol fees to 10%
- SIP-38: Claim DAO's vested SILO

## [1.34.0] - 2023-02-02
### Added
- option to force liquidation even when it might be not profitable

## [1.33.0] - 2023-01-27
### Added
- SIP-35: Disable sETH2, FTT and xSushi Silos
- SIP-36: Mint XAI to silos

## [1.32.0] - 2023-01-25
### Added
- SIP-34: Change IRM config for WETH in all silos

## [1.31.0] - 2023-01-24
### Added
- SIP-33: 
  - `rETH` and `agEUR` Silos
  - Update IRM for `OHM` asset

## [1.30.0] - 2023-01-18
### Changed
- SIP-32: Setup fallback providers for `DAI` and `USDP`

## [1.29.1] - 2023-01-12
### Fixed
- support non-standard `ERC20.approve` in `LiquidationHelper` eg for `USDT`

## [1.29.0] - 2023-01-10
### Updated
- cbETH aggregator in the `ChainlinkV3PriceProvider`.

## [1.28.0] - 2022-12-30
### Added
- `0x` support for `LiquidationHelper`
- `XAICurveMagicianETH`

### Changed
- Send all earnings from liquidation process to executor, not to LiquidationHelper.owner()

## [1.27.1] - 2022-12-22
### Fixed
- changed OHM pool in `GOHMMagician` to Balancer OHM-ETH.

## [1.27.0] - 2022-12-12
### Added
- add `OHMMagician` to support `OHM` liquidation

## [1.26.0] - 2022-12-09
### Added
- `GOHMMagician` gOHM magician to support liquidation

## [1.25.0] - 2022-12-09
### Added
- `WSTETHMagician` wstETH magician to support liquidation
- `STETHMagician` stETH magician to support liquidation

### Updated
- `LiquidationHelper` to support `magicians` for assets liquidation

### Fixed
- fix gas calculation in `LiquidationHelper`, ensure it is closer to reality

## [1.24.0] - 2022-12-01
### Added
- Control `Tower` for keeping track of some contract addresses

## [1.23.1] - 2022-11-29
### Fixed
- fix changelog for `1.23.0`

## [1.23.0] - 2022-11-23
### Added
- SIP-30: Update interest rate models and price providers for existing Silos
### Updated
- improve `testLiquidation` task

## [1.22.0] - 2022-11-15
### Added
- SIP-29: cancel SIP-24, GOHMPriceProvider and gOHM Silo proposals

## [1.21.0] - 2022-11-15
### Added
- Support `IndividualPriceProvider` in `GOHMPriceProvider`

## [1.20.0] - 2022-11-11
### Added
- SIP-28: 3 new markets

## [1.19.0] - 2022-11-09
### Added
- SIP-27: WSTETHPriceProvider
- `testLiquidation` task for testing liquidation process for any asset

## [1.18.0] - 2022-11-08
### Added
- WSTETHPriceProvider created and deployed

## [1.17.1] - 2022-11-05
### Fixed
- Support two `ChainlinkPriceProviders` in `LiquidationHelper`

## [1.17.0] - 2022-11-04
### Added
- SIP-26: 7 new markets

## [1.16.0] - 2022-11-02
### Changed
- SIP 25: Setup Chainlink price provider, Uniswap fallback pool for cbETH

## [1.15.0] - 2022-11-02
### Changed
- SIP 24: GOHMPriceProvider and gOHM Silo

## [1.14.0] - 2022-11-02
### Changed
- SIP 23: XAI Fallback

## [1.13.0] - 2022-11-01
### Added
- `UniswapV3PriceProviderXAI`

## [1.12.0] - 2022-11-01
### Added
- gOHM Silo deployments

## [1.11.0] - 2022-11-01
### Added
- proposals for 47 markets

## [1.10.0] - 2022-10-26
### Added
- `GOHMPriceProvider`

## [1.9.0] - 2022-10-24
### Added
- `ChainlinkV3ReverseAggregator`
- SIP-19: new XAI market / XAI minting and configuration for existing assets

## [1.8.4] - 2022-10-20
### Updated
- `ChainlinkV3PriceProvider`

## [1.8.3] - 2022-10-17
### Changed
- New proposal flow
- Use `ethers.Wallet` to send proposals (EIP-1559)

### Fixed
- SIP-18: unregister old and register new `ChainlinkV3PriceProvider`

## [1.8.2] - 2022-10-10
### Changed
- Expose `getAggregatorPrice` method and make all methods `virtual` in `ChainlinkV3PriceProvider`.

## [1.8.1] - 2022-10-07
### Added
- New `InterestRateModelXAI` model

## [1.8.0] - 2022-10-04
## Added
- Add proposal for registering new Uniswap and Chainlink providers (SIP-17)

## [1.7.1] - 2022-09-29
### Fixed
- fixed issue with hubflow, adding tag that will include missing deployments

## [1.7.0] - 2022-09-28
### Added
- Add ChainlinkV3 provider support in liquidation helper
- Add missing functionality to ChainlinkV3 provider
- Chainlink provider formal verification

## [1.6.0] - 2022-09-20
### Added
- Add UniswapV3 provider V2 with support for non-eth prices
- Add UniswapV3SwapV2 related to UniswapV3 V2
- Add polygon as staging environment

## [1.5.0] - 2022-09-14
### Added
- add `depositAPY` to `InterestRateDataResolver`

### Fixed
- fix issue with redeployment of `PRBMathCommon` and `PRBMathSD59x18`  
  (deployment was done, and then license was changed and artifacts were modified manually)
- fix issue with redeployment of `UniswapV3PriceProvider`
  (package `@uniswap/v3-core/contracts/libraries/FullMath.sol` was updated)

## [1.4.0] - 2022-09-09
### Added
- cbETH Silo

## [1.3.2] - 2022-08-18
### Removed
- remove rinkeby support

## [1.3.1] - 2022-08-16
### Added
- testnets deployments
- code verification (and silo verification task) 

### Removed
- remove kovan support

## [1.3.0] - 2022-08-09
### Added
- mainnet deployments

### Changed
- when setting up model config, call `silo.accrueInterest` before new config is saved
- fix non-checksum address comparison in deployment scripts
- license update for PRBMathSD59x18 and PRBMathCommon

## [1.2.4] - 2022-07-28
### Changed
- betaConfig with receipts

## [1.2.3] - 2022-07-21
### Added
- testnets deployments

### Changed
- license

### Fixed
- detection of issues with `SiloRepository` deployments

## [1.2.2] - 2022-07-20
### Changed
- handle UniswapV3 `OLD` error on `getPrice`
- beta deployments with fixed configuration

## [1.2.1] - 2022-07-11
### Added
- certora
- `nonReentrant` for `initAssetsTokens` and `syncBridgeAssets`

## [1.2.0] - 2022-07-07
### Added
- add `manager` to `GuardedLaunch`
- beta deployments scripts + initial configuration

### Changed
- return timestamp with Silo assets data in `InterestRateDataResolver`

## [1.1.4] - 2022-07-07
### Fix
- sync share token state and Silo state on repay, when burning tokens

## [1.1.3] - 2022-07-06
### Changed
- added `calculateCompoundInterestRateWithOverflowDetection`, `overflowDetected` methods to InterestRateModel
- added overflow check in InterestRateModel and rcomp restriction to not cause `_accrueInterest` to revert in BaseSilo

## [1.1.2] - 2022-07-05
### Changed
- Round in favor of the protocol (introduced `EasyMath.toShareRoundUp` and `EasyMath.toAmountRoundUp`)

## [1.1.1] - 2022-06-22
### Changed
- `toShare` and `toAmount` revert if the result is `0` and amount is not `0`
- Support specifying `type(uint256).max` for repaying through the router

## [1.1.0] - 2022-06-15
### Added
- add `UniswapV3PriceProvider.quotePrice` method that allows to check the quote price

### Changed
- make `siloRepository` public on `TokensFactory` and `SiloFactory` and add `InitSiloRepository` event

## [1.0.2] - 2022-06-09
### Fixed
- fixed usage of the `liquidity` function inside the `_withdrawAsset` function

## [1.0.1] - 2022-06-06
### Changed
- outdated reentracy comment

## [1.0.0] - 2022-06-06
### Added
- minimal operational share amount
- improvements, fixes based on audit from ABDK and Quantstamp
- a lot of "nice to haves"

## [0.5.3] - 2022-05-11
### Changed
- improvements, fixes based on internal audit

## [0.5.2] - 2022-05-02
### Added
- added `SiloLens.hasPosition(silo, user)`

### Fixed
- make `depositAPY` return `0` when no deposit.

## [0.5.1] - 2022-03-29
### Added
- testnets deployments

## [0.5.0] - 2022-03-29
### Added
- contract verification `ping-pong`

### Changed
- Oracle pools can be added manually only by manager
- rename `Oracle` => `'PriceProvider`

### Removed
- automatic oracle detection removed
- remove signature check for off-chain verification for new silo

## [0.4.2] - 2022-01-25
### Changed
- license

## [0.4.1] - 2022-01-24
### Changed
- license

## [0.4.0] - 2022-01-20 (audit release)
### Added
- generated tests for interest rate model
- flash liquidation (TODO: splitting rewards)
- Silo Factory
- Tokens Factory
- add support to transfer collateral (deposit) and debt (new token standard ERC20R)
- signature check for off-chain verification for new silo
- expose methods for off-chain verifications
- liquidation helper contract
- Support multiple Silo versions
- Dynamic Interest Rate Model

### Changed
- combine Silo and Bridge
- multiple bridge assets
- increased decimal points for variables and calculations basis points
- better support for TWAP prices for UniswapV3 and BalancerV2: check if pool is ready for TWAP calculations
- collateral only Silo deposits
- `repayFor` will be possible to execute by anyone but only for not solvent borrowers

### Removed
- remove cloning (it is more efficient to pay more for creation and less for usage)
- remove standard liquidation
- removed cloning for share tokens

## [0.3.0] - 2021-12-14
### Added
- Wrapper for SILO token contract to allow voting with unvested tokens in snapshot off-chain votings

## [0.2.0] - 2021-11-30
### Added
- Silo Governance Token
- Silo Governor based on OZ Governor
- Treasury Vester contract forked from Uniswap

## [0.1.0-alpha] - 2021-11-16
### Added
- linters, CI workflows
- BalancerV2 as oracle
  - with method for FE to filter pools for asset
- Aragon DAO script to create voting for new Silo

### Changed
- oracles workflow:
  - separate oracles and made them work in more automatic way
  - common event for any asset operation in oracles
- update UniswapV3 to follow new oracle patterns
- interest rate calculation based on intervals (virtual balances)
- made `getPrice` a view
- split `lastUpdateTimestamp` into timestamps for balance and interest rates
- split InterestModel into VirtualBalances and Model
- unify naming, remove `liquidity` and `debt`, use `deposit` and `borrowAmount`

### Fixed
- oracle initialization when new Silo is created

### Removed
- Chainlink and UniswapV2 oracles

## [0.0.0] - 2021-10-18
### Added
- initial version of Silo protocol
- initial versions of oracles (Chainlink, UniswapV2, UniswapV3)
