#!/bin/bash

run() {
    time certoraRun ./certora/harness/SolvencyHarness.sol \
    certora/mocks/DummyERC20Asset.sol \
    --verify SolvencyHarness:./certora/specs/solvency/$1.spec \
    --settings -divideNoRemainder=true,-enableEqualitySaturation=false \
    --staging \
    --smt_timeout 600000 \
    --optimistic_loop \
    --loop_iter 3 \
    --msg "Solvency - $1"
}

run "UnitTests"
