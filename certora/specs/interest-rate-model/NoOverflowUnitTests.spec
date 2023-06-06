import "./_common/methods.spec"
import "./_common/utils.spec"

// This rule exceed timeout. Proved using fuzzy mining. Overflow cases excluded.
rule PMTH_compoundAndCurrentInterest_uGreaterUopt() {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    interestRateModel.Config config;

    setupValidConfigCurrentAndCompoundInterest(config, u);
 
    // blockTimestamp = 0, interestRateTimestamp = 1 second for the prover time optimisation.
    // calculateCurrentInterestRate and calculateCompoundInterestRate functions calculates the difference
    // between timestamps (T variable). T is used as an multiplier for other config variables in computations,
    // other config parameters does not have any restrictions, so the multiplication product is not restricted in any way.

    // The maximum value of possible exponential function error (even more, 1000 wei) is added to rcomp. 
    // rcompBalanced = (rcomp + 1000) * 31536000);

    uint256 rcompBalanced;
    uint256 rcurOld;
    rcurOld, rcompBalanced = rcurOldRcompBalancedHarness(e, config, totalDeposits, totalBorrowAmount);

    assert (u >= config.uopt) => 
            (rcompBalanced >= rcurOld);
}

// This rule exceed timeout. Proved using fuzzy mining. Overflow cases excluded.
rule PMTH_compoundAndCurrentInterest_uLessUopt() {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    interestRateModel.Config config;

    setupValidConfigCurrentAndCompoundInterest(config, u);

    // blockTimestamp = 0, interestRateTimestamp = 1 second for the prover time optimisation.
    // calculateCurrentInterestRate and calculateCompoundInterestRate functions calculates the difference
    // between timestamps (T variable). T is used as an multiplier for other config variables in computations,
    // other config parameters does not have any restrictions, so the multiplication product is not restricted in any way.

    // The maximum value of possible exponential function error (even more, 1000 wei) is added to rcomp. 
    // rcompBalanced = (rcomp + 1000) * 31536000);

    uint256 rcompBalanced;
    uint256 rcur;
    rcur, rcompBalanced = rcurRcompBalancedHarness(e, config, totalDeposits, totalBorrowAmount);

    // 31536000 == 365*24*60*60
    assert (u <= config.uopt) => 
            (rcompBalanced >= rcur);
}
