#!/bin/bash

runCollateral() {
    certoraRun contracts/utils/ShareCollateralToken.sol \
        --verify ShareCollateralToken:certora/specs/shares-tokens/$1 \
        --msg "$2" \
        --optimistic_loop \
        --send_only
}

runDebt() {
    certoraRun contracts/utils/ShareDebtToken.sol \
        --verify ShareDebtToken:certora/specs/shares-tokens/debt-token/$1 \
        --msg "$2" \
        --optimistic_loop \
        --send_only
}

# Shares tokens common rules
runCollateral "ERC20VariablesChanges.spec" "Common shares tokens variable changes"
runCollateral "ERC20HighLevelProps.spec" "Common shares tokens high level props"
runCollateral "SharesUnit.spec" "Shares tokens unit tests"
runCollateral "SharesRiskAssessment.spec" "Shares tokens risk assessment"

# Debt token
runDebt "DebtTokenVariablesChange.spec" "Debt tokens variable changes"
runDebt "DebtTokenHighLevelProps.spec" "Debt tokens high level props"
