import "./_common/methods.spec"
import "./_common/utils.spec"

rule interestNotMoreThenMax(interestRateModel.Config config){
    env e;
    uint256 tokenIndex;
    require tokenIndex < 20;
    setConfig(config, tokenIndex);

    uint256 borrow;
    uint256 deposited;
    int256 utilization = getValidUtilisation(deposited, borrow);
    require utilization == 10^18;
    uint256 interestRateTimestamp;
    uint256 blockTimestamp;
    require interestRateTimestamp < blockTimestamp && blockTimestamp < interestRateTimestamp + 36000000;
    uint256 max_interest = calculateCurrentInterestRate(
        e,
        config,
        deposited,
        borrow,
        interestRateTimestamp,
        blockTimestamp
    );
    uint256 borrow_other;
    uint256 deposited_other;
    require borrow_other > deposited_other;
    uint256 other_interest = calculateCurrentInterestRate(
        e,
        config,
        deposited_other,
        borrow_other,
        interestRateTimestamp,
        blockTimestamp
    );
    assert other_interest <= max_interest;
    assert 100000000000000000000 >= max_interest;
}

rule cantExceedMaxUtilization(uint256 totalDeposits, uint256 totalBorrowAmount) {
    uint256 maxUtilization = DP();
    
    uint256 currentUtilization = calculateUtilization(totalDeposits, totalBorrowAmount);

    assert currentUtilization <= maxUtilization;
}

// function to setup actual real world configurations
function setConfig(interestRateModel.Config config, uint256 tokenIndex) {
    // stableLowCap
    if (tokenIndex == 1) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 183506;
        require config.kcrit == 237823439878;
        require config.klow == 31709791984;
        require config.klin == 1585489599;
        require config.beta == 27777777777778;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // stableHighCap
    else if (tokenIndex == 2) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 600000000000000000;
        require config.ki == 183506;
        require config.kcrit == 237823439878;
        require config.klow == 26424826653;
        require config.klin == 1585489599;
        require config.beta == 27777777777778;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt50Base1
    else if (tokenIndex == 3) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 146805;
        require config.kcrit == 317097919838;
        require config.klow == 105699306613;
        require config.klin == 634195840;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt50Base3
    else if (tokenIndex == 4) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 146805;
        require config.kcrit == 317097919838;
        require config.klow == 105699306613;
        require config.klin == 1902587519;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt50Base7
    else if (tokenIndex == 5) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 146805;
        require config.kcrit == 317097919838;
        require config.klow == 105699306613;
        require config.klin == 4439370878;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt50Base15
    else if (tokenIndex == 6) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 146805;
        require config.kcrit == 317097919838;
        require config.klow == 105699306613;
        require config.klin == 9512937595;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt80Base1
    else if (tokenIndex == 7) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 367011;
        require config.kcrit == 317097919838;
        require config.klow == 63419583968;
        require config.klin == 396372400;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt80Base3
    else if (tokenIndex == 8) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 367011;
        require config.kcrit == 317097919838;
        require config.klow == 63419583968;
        require config.klin == 1189117199;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt80Base7
    else if (tokenIndex == 9) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 367011;
        require config.kcrit == 317097919838;
        require config.klow == 63419583968;
        require config.klin == 2774606799;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // volatileOpt80Base15
    else if (tokenIndex == 10) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 367011;
        require config.kcrit == 317097919838;
        require config.klow == 63419583968;
        require config.klin == 5945585997;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // bridgeXAI
    else if (tokenIndex == 11) {
        require config.uopt == 800000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 183506;
        require config.kcrit == 237823439878;
        require config.klow == 31709791984;
        require config.klin == 1585489599;
        require config.beta == 27777777777778;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // bridgeETH
    else if (tokenIndex == 12) {
        require config.uopt == 700000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 244674;
        require config.kcrit == 317097919838;
        require config.klow == 31709791984;
        require config.klin == 1358991085;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // bridgeETHv2
    else if (tokenIndex == 13) {
        require config.uopt == 700000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 500000000000000000;
        require config.ki == 244674;
        require config.kcrit == 317097919838;
        require config.klow == 31709791984;
        require config.klin == 2604732913;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // fixedXAI
    else if (tokenIndex == 14) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 0;
        require config.kcrit == 0;
        require config.klow == 0;
        require config.klin == 0;
        require config.beta == 0;
        require config.ri == 31709792;
        require config.Tcrit == 0;
    }
    // fixedXAIv2
    else if (tokenIndex == 15) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 0;
        require config.kcrit == 0;
        require config.klow == 0;
        require config.klin == 0;
        require config.beta == 0;
        require config.ri == 634195840;
        require config.Tcrit == 0;
    }
    // fixedZero
    else if (tokenIndex == 16) {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 0;
        require config.kcrit == 0;
        require config.klow == 0;
        require config.klin == 0;
        require config.beta == 0;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
    // defaultAsset
    else {
        require config.uopt == 500000000000000000;
        require config.ucrit == 900000000000000000;
        require config.ulow == 300000000000000000;
        require config.ki == 146805;
        require config.kcrit == 317097919838;
        require config.klow == 105699306613;
        require config.klin == 4439370878;
        require config.beta == 69444444444444;
        require config.ri == 0;
        require config.Tcrit == 0;
    }
}