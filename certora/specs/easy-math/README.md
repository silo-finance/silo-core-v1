# Properties of EasyMath

## Types of Properties

- Math properties
- Risk assessment

### Math Properties

- Amount to shares conversion is monotonic.\
  Implementation: rule `MP_monotonicity_amount_toShares`

- Shares to amount conversion is monotonic.\
  Implementation: rule `MP_monotonicity_shares_toAmount`

- Inverse conversion for amount returns a value less or equal to the amount.\
  Implementation: rule `MP_inverse_amount`

- Inverse conversion for shares returns a value less or equal to the shares.\
  Implementation: rule `MP_inverse_shares`

### Risk assessment

- If the deposit was made when total deposits were equal to the total shares, after gaining any interest,\
  there should not be scenarios where the withdrawal amount will be less than the deposited amount.\
  Implementation: rule `RA_withdraw_with_interest`
