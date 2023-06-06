#!/bin/bash

certoraRun certora/harness/GuardedLaunchHarness.sol \
    --verify GuardedLaunchHarness:certora/specs/guarded-launch/GuardedLaunch.spec \
    --msg "Guarded launch" \
    --send_only
