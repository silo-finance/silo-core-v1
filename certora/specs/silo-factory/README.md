# Properties of Silo Factory

## Types of Properties

- Variable Changes
- Unit Tests
- High-level properties

### Variable Changes

- siloRepository can only change on initRepository.\
  Implementation: rule `VC_SiloFactory_siloRepository_change`

### High-Level Properties

- siloRepository can be initialized once. The second attempt should revert.\
  Implementation: rule `HLP_SiloFactory_siloRepository_change`

### Unit Tests

- Only the siloRepository can create a silo. \
  Implementation: rule `UT_SiloRepository_createSilo_permissions`
