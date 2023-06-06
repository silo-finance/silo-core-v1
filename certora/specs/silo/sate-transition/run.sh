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
        --verify SiloHarness:certora/specs/silo/sate-transition/StateTransition.spec \
        --staging jtoman/bancor-opt \
        --settings -enableEqualitySaturation=false \
        --rule $1 \
        --msg "Silo state transition - $1" \
        --optimistic_loop \
        --send_only
}

run "ST_Silo_totalSupply_totalDeposits"
run "ST_Silo_totalSupply_collateralOnlyDeposits"
run "ST_Silo_totalSupply_totalBorrowAmount"
run "ST_Silo_mint_shares"
run "ST_Silo_mint_debt"
run "ST_Silo_asset_init_shares_tokes"
run "ST_Silo_asset_reactivate"
