# Properties of Silo

## Types of Properties

- Valid States
- State Transitions
- Variable Changes
- High-Level Properties
- Unit Tests
- Risk assessment

### Variable Changes

- AssetStorage.totalDeposits can only change on deposit, depositFor, withdraw,
  withdrawFor, flashLiquidate, repay, repayFor, borrow, borrowFor, accrueInterest.\
  Implementation: rule `VC_Silo_totalDeposits`

- AssetStorage.totalDeposits without _accrueInterest can only change on deposit, depositFor,
  withdraw, withdrawFor, flashLiquidate.\
  Implementation: rule `VC_Silo_totalDeposits_without_interest`

- AssetStorage.collateralOnlyDeposits can only change on deposit, depositFor, withdraw,
  withdrawFor, flashLiquidate.\
  Implementation: rule `VC_Silo_collateralOnlyDeposits`

- AssetStorage.totalBorrowAmount can only change on deposit, depositFor, withdraw,
  withdrawFor, flashLiquidate, repay, repayFor, borrow, borrowFor, accrueInterest.\
  Implementation: rule `VC_Silo_totalBorrowAmount`

- AssetStorage.totalBorrowAmount without _accrueInterest can only change on deposit, depositFor,
  withdraw, withdrawFor.\
  Implementation: rule `VC_Silo_totalBorrowAmount_without_interest`

- AssetInterestData.harvestedProtocolFees can only change on harvestProtocolFees.\
  Implementation: rule `VC_Silo_harvestedProtocolFees`

- AssetInterestData.protocolFees can only change on deposit, depositFor, withdraw,
  withdrawFor, flashLiquidate, repay, repayFor, borrow, borrowFor, accrueInterest.\
  Implementation: rule `VC_Silo_protocolFees`

- AssetInterestData.protocolFees without _accrueInterest can only change on borrow, borrowFor.\
  Implementation: rule `VC_Silo_protocolFees_without_interest`

- AssetInterestData.interestRateTimestamp can only change on deposit, depositFor, withdraw,
  withdrawFor, flashLiquidate, repay, repayFor, borrow, borrowFor, accrueInterest.\
  Implementation: rule `VC_Silo_interestRateTimestamp`

- AssetInterestData.interestRateTimestamp should not change in the same block.\
  Implementation: rule `VC_Silo_interestRateTimestamp_in_the_same_block`

- AssetInterestData.status can only change on initAssetsTokens, syncBridgeAssets.\
  Implementation: rule `VC_Silo_asset_status`

- AssetStorage.collateralToken and AssetStorage.collateralOnlyToken and
  AssetStorage.debtToken can only change on initAssetsTokens, syncBridgeAssets.\
  Implementation: rule `VC_Silo_shares_tokens_change`

- CollateralToken.totalSupply can only change on deposit, depositFor,
  withdraw, withdrawFor, flashLiquidate.\
  Implementation: rule `VC_Silo_collateral_totalSupply_change`

- CollateralOnlyToken.totalSupply can only change on deposit, depositFor,
  withdraw, withdrawFor if _collateralOnly is true and on flashLiquidate.\
  Implementation: rule `VC_Silo_collateralOnly_totalSupply_change`

- DebtToken.totalSupply can only change on borrow, borrowFor, repay, repayFor.\
  Implementation: rule `VC_Silo_debt_totalSupply_change`

- CollateralToken.totalSupply and AssetStorage.totalDeposits should increase only
  on deposit, depositFor.\
  Implementation: rule `VC_Silo_collateral_totalDeposits_increase`

- CollateralOnlyToken.totalSupply and AssetStorage.collateralOnlyDeposits should
  increase only on deposit, depositFor if _collateralOnly is true.\
  Implementation: rule `VC_Silo_collateralOnly_collateralOnlyDeposits_increase`

- CollateralToken.totalSupply and AssetStorage.totalDeposits should decrease only
  on withdraw, withdrawFor, flashLiquidate.\
  Implementation: rule `VC_Silo_collateral_totalDeposits_decrease`

- CollateralOnlyToken.totalSupply and AssetStorage.collateralOnlyDeposits should
  decrease only on withdraw, withdrawFor if _collateralOnly is true and on flashLiquidate.\
  Implementation: rule `VC_Silo_collateralOnly_collateralOnlyDeposits_decrease`

- DebtToken.totalSupply and AssetStorage.totalBorrowAmount should increase only
  on borrow, borrowFor.\
  Implementation: rule `VC_Silo_debt_totalBorrow_increase`

- DebtToken.totalSupply and AssetStorage.totalBorrowAmount should decrease only
  on repay, repayFor.\
  Implementation: rule `VC_Silo_debt_totalBorrow_decrease`

