#!/bin/bash
#
# After script execution result will be sent to the email related to the Certora key
#
# Note:
# Because of the '--send_only' flag that you can find in the 'run.sh', this script
# only sends requests for verification to Certora Prover without waiting for
# the test results. Verification time for different specifications can variates
# between a couple of minutes to two hours.

new_line() {
    echo -e "\n"
}

switch_solidity() {
    solc-select use $1
    new_line
}

new_line

# Ensure solidity version is 0.8.13
switch_solidity "0.8.13"

# Run specifications for smart contracts with solidity 0.8.13
bash certora/specs/easy-math/run.sh
new_line
bash certora/specs/interest-rate-model/run.sh
new_line
bash certora/specs/permissions/manageable/run.sh
new_line
bash certora/specs/permissions/two-steps-ownable/run.sh
new_line
bash certora/specs/shares-tokens/run.sh
new_line
bash certora/specs/silo/run.sh
new_line
bash certora/specs/silo-factory/run.sh
new_line
bash certora/specs/silo-repository/run.sh
new_line
bash certora/specs/tokens-factory/run.sh
new_line
bash certora/specs/price-providers/repository/run.sh
new_line
bash certora/specs/guarded-launch/run.sh
new_line
bash certora/specs/price-providers/chainlink/run.sh
new_line

# Switch to the solidity version 0.7.6
switch_solidity "0.7.6"

# Run specifications for smart contracts with solidity 0.7.6
bash certora/specs/price-providers/unsiwap-v3/run.sh
new_line
bash certora/specs/price-providers/unsiwap-v3-v2/run.sh
new_line
bash certora/specs/price-providers/balancer-v2/run.sh
new_line
