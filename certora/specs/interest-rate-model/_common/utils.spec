function setupValidConfigCommon(interestRateModel.Config config) {
    require config.uopt > 0 && config.uopt < 10 ^ 18;
    require config.ucrit > config.uopt && config.ucrit < 10 ^ 18;
    require config.ulow > 0 && config.ulow < config.uopt;
    require config.ki > 0;
    require config.kcrit > 0;
    require config.klow >= 0;
    require config.klin >= 0;
    require config.beta >= 0;
    require config.ri >= 0;
    require config.Tcrit >= 0;
    require DP() == 10^18;
}

function requireNoOverflow(
    env e,
    interestRateModel.Config config,
    uint256 totalDeposits,
    uint256 totalBorrowAmount,
    uint256 interestRateTimestamp,
    uint256 blockTimestamp
) {
    bool overflow;

    uint256 rcomp;
    int256 ri;
    int256 tcrit;


    rcomp, ri, tcrit, overflow = calculateCompoundInterestRateWithOverflowDetection(
        e,
        config,
        totalDeposits,
        totalBorrowAmount,
        interestRateTimestamp,
        blockTimestamp
    );

    require !overflow;
} 

function getValidUtilisation(uint256 totalDeposits, uint256 totalBorrowAmount) returns int256 {
    require totalDeposits != 0;
    require totalBorrowAmount <= 2 ^ 196;
    return to_int256(totalBorrowAmount * 10 ^ 18 / totalDeposits);
}

function setupValidConfigCompoundInterest(
    interestRateModel.Config config,
    int256 currentUtilisation,
    uint256 oldTimestamp,
    uint256 newTimestamp
) {
    require currentUtilisation >= 0 && currentUtilisation <= 10 ^ 18;
    require oldTimestamp < newTimestamp;

    setupValidConfigCommon(config);
}

function setupValidConfigCurrentInterest(
    interestRateModel.Config config,
    int256 oldUtilisation,
    int256 newUtilisation,
    uint256 interestRateTimestamp,
    uint256 blockTimestamp
) {
    require oldUtilisation >= 0 && oldUtilisation <= 10 ^ 18;
    require newUtilisation >= 0 && newUtilisation <= 10 ^ 18;
    require interestRateTimestamp < blockTimestamp;

    setupValidConfigCommon(config);
}

function setupValidConfigCurrentAndCompoundInterest(
    interestRateModel.Config config,
    int256 utilisation
) {
    require utilisation >= 0 && utilisation <= 10 ^ 18;

    setupValidConfigCommon(config);
}

function copyAndUpdateRiTcrit(interestRateModel.Config oldConfig, interestRateModel.Config newConfig, int256 ri, int256 tcrit) {
    require oldConfig.uopt == newConfig.uopt;
    require oldConfig.ucrit == newConfig.ucrit;
    require oldConfig.ulow == newConfig.ulow;
    require oldConfig.ki == newConfig.ki;
    require oldConfig.kcrit == newConfig.kcrit;
    require oldConfig.klow == newConfig.klow;
    require oldConfig.klin == newConfig.klin;
    require oldConfig.beta == newConfig.beta;
    require newConfig.ri == ri;
    require newConfig.Tcrit == tcrit;
}
