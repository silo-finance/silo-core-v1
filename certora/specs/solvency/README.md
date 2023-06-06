# Properties of Solvency

## Types of Properties

- Unit Tests

### Unit Tests

- ConvertAmountsToValues return zero <=> amount * price < DECIMAL_POINTS.\
  Implementation: rule `UT_convertAmountsToValues_zeroSanity`

- ConvertAmountsToValues returns array of the values, calculated as amount * price / DECIMAL_POINTS.\
  Implementation: rule `UT_convertAmountsToValues_concreteFormula`

- CalculateLiquidationFee returns liquidationFeeAmount == amount * liquidationFee / DECIMAL_POINTS and newProtocolEarnedFees == protocolEarnedFees + liquidationFeeAmount. newProtocolEarnedFees is set to type(uint256).max value in case of the overflow.\
  Implementation: rule `UT_calculateLiquidationFee`

- GetUserBorrowAmount returns user debt share balance to amount rounded up with compounded interest applied.\
  Implementation: rule `UT_getUserBorrowAmount`

- GetUserCollateralAmount returns user collateral share balance to amount with compounded interest applied. Protocol interest is excluded from compounded interest.\
  Implementation: rule `UT_getUserCollateralAmount`

- TotalBorrowAmountWithInterest returns totalBorrowAmount increased by compounded interest.\
  Implementation: rule `UT_totalBorrowAmountWithInterest`

- TotalDepositsWithInterest returns totalDeposits increased by compounded interest. Protocol interest is excluded from compounded interest.\
  Implementation: rule `UT_totalDepositsWithInterest`
