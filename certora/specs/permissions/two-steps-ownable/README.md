# Properties of TwoStepOwnable

## Types of Properties

- Variable Changes
- Valid States
- Unit Tests

### Variable Changes

- Only renounceOwnership can set an owner.\
  Implementation: rule `VC_owner_to_0`

- Only transferOwnership, renounceOwnership and acceptOwnership can update an owner. \
  Implementation: rule `VC_owner_update`

- Only acceptOwnership, renounceOwnership, transferOwnership, removePendingOwnership \
  can set a pending owner to an empty address. \
  Implementation: rule `VC_pending_owner_to_0`

- Only transferPendingOwnership can set a pending owner. \
  Implementation: rule `VC_pending_owner_config`

### Valid States

- If an owner is an empty address, a pending owner should also be an empty address. \
  Implementation: rule `VS_empty_state`

- If the owner is updated, a pending owner should be an empty address. \
  Implementation: rule `VS_owner_update`

### Unit Tests

- Only the owner can execute renounceOwnership. \
  Implementation: rule `VS_renounceOwnership_only_owner`

- Only the owner can execute transferOwnership. \
  Implementation: rule `VS_transferOwnership_only_owner`

- Only the owner can execute transferPendingOwnership. \
  Implementation: rule `VS_transferPendingOwnership_only_owner`

- Only the owner can execute removePendingOwnership. \
  Implementation: rule `VS_removePendingOwnership_only_owner`

- Only the pending owner can execute acceptOwnership. \
  Implementation: rule `VS_acceptOwnership_only_pending_owner`
