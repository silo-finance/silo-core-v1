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
        --verify SiloHarness:certora/specs/silo/high-level/$1.spec \
        --staging alex/to-skey-vs-max-solidity-slot \
        --settings -enableEqualitySaturation=false \
        --msg "Silo high level properties - $1" \
        --optimistic_loop \
        --send_only
}

run "CollateralToken"
run "CollateralOnlyToken"
run "DebtToken"
run "Common"
