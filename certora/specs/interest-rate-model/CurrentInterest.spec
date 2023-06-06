import "./_common/methods.spec"
import "./_common/utils.spec"

rule UT_calculateCurrentInterestRate_uIsDecreased(interestRateModel.Config config) {
    env e;

    uint256 totalDepositsOld;
    uint256 totalBorrowAmountOld;
    int256 uOld = getValidUtilisation(totalDepositsOld, totalBorrowAmountOld);

    uint256 totalDepositsNew;
    uint256 totalBorrowAmountNew;
    int256 uNew = getValidUtilisation(totalDepositsNew, totalBorrowAmountNew);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCurrentInterest(config, uOld, uNew, interestRateTimestamp, blockTimestamp);

    uint256 rcurOld = calculateCurrentInterestRate(
        e,
        config,
        totalDepositsOld,
        totalBorrowAmountOld,
        interestRateTimestamp,
        interestRateTimestamp
    );

    uint256 rcomp;
    int256 ri;
    int256 tcrit;

    rcomp, ri, tcrit = calculateCompoundInterestRate(
        e,
        config,
        totalDepositsOld,
        totalBorrowAmountOld,
        interestRateTimestamp,
        blockTimestamp
    );


    interestRateModel.Config newConfig;
    copyAndUpdateRiTcrit(config, newConfig, ri, tcrit);

    uint256 rcurNew = calculateCurrentInterestRate(
        e,
        newConfig,
        totalDepositsNew,
        totalBorrowAmountNew,
        blockTimestamp,
        blockTimestamp)
    ;

    assert ((uOld >= uNew) && (rcurNew > rcurOld)) => uOld >= config.uopt;
}

// Proved with overflow cases excluded.
rule UT_calculateCurrentInterestRate_uBecameZero(interestRateModel.Config config) {
    env e;

    uint256 totalDeposits;
    uint256 totalBorrowAmount;
    int256 u = getValidUtilisation(totalDeposits, totalBorrowAmount);

    uint256 blockTimestamp;

    setupValidConfigCommon(config);
    require u >= 0 && u <= 10 ^ 18;

    uint256 rcur = calculateCurrentInterestRate(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        blockTimestamp,
        blockTimestamp
    );

    mathint dp = to_mathint(DP());

    assert (rcur == 0) => (to_mathint(u) * to_mathint(config.klin) / dp == 0);
}

rule UT_calculateCurrentInterestRate_uIsIncreasedKlin(interestRateModel.Config config) {
    env e;

    uint256 totalDepositsOld;
    uint256 totalBorrowAmountOld;

    int256 uOld = getValidUtilisation(totalDepositsOld, totalBorrowAmountOld);

    uint256 totalDepositsNew;
    uint256 totalBorrowAmountNew;
    int256 uNew = getValidUtilisation(totalDepositsNew, totalBorrowAmountNew);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCurrentInterest(config, uOld, uNew, interestRateTimestamp, blockTimestamp);

    uint256 rcomp;
    int256 ri;
    int256 tcrit;

    rcomp, ri, tcrit = calculateCompoundInterestRate(
        e,
        config,
        totalDepositsOld,
        totalBorrowAmountOld,
        interestRateTimestamp,
        blockTimestamp
    );

    uint256 rcurOld = calculateCurrentInterestRate(
        e,
        config,
        totalDepositsOld,
        totalBorrowAmountOld,
        interestRateTimestamp,
        interestRateTimestamp
    );

    interestRateModel.Config newConfig;
    copyAndUpdateRiTcrit(config, newConfig, ri, tcrit);

    uint256 rcurNew = calculateCurrentInterestRate(
        e,
        newConfig,
        totalDepositsNew,
        totalBorrowAmountNew,
        blockTimestamp,
        blockTimestamp
    );

    mathint dp = to_mathint(DP());

    assert ((uOld < uNew) && (to_mathint(rcurOld) <= to_mathint(config.klin) * to_mathint(uOld) / dp)) => 
            (rcurNew >= rcurOld);
}

rule UT_calculateCurrentInterestRate_uIsIncreased(interestRateModel.Config config) {
    env e;

    uint256 totalDepositsOld;
    uint256 totalBorrowAmountOld;
    int256 uOld = getValidUtilisation(totalDepositsOld, totalBorrowAmountOld);

    uint256 totalDepositsNew;
    uint256 totalBorrowAmountNew;
    int256 uNew = getValidUtilisation(totalDepositsNew, totalBorrowAmountNew);

    uint256 interestRateTimestamp;
    uint256 blockTimestamp;

    setupValidConfigCurrentInterest(config, uOld, uNew, interestRateTimestamp, blockTimestamp);

    uint256 rcomp;
    int256 ri;
    int256 tcrit;

    rcomp, ri, tcrit = calculateCompoundInterestRate(
        e,
        config,
        totalDepositsOld,
        totalBorrowAmountOld,
        interestRateTimestamp,
        blockTimestamp
    );

    uint256 rcurOld = calculateCurrentInterestRate(
        e,
        config,
        totalDepositsOld,
        totalBorrowAmountOld,
        interestRateTimestamp,
        interestRateTimestamp
    );

    interestRateModel.Config newConfig;
    copyAndUpdateRiTcrit(config, newConfig, ri, tcrit);

    uint256 rcurNew = calculateCurrentInterestRate(
        e,
        newConfig,
        totalDepositsNew,
        totalBorrowAmountNew,
        blockTimestamp,
        blockTimestamp
    );

    assert (uOld > config.uopt && uNew > uOld) => (rcurNew >= rcurOld);
}