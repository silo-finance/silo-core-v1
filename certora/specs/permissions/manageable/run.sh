#!/bin/bash

certoraRun certora/harness/ManageableHarness.sol \
    --verify ManageableHarness:certora/specs/permissions/manageable/Manageable.spec \
    --msg "Manageable" \
    --send_only
