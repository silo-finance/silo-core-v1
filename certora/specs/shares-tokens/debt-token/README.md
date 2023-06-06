# Properties of Shares debt token

## Types of Properties

- Variable Changes
- High-Level Properties

### Variable Changes

- receiveAllowances should change only on setReceiveApproval,
  decreaseReceiveAllowance, increaseReceiveAllowance, transferFrom.\
  Implementation: rule `VC_SharesDebt_receiveAllowances_change`

- receiveAllowances should increase only on setReceiveApproval, increaseReceiveAllowance.\
  Implementation: rule `VC_SharesDebt_receiveAllowances_increase`

- receiveAllowances should decrease only on setReceiveApproval, decreaseReceiveAllowance, transferFrom.\
  Implementation: rule `VC_SharesDebt_receiveAllowances_decrease`

### High-Level Properties

- Additive decreaseReceiveAllowance. receiveAllowances msg.sender after decreaseReceiveAllowance($amount$)
  should be the same as decreaseReceiveAllowance($amount/2$) + decreaseReceiveAllowance($amount/2$).\
  Implementation: rule `HLP_SharesDebt_additive_decreaseReceiveAllowance`

- Additive increaseReceiveAllowance. receiveAllowances msg.sender after increaseReceiveAllowance(amount)
  should be the same as increaseReceiveAllowance($amount/2$) + increaseReceiveAllowance($amount/2$).\
  Implementation: rule `HLP_SharesDebt_additive_increaseAllowance`

- Integrity of setReceiveApproval. receiveAllowances of msg.sender after setReceiveApproval($amount$)
  should be the exact amount that has been requested for a setReceiveApproval.\
  Implementation: rule `HLP_SharesDebt_integrity_setReceiveApproval`

- Integrity of decreaseReceiveAllowance. receiveAllowances of msg.sender after decreaseReceiveAllowance($amount$)
  should be equal to the receiveAllowances of the sender before request - $amount$.\
  Implementation: rule `HLP_SharesDebt_integrity_decreaseReceiveAllowance`

- Integrity of increaseReceiveAllowance. receiveAllowances of msg.sender after increaseReceiveAllowance($amount$)
  should be equal to the receiveAllowances of the sender before request + $amount$ or $uint256.max$.\
  Implementation: rule `HLP_SharesDebt_integrity_increaseReceiveAllowance`
