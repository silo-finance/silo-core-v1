#!/bin/bash

certoraRun certora/harness/TwoStepOwnableHarness.sol \
    --verify TwoStepOwnableHarness:certora/specs/permissions/two-steps-ownable/TwoStepOwnable.spec \
    --msg "Two step ownable" \
    --send_only
