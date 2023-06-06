#!/bin/bash

run() {
    time certoraRun ./certora/harness/InterestRateModelHarness.sol \
    --verify InterestRateModelHarness:./certora/specs/interest-rate-model/$1.spec \
    --settings -assumeUnwindCond,-enableEqualitySaturation=false,-t=600000,-s=[z3:def,z3:lia1,z3:lia2,yices:def],-mediumTimeout=1200,-runNIAWhenLIAFails=false,-prettifyCEX=none \
    --staging \
    --optimistic_loop \
    --send_only \
    --msg "Interest Rate Model - $1"
}

 run "CertoraInterestRate"
 run "ValidStates"
 run "VariableChanges"
 run "UnitTests"
 run "CurrentInterest"
 run "NoOverflowUnitTests"
 
