import "./_common/ltvMethods.spec"

// NOTE: timeout exceeded.
// All internal function calls are proved in this high level rule, so this rule is optional to prove.

invariant VS_harnessSanity_twoAssets()
    getFirstAsset() != 0 && getSecondAsset() != 0 && getFirstAsset() != getSecondAsset()

rule VS_specSimplificationSanity_priceCanBeChanged(address asset1, address asset2, uint newPrice) {
    uint before = price(asset1);

    changePrice(asset2, newPrice);

    uint after = price(asset1);

    assert asset1 == asset2 || after == before ;
    assert price(asset2) == newPrice;
}

rule UT_calculateLTVs(
        address user,
        uint256 totalDepositsFirstAsset,
        uint256 collateralOnlyDepositsFirstAsset,
        uint256 totalBorrowAmountFirstAsset,
        uint256 totalDepositsSecondAsset,
        uint256 collateralOnlyDepositsSecondAsset,
        uint256 totalBorrowAmountSecondAsset,
        uint256 LTVType
) {

    env e;

    uint256 debtTokenBalance = balanceOfHarness(debtTokens(0), user);

    uint256 collateralTokenBalance = balanceOfHarness(collateralTokens(1), user);
    uint256 collateralOnlyTokenBalance = balanceOfHarness(collateralOnlyTokens(1), user);

    uint256 debtAssetPrice = price(getFirstAsset());
    uint256 collateralAssetPrice = price(getSecondAsset());

    require debtAssetPrice > 0;
    require collateralAssetPrice > 0;

    uint256 userLTV;
    uint256 secondLTV;

    userLTV, secondLTV = calculateLTVsHarness(
        e,
        user,
        totalDepositsFirstAsset,
        collateralOnlyDepositsFirstAsset,
        totalBorrowAmountFirstAsset,
        totalDepositsSecondAsset,
        collateralOnlyDepositsSecondAsset,
        totalBorrowAmountSecondAsset,
        LTVType
    );

    uint256 debtValue = totalBorrowAmountFirstAsset * debtAssetPrice;
    uint256 collateralValue = (totalDepositsSecondAsset + collateralOnlyDepositsSecondAsset) * collateralAssetPrice;

    if (debtValue == 0) {
        assert userLTV == 0 && secondLTV == 0;
    } else if (collateralValue == 0) {
        assert userLTV == max_uint256 && secondLTV == 0;
    } else {
        uint256 calculatedLTV = debtValue * to_uint256(DP()) / collateralValue;
        uint256 diff;
        if (calculatedLTV > userLTV) {
            diff = calculatedLTV - userLTV;
        } else {
            diff = userLTV - calculatedLTV;
        }
        assert diff < 1000;
    }
}
