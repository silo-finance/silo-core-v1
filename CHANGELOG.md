# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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
