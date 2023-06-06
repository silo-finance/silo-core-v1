import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/SiloFunctionsSig.spec"

rule VC_Silo_collateral_totalSupply_change(method f, uint256 amount, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalSupplyBefore = shareCollateralToken.totalSupply();

    require amount < max_uint256 - totalSupplyBefore;

    SFSWithoutInterestWithCOAmount(f, siloAssetToken, collateralOnly, amount);

    uint256 totalSupplyAfter = shareCollateralToken.totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => (
            collateralOnly == false && (
                f.selector == depositSig() ||
                f.selector == depositForSig() ||
                f.selector == withdrawSig() ||
                f.selector == withdrawForSig()
            )
        ),
        "collateralToken totalSupply changed as a result of function other than expected";
}

rule VC_Silo_collateral_totalDeposits_increase(method f, uint256 amount, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalDepositsBefore = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupplyBefore = shareCollateralToken.totalSupply();

    require totalDepositsBefore >= totalSupplyBefore;
    require amount < max_uint256 - totalDepositsBefore;

    SFSWithoutInterestWithCOAmount(f, siloAssetToken, collateralOnly, amount);

    uint256 totalDepositsAfter = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupplyAfter = shareCollateralToken.totalSupply();

    assert (totalSupplyBefore < totalSupplyAfter && totalDepositsBefore < totalDepositsAfter) => (
            collateralOnly == false && (
                f.selector == depositSig() ||
                f.selector == depositForSig()
            )
        ),
        "collateralToken totalSupply & totalDeposits increase in a wrong way";
}

rule VC_Silo_collateral_totalDeposits_decrease(method f, uint256 amount, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalDepositsBefore = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupplyBefore = shareCollateralToken.totalSupply();
    
    require totalDepositsBefore >= totalSupplyBefore;
    require amount < max_uint256 - totalDepositsBefore;

    SFSWithoutInterestWithCOAmount(f, siloAssetToken, collateralOnly, amount);

    uint256 totalDepositsAfter = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupplyAfter = shareCollateralToken.totalSupply();

    assert (totalSupplyBefore > totalSupplyAfter && totalDepositsBefore > totalDepositsAfter) => (
            collateralOnly == false && (
                f.selector == withdrawSig() ||
                f.selector == withdrawForSig()
            )
        ),
        "collateralToken totalSupply & totalDeposits decrease in a wrong way";
}
