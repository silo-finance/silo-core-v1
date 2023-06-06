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
        --verify SiloHarness:certora/specs/silo/varaible-changes/$1.spec \
        --staging jtoman/bancor-opt \
        --settings -enableEqualitySaturation=false \
        --msg "Silo variable changes - $1" \
        --optimistic_loop \
        --send_only
}

run "VariableChangesCollateralToken"
run "VariableChangesCollateralOnlyToken"
run "VariableChangesDebtToken"
run "VariableChanges"
run "VariableChangesWithoutInterest"
