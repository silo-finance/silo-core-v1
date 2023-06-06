import "./_common/methods.spec"

rule UT_convertAmountsToValues_zeroSanity() {
    uint256 firstValue;
    uint256 secondValue;

    address firstAsset = getFirstAsset();
    address secondAsset = getSecondAsset();

    uint256 firstAmount = getFirstAmount();
    uint256 secondAmount = getSecondAmount();

    uint256 firstPrice = price(firstAsset);
    uint256 secondPrice = price(secondAsset);

    address priceProviderRepo;
    
    firstValue, secondValue = convertAmountsToValues(priceProviderRepo);

    assert (
        ((firstValue == 0) <=> (firstAmount * firstPrice < DP())) &&
        ((secondValue == 0) <=> (secondAmount * secondPrice < DP()))
    );
}

rule UT_convertAmountsToValues_concreteFormula() {
    uint256 firstValue;
    uint256 secondValue;

    address firstAsset = getFirstAsset();
    uint256 firstAmount = getFirstAmount();

    address secondAsset = getSecondAsset();
    uint256 secondAmount = getSecondAmount();

    address priceProviderRepo;
    
    firstValue, secondValue = convertAmountsToValues(priceProviderRepo);

    mathint firstCalculatedValue = (firstAmount * price(firstAsset)) / DP();
    mathint secondCalculatedValue = (secondAmount * price(secondAsset)) / DP();

    assert (
        firstValue == firstCalculatedValue && secondValue == secondCalculatedValue
    );
}

rule UT_calculateLiquidationFee(
    uint256 protocolEarnedFees,
    uint256 amount,
    uint256 liquidationFee
) {
    // If we overflow on multiplication it should not revert tx, we will get lower fees
    uint256 amountMulFee = amount * liquidationFee / DP();
    mathint sumOverflowable = protocolEarnedFees + amountMulFee;

    uint256 newProtocolEarnedFeesCalculated;
    uint256 liquidationFeeAmountCalculated;

    bool sumOverflowed = sumOverflowable > max_uint256;

    if (sumOverflowed) {
        newProtocolEarnedFeesCalculated = max_uint256;
        liquidationFeeAmountCalculated = max_uint256 - protocolEarnedFees;
    } else {
        newProtocolEarnedFeesCalculated = to_uint256(sumOverflowable);
        liquidationFeeAmountCalculated = to_uint256(amountMulFee);
    }

    uint256 liquidationFeeAmount;
    uint256 newProtocolEarnedFees;

    liquidationFeeAmount, newProtocolEarnedFees = calculateLiquidationFee(
        protocolEarnedFees,
        amount,
        liquidationFee
    );

    assert (newProtocolEarnedFeesCalculated == newProtocolEarnedFees) &&
        (liquidationFeeAmountCalculated == liquidationFeeAmount);
}

rule UT_getUserBorrowAmount() {
    uint256 totalBorrowAmount;
    address debtToken; 
    address user; 
    uint256 rcomp;

    uint256 userShares = balanceOfHarness(debtToken, user);
    uint256 debtTotalSupply = totalSupplyHarness(debtToken);

    require userShares < debtTotalSupply;

    uint256 expectedResult = getUserBorrowAmount(
        totalBorrowAmount,
        debtToken,
        user,
        rcomp
    );

    uint256 totalBorrowAmountWithInterest = totalBorrowAmount + totalBorrowAmount * rcomp / DP();
    uint256 userSharesMulTotalBorrowAmount = userShares * totalBorrowAmountWithInterest;
    uint256 borrowAmount;

    if (userSharesMulTotalBorrowAmount % debtTotalSupply == 0) {
        borrowAmount = userSharesMulTotalBorrowAmount / debtTotalSupply;
    } else {
        borrowAmount = userSharesMulTotalBorrowAmount / debtTotalSupply + 1;
    }

    assert borrowAmount == expectedResult;

}

rule UT_getUserCollateralAmount() {
    address collateralToken;
    address collateralOnlyToken;
    uint256 totalDeposits;
    uint256 collateralOnlyDeposits;
    uint256 userCollateralTokenBalance;
    uint256 userCollateralOnlyTokenBalance;
    uint256 rcomp;
    address siloRepository;

    uint256 collateralTokenTotalSupply = totalSupplyHarness(collateralToken);
    uint256 collateralOnlyTokenTotalSupply = totalSupplyHarness(collateralOnlyToken);

    require userCollateralTokenBalance <= collateralTokenTotalSupply;
    require userCollateralOnlyTokenBalance <= collateralOnlyTokenTotalSupply;

    uint256 depositorsInterest = DP() - protocolShareFeeMocked();
    uint256 totalDepositsWithInterestCalculated = totalDeposits + (totalDeposits * rcomp / DP()) * depositorsInterest / DP();
    uint256 collateralAmount;
    uint256 collateralOnlyAmount;

    if (userCollateralTokenBalance == 0) {
        collateralAmount = 0;
    } else {
        collateralAmount = totalDepositsWithInterestCalculated * userCollateralTokenBalance / collateralTokenTotalSupply;
    }

    if (userCollateralOnlyTokenBalance == 0) {
        collateralOnlyAmount = 0;
    } else {
        collateralOnlyAmount = collateralOnlyDeposits * userCollateralOnlyTokenBalance / collateralOnlyTokenTotalSupply;
    }

    uint256 expectedResult = getUserCollateralAmount(
        collateralToken,
        collateralOnlyToken,
        totalDeposits,
        collateralOnlyDeposits,
        userCollateralTokenBalance,
        userCollateralOnlyTokenBalance,
        rcomp,
        siloRepository
    );

    assert collateralAmount + collateralOnlyAmount == expectedResult;
}

rule UT_totalBorrowAmountWithInterest(uint256 totalBorrowAmount, uint256 rcomp) {
    uint256 totalBorrowAmountAddInterest = totalBorrowAmountWithInterest(totalBorrowAmount, rcomp);
    assert totalBorrowAmountAddInterest == totalBorrowAmount + totalBorrowAmount * rcomp / DP();
}

rule UT_totalDepositsWithInterest(uint256 assetTotalDeposits, uint256 protocolShareFee, uint256 rcomp) {
    uint256 totalDepositsAddInterest = totalDepositsWithInterest(assetTotalDeposits, protocolShareFee, rcomp);

    uint256 calculatedInterest = (assetTotalDeposits * rcomp / DP()) * (DP() - protocolShareFee) / DP();

    assert totalDepositsAddInterest == assetTotalDeposits + calculatedInterest;
}
