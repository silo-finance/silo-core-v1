#!/bin/bash

certoraRun certora/harness/EasyMathHarness.sol \
    --verify EasyMathHarness:certora/specs/easy-math/EasyMath.spec \
    --msg "EasyMath" \
    --optimistic_loop \
    --send_only