- AssetInterestData.interestRateTimestamp should only increase.\
  Implementation: rule `VC_Silo_interestRateTimestamp_increase`

- The silo balance for a particular asset should only increase on deposit, depositFor, \
  repay, repayFor. \
  The silo balance for a particular asset should only decrease on withdraw, withdrawFor, \
  borrow, borrowFor, flashLiquidate, harvestProtocolFees. \
  Implementation: rule `VC_Silo_balance`

### Valid States

- TotalDeposits is zero <=> collateralToken.totalSupply is zero.\
  Implementation: rule `VS_Silo_totalDeposits_totalSupply`

- CollateralOnlyDeposits is zero <=> collateralOnlyToken.totalSupply is zero.\
  Implementation: rule `VS_Silo_collateralOnlyDeposits_totalSupply`

- TotalBorrowAmount is zero <=> debtToken.totalSupply is zero.\
  Implementation: rule `VS_Silo_totalBorrowAmount_totalSupply`

- AssetInterestData.lastTimestamp is zero => AssetInterestData.protocolFees is zero.\
  Implementation: rule `VS_Silo_lastTimestamp_protocolFees`

- AssetInterestData.protocolFees increased => AssetInterestData.lastTimestamp and
  AssetStorage.totalDeposits are increased too.\
  Implementation: rule `VS_Silo_protocolFees`

- AssetInterestData.totalBorrowAmount is not zero => AssetStorage.totalDeposits is not  zero.\
  Implementation: rule `VS_Silo_totalBorrowAmount`

- AssetInterestData.protocolFees is zero => AssetInterestData.harvestedProtocolFees is zero.\
  Implementation: rule `VS_Silo_lastTimestamp_protocolFees_zero`

- AssetInterestData.status is active => AssetStorage.collateralToken is not empty and
  AssetStorage.collateralOnlyToken is not empty and AssetStorage.debtToken is not empty
  and allSiloAssets.length > 0.\
  Implementation: rule `VS_Silo_active_asset`

### State Transitions

- CollateralToken.totalSupply is changed => totalDeposits is changed.\
  Implementation: rule `ST_Silo_totalSupply_totalDeposits`

- CollateralOnlyToken.totalSupply is changed => collateralOnlyDeposits is changed.\
  Implementation: rule `ST_Silo_totalSupply_collateralOnlyDeposits`

- DebtToken.totalSupply is changed => totalBorrowAmount is changed.\
  Implementation: rule `ST_Silo_totalSupply_totalBorrowAmount`

- AssetInterestData.interestRateTimestamp is changed and it was not 0
  and AssetInterestData.totalBorrowAmount was not 0 =>
  AssetInterestData.totalBorrowAmount is changed.\
  Implementation: rule `ST_Silo_interestRateTimestamp_totalBorrowAmount_dependency`

- AssetInterestData.interestRateTimestamp is changed and it was not 0
  and siloRepository.protocolShareFee() was not 0 =>
  AssetInterestData.totalDeposits and AssetInterestData.protocolFees also changed.\
  Implementation: rule `ST_Silo_interestRateTimestamp_fee_dependency`

- CollateralToken.totalSupply or collateralOnlyToken.totalSupply increased
  => deposit amount is not zero and asset is active.\
  Implementation: rule `ST_Silo_mint_shares`

- DebtToken.totalSupply increased => borrow amount is not zero and asset is active.\
  Implementation: rule `ST_Silo_mint_debt`

- AssetInterestData.status is changed to active and AssetStorage.collateralToken
  and AssetStorage.collateralOnlyToken and AssetStorage.debtToken where empty =>
  AssetStorage.collateralToken and AssetStorage.collateralOnlyToken and AssetStorage.debtToken
  should not be empty and different.\
  Implementation: rule `ST_Silo_asset_init_shares_tokes`

- AssetInterestData.status is changed to active and AssetStorage.collateralToken
  and AssetStorage.collateralOnlyToken and AssetStorage.debtToken where not empty =>
  AssetStorage.collateralToken and AssetStorage.collateralOnlyToken and AssetStorage.debtToken
  should not update.
  Implementation: rule `ST_Silo_asset_reactivate`

### High-Level Properties

- Inverse deposit - withdraw for collateralToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_deposit_withdraw_collateral`

- Inverse deposit - withdrawFor for collateralToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_deposit_withdrawFor_collateral`

- Inverse depositFor - withdraw for collateralToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_depositFor_withdraw_collateral`

- Inverse depositFor - withdrawFor for collateralToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_depositFor_withdrawFor_collateral`

- Inverse deposit - withdraw for collateralOnlyToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_deposit_withdraw_collateralOnly`

- Inverse deposit - withdrawFor for collateralOnlyToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_deposit_withdrawFor_collateralOnly`

