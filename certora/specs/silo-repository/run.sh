#!/bin/bash

run() {
    time certoraRun ./certora/harness/SiloRepositoryHarness.sol \
    ./contracts/SiloFactory.sol \
    ./contracts/Silo.sol \
    --verify SiloRepositoryHarness:./certora/specs/silo-repository/$1.spec \
    --settings -divideNoRemainder=true,-enableEqualitySaturation=false \
    --staging jtoman/dynamic-creation \
    --optimistic_loop \
    --loop_iter 3 \
    --msg "Silo Repository - $1" \
    --short_output \
    --send_only
}

run "VariableChanges"
run "ValidStates"
run "UnitTests"
