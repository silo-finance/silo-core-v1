# Properties of Shares tokens

## Types of Properties

- Valid States
- State Transitions
- Variable Changes
- High-Level Properties
- Unit Tests
- Risk assessment

### Variable Changes

- TotalSupply can only change on mint, burn.\
  Implementation: rule `VC_Shares_totalSupply_change`

- TotalSupply can increase only on mint.\
  Implementation: rule `VC_Shares_totalSupply_increase`

- TotalSupply can decrease only on burn.\
  Implementation: rule `VC_Shares_totalSupply_decrease`

- For any address, the balance can change only on mint, burn, transfer, transferFrom.\
  Implementation: rule `VC_Shares_balance_change`

- For any address, the balance can increase only on mint, transfer, transferFrom.\
  Implementation: rule `VC_Shares_balance_increase`

- For any address, the balance can decrease only on burn, transfer, transferFrom.\
  Implementation: rule `VC_Shares_balance_decrease`

- Allowance can only change on transferFrom, approve, increaseAllowance, decreaseAllowance.\
  Implementation: rule `VC_Shares_allowance_change`

### Valid States

- Sum of all balances should be equal totalSupply.\
  Implementation: invariant `VS_Shares_totalSupply_balances`

### High-Level Properties

- transferFrom should decrease allowance for the same amount as transferred.\
  Implementation: rule `HLP_Shares_transferFrom_allowance`

- Additive transfer. Balance change for msg.sender and recipient while do transfer($amount$)
  should be the same as transfer($amount/2$) + transfer($amount/2$).\
  Implementation: rule `HLP_Shares_additive_transfer`

- Additive transferFrom. Balance change for sender and recipient while do transferFrom($amount$)
  should be the same as transferFrom($amount/2$) + transferFrom($amount/2$).\
  Implementation: rule `HLP_Shares_additive_transferFrom`

- Additive mint. Balance change for recipient while do mint($amount$)
  should be the same as mint($amount/2$) + mint($amount/2$).\
  Implementation: rule `HLP_Shares_additive_mint`

- Additive burn. Balance change for recipient while do burn($amount$)
  should be the same as burn($amount/2$) + burn($amount/2$).\
  Implementation: rule `HLP_Shares_additive_burn`

- Additive increaseAllowance. Allowance change for spender while do increaseAllowance($amount$)
  should be the same as increaseAllowance($amount/2$) + increaseAllowance($amount/2$).\
  Implementation: rule `HLP_Shares_additive_increaseAllowance`

- Additive decreaseAllowance. Allowance change for spender while do decreaseAllowance($amount$)
  should be the same as decreaseAllowance($amount/2$) + decreaseAllowance($amount/2$).\
  Implementation: rule `HLP_Shares_additive_decreaseAllowance`

- Integrity of mint. Balance of recipient after mint($amount$)
  should be equal to the balance of the recipient before mint + $amount$.\
  Implementation: rule `HLP_Shares_integrity_mint`

- Integrity of burn. Balance of recipient after burn($amount$)
  should be equal to the balance of the recipient before burn - $amount$.\
  Implementation: rule `HLP_Shares_integrity_burn`

- Integrity of transfer. Balance of recipient and msg.sender after transfer($amount$)
  should be updated for the exact amount that has been requested for a transfer.\
  Implementation: rule `HLP_Shares_integrity_transfer`

- Integrity of transferFrom. Balance of recipient and sender after transferFrom($amount$)
  should be updated for the exact amount that has been requested for a transferFrom.\
  Implementation: rule `HLP_Shares_integrity_transferFrom`

- Integrity of increaseAllowance. Allowance of spender after increaseAllowance($amount$)
  should be equal to the allowance of the spender before increaseAllowance + $amount$.\
  Implementation: rule `HLP_Shares_integrity_increaseAllowance`

- Integrity of decreaseAllowance. Allowance of spender after decreaseAllowance($amount$)
  should be equal to the allowance of the spender before decreaseAllowance - $amount$.\
  Implementation: rule `HLP_Shares_integrity_decreaseAllowance`

- Integrity of approve. Allowance of spender after approve($amount$)
  should be equal to the allowance of the spender before approve + $amount$.\
  Implementation: rule `HLP_Shares_integrity_approve`

### Unit tests

- Mint and Burn should revert if the sender is not the silo address.\
  Implementation: rule `UT_Shares_min_burn_permissions`

### Risk assessment

- Each action affects at most two user's balance.\
  Implementation: rule `RA_Shares_balances_update_correctness`
