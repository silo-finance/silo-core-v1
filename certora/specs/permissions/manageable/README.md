# Properties of Manageable

## Types of Properties

- Variable Changes
- Valid States
- Unit Tests

### Variable Changes

- Only changeManager can set a manager.\
  Implementation: rule `VC_manager_change`

### Valid States

- A manager can't be an empty address. \
  Implementation: rule `VS_manager_is_not_0`

### Unit Tests

- Only the owner or the manager can execute changeManager. \
  Implementation: rule `VS_changeManager_only_owner_or_manager`
