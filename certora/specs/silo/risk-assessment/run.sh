#!/bin/bash

run() {
    certoraRun certora/harness/SiloHarness.sol \
        certora/harness/ShareCollateralOnlyTokenHarness.sol \
        contracts/utils/ShareCollateralToken.sol \
        contracts/utils/ShareDebtToken.sol \
        contracts/SiloRepository.sol \
        certora/mocks/TokensFactoryMock.sol \
        certora/mocks/DummyERC20Asset.sol \
        --link SiloRepository:tokensFactory=TokensFactoryMock \
        --link SiloHarness:siloRepository=SiloRepository \
        --link ShareCollateralToken:silo=SiloHarness \
        --link ShareDebtToken:silo=SiloHarness \
        --link ShareCollateralOnlyTokenHarness:silo=SiloHarness \
        --verify SiloHarness:certora/specs/silo/risk-assessment/RiskAssessment.spec \
        --rule "$1" \
        --staging alex/to-skey-vs-max-solidity-slot \
        --settings -enableEqualitySaturation=false \
        --msg "Silo risk assessment - $1" \
        --optimistic_loop \
        --send_only
}

run "RA_Silo_no_double_withdraw"
run "RA_Silo_no_negative_interest_for_loan"
run "RA_Silo_balance_more_than_collateralOnly_deposit"
run "RA_Silo_borrowed_asset_not_depositable"
run "RA_Silo_withdraw_all_shares"
run "RA_Silo_repay_all_shares"
run "RA_Silo_repay_all_collateral"
