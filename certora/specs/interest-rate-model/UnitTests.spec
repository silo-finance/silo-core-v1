import "./_common/methods.spec"
import "./_common/utils.spec"

rule UT_onlyOwnerSetConfig(method f) {
    require f.selector == setConfigSig();
    env e;
    calldataarg args;

    f(e, args);
    address owner = owner(e);

    assert !lastReverted => e.msg.sender == owner;
}

rule UT_calculateCompoundInterestRate_uLargerUcrit(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);

    int256 tcritOld = config.Tcrit;
    int256 ucrit = config.ucrit;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    assert ((config.beta != 0 ) && (u > ucrit)) <=> (tcrit > tcritOld);
}

rule UT_calculateCompoundInterestRate_uLargerUopt(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);

    int256 riOld = config.ri;
    int256 uopt = config.uopt;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    // u > uopt => ri > riOld, but the rule below is weaker because of the rounding errors
    // in discrete computations.
    assert (u > uopt) => (ri >= riOld);
}

rule UT_calculateCompoundInterestRate_uLargerUoptAndRiLessKlin(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);

    mathint riOld = to_mathint(config.ri);
    mathint klin = to_mathint(config.klin);
    int256 uopt = config.uopt;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    mathint klinMulU = klin * to_mathint(u) / DP();

    // ((u > uopt) && (riOld <= klinMulU)) => (to_mathint(ri) > klinMulU), but the rule below is
    // weaker because of the rounding errors in discrete computations.
    assert ((u > uopt) && (riOld <= klinMulU)) => (to_mathint(ri) >= klinMulU);
}

rule UT_calculateCompoundInterestRate_uEqualsUoptAndRiLessKlin(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);

    mathint riOld = to_mathint(config.ri);
    mathint klin = to_mathint(config.klin);
    int256 uopt = config.uopt;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    mathint klinMulU = klin * to_mathint(u) / DP();

    assert ((u == uopt) && (riOld < klinMulU)) => (to_mathint(ri) == klinMulU);
}

rule UT_calculateCompoundInterestRate_uEqualsUoptAndRiGreaterKlin(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);


    mathint riOld = to_mathint(config.ri);
    mathint klin = to_mathint(config.klin);
    int256 uopt = config.uopt;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    assert ((u == uopt) && (riOld >= (klin * to_mathint(u)) / DP())) => 
            (to_mathint(ri) == riOld);
}

rule UT_calculateCompoundInterestRate_uLessUoptAndRiLessKlin(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);

    mathint riOld = to_mathint(config.ri);
    mathint klin = to_mathint(config.klin);
    int256 uopt = config.uopt;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    mathint klinMulU = klin * to_mathint(u) / DP();

    assert ((u <= uopt) && (riOld <= klinMulU)) => (to_mathint(ri) == klinMulU);
}

rule UT_calculateCompoundInterestRate_uLessUoptAndRiGreaterKlin(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCompoundInterest(config, u, interestRateTimestamp, blockTimestamp);

    mathint riOld = to_mathint(config.ri);
    mathint klin = to_mathint(config.klin);
    int256 uopt = config.uopt;
    uint256 rcomp;
    int256 ri;
    int256 tcrit;
    bool overflow;

    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;

    mathint klinMulU = klin * to_mathint(u) / DP();

    // ((u < uopt) && (riOld > klinMulU)) => (to_mathint(ri) < riOld && to_mathint(ri) >= klinMulU), 
    // changed to a weaker rule 'to_mathint(ri) < riOld' -> 'to_mathint(ri) <= riOld' because of the
    // rounding errors in discrete computations.
    assert ((u < uopt) && (riOld > klinMulU)) => (to_mathint(ri) <= riOld && to_mathint(ri) >= klinMulU);
}

rule UT_max(int256 a, int256 b) {
    assert maxHarness(a, b) == a <=> a >= b;
}

rule UT_min(int256 a, int256 b) {
    assert minHarness(a, b) == a <=> a <= b;
}
