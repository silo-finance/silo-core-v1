#!/bin/bash

certoraRun certora/harness/SiloHarness.sol \
        certora/harness/ShareCollateralOnlyTokenHarness.sol \
        contracts/utils/ShareCollateralToken.sol \
        contracts/utils/ShareDebtToken.sol \
        contracts/SiloRepository.sol \
        certora/mocks/TokensFactoryMock.sol \
        certora/mocks/DummyERC20Asset.sol \
        --link SiloRepository:tokensFactory=TokensFactoryMock \
        --link SiloHarness:siloRepository=SiloRepository \
        --verify SiloHarness:certora/specs/silo/valid-states/ValidStates.spec \
        --staging jtoman/bancor-opt \
        --settings -enableEqualitySaturation=false \
        --msg "Silo valid states" \
        --optimistic_loop \
        --loop_iter 2 \
        --send_only