- Inverse depositFor - withdraw for collateralOnlyToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_depositFor_withdraw_collateralOnly`

- Inverse depositFor - withdrawFor for collateralOnlyToken. For any user, the balance before deposit
  should be equal to the balance after depositing and then withdrawing the same amount.\
  Implementation: rule `HLP_inverse_depositFor_withdrawFor_collateralOnly`

- Inverse borrow - repay for debtToken. For any user, the balance before borrowing should be equal
  to the balance after borrowing and then repaying the same amount.\
  Implementation: rule `HLP_inverse_borrow_repay_debtToken`

- Inverse borrow - repayFor for debtToken. For any user, the balance before borrowing should
  be equal to the balance after borrowing and then repaying the same amount.\
  Implementation: rule `HLP_inverse_borrow_repayFor_debtToken`

- Inverse borrowFor - repay for debtToken. For any user, the balance before borrowing should
  be equal to the balance after borrowing and then repaying the same amount.\
  Implementation: rule `HLP_inverse_borrowFor_repay_debtToken`

- Inverse borrowFor - repayFor for debtToken. For any user, the balance before borrowing should
  be equal to the balance after borrowing and then repaying the same amount.\
  Implementation: rule `HLP_inverse_borrowFor_repayFor_debtToken`

- Additive deposit for collateralToken, totalDeposits while do deposit(x + y)
  should be the same as deposit(x) + deposit(y).\
  Implementation: rule `HLP_additive_deposit_collateral`

- Additive deposit for collateralOnlyToken, collateralOnlyDeposits while do deposit(x + y)
  should be the same as deposit(x) + deposit(y).\
  Implementation: rule `HLP_additive_deposit_collateralOnly`

- Additive depositFor for collateralToken, totalDeposits while
  do depositFor(x + y) should be the same as depositFor(x) + depositFor(y).\
  Implementation: rule `HLP_additive_depositFor_collateral`

- Additive depositFor for collateralOnlyToken, collateralOnlyDeposits while
  do depositFor(x + y) should be the same as depositFor(x) + depositFor(y).\
  Implementation: rule `HLP_additive_depositFor_collateralOnly`

- Additive withdraw for collateralToken, totalDeposits while
  do withdraw(x + y) should be the same as withdraw(x) + withdraw(y).\
  Implementation: rule `HLP_additive_withdraw_collateral`

- Additive withdraw for collateralOnlyToken, collateralOnlyDeposits while
  do withdraw(x + y) should be the same as withdraw(x) + withdraw(y).\
  Implementation: rule `HLP_additive_withdraw_collateralOnly`

- Additive withdrawFor for collateralToken, totalDeposits while
  do withdrawFor(x + y) should be the same as withdrawFor(x) + withdrawFor(y).\
  Implementation: rule `HLP_additive_withdrawFor_collateral`

- Additive withdrawFor for collateralOnlyToken, collateralOnlyDeposits while
  do withdrawFor(x + y) should be the same as withdrawFor(x) + withdrawFor(y).\
  Implementation: rule `HLP_additive_withdrawFor_collateralOnly`

- Additive borrow for debtToken, totalBorrowAmount while do borrow(x + y)
  should be the same as borrow(x) + borrow(y).\
  Implementation: rule `HLP_additive_borrow_debtToken`

- Additive borrowFor for debtToken, totalBorrowAmount while do borrowFor(x + y)
  should be the same as borrowFor(x) + borrowFor(y).\
  Implementation: rule `HLP_additive_borrowFor_debtToken`

- Additive repay for debtToken, totalBorrowAmount while do repay(x + y)
  should be the same as repay(x) + repay(y).\
  Implementation: rule `HLP_additive_repay_debtToken`

- Additive repayFor for debtToken, totalBorrowAmount while do repayFor(x + y)
  should be the same as repayFor(x) + repayFor(y).\
  Implementation: rule `HLP_additive_repayFor_debtToken`

- Integrity of deposit for collateralToken, totalDeposits after deposit
  should be equal to the totalDeposits before deposit + amount of the deposit.\
  Implementation: rule `HLP_integrity_deposit_collateral`

- Integrity of deposit for collateralTokenOnly, collateralOnlyDeposits after deposit
  should be equal to the collateralOnlyDeposits before deposit + amount of the deposit.\
  Implementation: rule `HLP_integrity_deposit_collateralOnly`

- Integrity of depositFor for collateralToken, totalDeposits after deposit
  should be equal to the totalDeposits before deposit + amount of the deposit.\
  Implementation: rule `HLP_integrity_depositFor_collateral`

- Integrity of depositFor for collateralOnlyToken, collateralOnlyDeposits after deposit
  should be equal to the collateralOnlyDeposits before deposit + amount of the deposit.\
  Implementation: rule `HLP_integrity_depositFor_collateralOnly`

- Integrity of withdraw for collateralToken, totalDeposits after withdrawal
  should be equal to the totalDeposits before withdrawal - the amount of the withdrawal.\
  Implementation: rule `HLP_integrity_withdraw_collateral`

- Integrity of withdraw for collateralOnlyToken, collateralOnlyDeposits after withdrawal
  should be equal to the collateralOnlyDeposits before withdrawal - the amount of the withdrawal.\
  Implementation: rule `HLP_integrity_withdraw_collateralOnly`

- Integrity of withdrawFor for collateralToken, totalDeposits withdrawal
  should be equal to the totalDeposits before withdrawal - the amount of the withdrawal.\
  Implementation: rule `HLP_integrity_withdrawFor_collateral`

- Integrity of withdrawFor for collateralOnlyToken, collateralOnlyDeposits after withdrawal
  should be equal to the collateralOnlyDeposits before withdrawal - the amount of the withdrawal.\
  Implementation: rule `HLP_integrity_withdrawFor_collateralOnly`

- Integrity of borrow for debtToken, totalBorrowAmount after borrow
  should be equal to the totalBorrowAmount before borrow + borrowed amount.\
  Implementation: rule `HLP_integrity_borrow_debtToken`

- Integrity of borrowFor for debtToken, totalBorrowAmount after borrowFor
  should be equal to the totalBorrowAmount before borrowFor + borrowed amount.\
  Implementation: rule `HLP_integrity_borrowFor_debtToken`

- Integrity of repay for debtToken, totalBorrowAmount after repay
  should be equal to the totalBorrowAmount before repay + repaid amount.\
  Implementation: rule `HLP_integrity_repay_debtToken`

- Integrity of repayFor for debtToken, totalBorrowAmount after repayFor
  should be equal to the totalBorrowAmount before repayFor + repaid amount.\
  Implementation: rule `HLP_integrity_repayFor_debtToken`

- Deposit of the collateral will only update the balance of msg.sender.\
  Implementation: rule `HLP_deposit_collateral_update_only_sender`

- Deposit of the collateralOnly will only update the balance of msg.sender.\
  Implementation: rule `HLP_deposit_collateralOnly_update_only_sender`

- DepositFor of the collateral will only update the balance of _depositor.\
  Implementation: rule `HLP_depositFor_collateral_update_only_depositor`

- DepositFor of the collateralOnly will only update the balance of _depositor.\
  Implementation: rule `HLP_depositFor_collateralOnly_update_only_depositor`

- Withdrawing of the collateral will only update the balance of msg.sender.\
  Implementation: rule `HLP_withdraw_collateral_update_only_sender`

- Withdrawing of the collateralOnly will only update the balance of msg.sender.\
  Implementation: rule `HLP_withdraw_collateralOnly_update_only_sender`

- WithdrawFor of the collateral will only update the balance of _depositor.\
  Implementation: rule `HLP_withdrawFor_collateral_update_only_depositor`

- WithdrawFor of the collateralOnly will only update the balance of _depositor.\
  Implementation: rule `HLP_withdrawFor_collateralOnly_update_only_depositor`

- Borrow will only update the balance of the msg.sender for debtToken.\
  Implementation: rule `HLP_borrow_update_only_sender`

- BorrowFor will only update the balance of the borrower for debtToken.\
  Implementation: rule `HLP_borrowFor_update_only_borrower`

- Repay will only update the balance of the msg.sender for debtToken.\
  Implementation: rule `HLP_repay_update_only_sender`

- RepayFor will only update the balance of the borrower for debtToken.\
  Implementation: rule `HLP_repayFor_update_only_borrower`

- FlashLiquidate will only update the balances of the provided users.
  isSolventBefore == false => Balance for CollateralOnlyToken, CollateralToken should be 0.\
  Implementation: rule `HLP_flashliquidate_shares_tokens_bal_zero`

### Risk Assessment

- A user cannot withdraw the same balance twice (double spending).\
  Implementation: rule `RA_Silo_no_double_withdraw`

- A user should not be able to repay a loan with less amount than he borrowed.\
  Implementation: rule `RA_Silo_no_negative_interest_for_loan`

- With collateralOnly deposit, there is no scenario when the balance of
  a contract is less than that deposit amount.\
  Implementation: rule `RA_Silo_balance_more_than_collateralOnly_deposit`

- A user should not be able to deposit an asset that he borrowed in the Silo.\
  Implementation: rule `RA_Silo_borrowed_asset_not_depositable`

- A user has no debt after being repaid with max_uint256 amount. \
  Implementation: rule `RA_Silo_repay_all_shares`

- A user can withdraw all with max_uint256 amount. \
  Implementation: rule `RA_Silo_withdraw_all_shares`
