import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"

rule ST_Silo_totalSupply_totalDeposits(method f) filtered { f -> !f.isView && !f.isFallback} {
    set_tokens();

    uint256 totalDepositsBefore = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupplyBefore = shareCollateralToken.totalSupply();

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalDepositsAfter = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupplyAfter = shareCollateralToken.totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => 
        (totalDepositsBefore < totalDepositsAfter && totalSupplyBefore < totalSupplyAfter) ||
        (totalDepositsBefore > totalDepositsAfter && totalSupplyBefore > totalSupplyAfter),
        "collateral total supply updated in the wrong way";
}

rule ST_Silo_totalSupply_collateralOnlyDeposits(method f)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalDepositsBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupplyBefore = shareCollateralOnlyToken.totalSupply();

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalDepositsAfter = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupplyAfter = shareCollateralOnlyToken.totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => 
        (totalDepositsBefore < totalDepositsAfter && totalSupplyBefore < totalSupplyAfter) ||
        (totalDepositsBefore > totalDepositsAfter && totalSupplyBefore > totalSupplyAfter),
        "collateral only total supply updated in the wrong way";
}

rule ST_Silo_totalSupply_totalBorrowAmount(method f, uint256 amount)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupplyBefore = shareDebtToken.totalSupply();

    require totalBorrowBefore >= totalSupplyBefore && amount <= totalSupplyBefore;
    SFSWithoutInterestWithAmount(f, siloAssetToken, amount);

    uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupplyAfter = shareDebtToken.totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => 
        (totalBorrowBefore < totalBorrowAfter && totalSupplyBefore < totalSupplyAfter) ||
        (totalBorrowBefore > totalBorrowAfter && totalSupplyBefore > totalSupplyAfter),
        "debt token total supply updated in the wrong way";
}

rule ST_Silo_mint_shares(method f, uint256 amount, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 collateralDepositBefore = shareCollateralToken.totalSupply();
    uint256 collateralOnlyDepositBefore = shareCollateralOnlyToken.totalSupply();

    bool assetIsActive = assetIsActive(siloAssetToken);
    SFSWithoutInterestWithAmountCollateralOnly(f, siloAssetToken, amount, collateralOnly);

    uint256 collateralDepositAfter = shareCollateralToken.totalSupply();
    uint256 collateralOnlyDepositAfter = shareCollateralOnlyToken.totalSupply();

    assert collateralDepositBefore < collateralDepositAfter => amount !=0 && assetIsActive,
         "collateral total supply updated with invalid conditions";

    assert collateralOnlyDepositBefore <  collateralOnlyDepositAfter =>
        amount !=0 && assetIsActive && collateralOnly,
        "collateral only total supply updated with invalid conditions";
       
}

rule ST_Silo_mint_debt(method f, uint256 amount) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);

    bool assetIsActive = assetIsActive(siloAssetToken);
    SFSWithoutInterestWithAmount(f, siloAssetToken, amount);

    uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);

    assert totalBorrowBefore < totalBorrowAfter => amount !=0 && assetIsActive,
        "debt total supply updated with invalid conditions";
}

rule ST_Silo_asset_init_shares_tokes(method f) filtered { f -> !f.isView && !f.isFallback } {
    require getAssetCollateralToken(siloAssetToken) == 0;
    require getAssetCollateralOnlyToken(siloAssetToken) == 0;
    require getAssetDebtToken(siloAssetToken) == 0;
    require assetIsActive(siloAssetToken) == false;

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    address collateralToken = getAssetCollateralToken(siloAssetToken);
    address collateralOnlyToken = getAssetCollateralOnlyToken(siloAssetToken);
    address debtToken = getAssetDebtToken(siloAssetToken);
    bool assetStatus = assetIsActive(siloAssetToken);

    assert assetStatus =>
        collateralToken != 0 && collateralOnlyToken != 0 && debtToken != 0 &&
        collateralToken != collateralOnlyToken && collateralToken != debtToken &&
        debtToken != collateralOnlyToken,
        "Invalid shares addresses after asset was activated";
}

rule ST_Silo_asset_reactivate(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();
    
    require assetIsActive(siloAssetToken) == false;

    address collateral = getAssetCollateralToken(siloAssetToken);
    address collateralOnly = getAssetCollateralOnlyToken(siloAssetToken);
    address debt = getAssetDebtToken(siloAssetToken);

    SFSWithoutInterestWithInputs(f, siloAssetToken);
    
    bool assetStatus = assetIsActive(siloAssetToken);

    assert assetStatus => (
            getAssetCollateralToken(siloAssetToken) == collateral &&
            getAssetCollateralOnlyToken(siloAssetToken) == collateralOnly &&
            getAssetDebtToken(siloAssetToken) == debt
        ),
        "Shares token address should not update after asset reactivation";
}
