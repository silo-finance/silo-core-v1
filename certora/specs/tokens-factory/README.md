# Properties of Tokens Factory

## Types of Properties

- Variable Changes
- High-Level Properties
- Unit Tests
- Risk assessment

### Variable Changes

- _siloRepository can only change on initRepository.\
  Implementation: rule `VC_TokensFactory_siloRepository_change`

### High-Level Properties

- _siloRepository can be initialized once. The second attempt should revert.\
  Implementation: rule `HLP_TokensFactory_siloRepository_change`

### Unit Tests

- createShareCollateralToken should revert if msg.sender != silo address.\
  Implementation: rule `UT_TokensFactory_createShareCollateralToken_only_silo`

- createShareDebtToken should revert if msg.sender != silo address.\
  Implementation: rule `UT_TokensFactory_createShareDebtToken_only_silo`

### Risk assessment (worse case that can happen to the system)

- _siloRepository can't be set to zero address if it was not zero.\
  Implementation: rule `RA_TokensFactory_siloRepository_not_zero`

- Any silo should be able to create ShareCollateral and ShareDebt tokens.\
  Implementation: rule `RA_TokensFactory_any_silo_can_create_shares`
