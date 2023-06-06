import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/SiloFunctionsSig.spec"

rule VC_Silo_collateralOnly_totalSupply_change(method f, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalSupplyBefore = shareCollateralOnlyToken.totalSupply();

    SFSWithoutInterestWithCollateralOnly(f, siloAssetToken, collateralOnly);

    uint256 totalSupplyAfter = shareCollateralOnlyToken.totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => (
            collateralOnly == true && (
                f.selector == depositSig() ||
                f.selector == depositForSig() ||
                f.selector == withdrawSig() ||
                f.selector == withdrawForSig()
            )
        ),
        "collateralToken totalSupply changed as a result of function other than expected";
}

rule VC_Silo_collateralOnly_collateralOnlyDeposits_increase(method f, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalDepositsBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupplyBefore = shareCollateralOnlyToken.totalSupply();

    require totalDepositsBefore >= totalSupplyBefore;
    
    SFSWithoutInterestWithCollateralOnly(f, siloAssetToken, collateralOnly);

    uint256 totalDepositsAfter = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupplyAfter = shareCollateralOnlyToken.totalSupply();

    assert totalSupplyBefore < totalSupplyAfter => totalDepositsBefore < totalDepositsAfter;
    assert (totalSupplyBefore < totalSupplyAfter && totalDepositsBefore < totalDepositsAfter) => (
            collateralOnly == true && (
                f.selector == depositSig() ||
                f.selector == depositForSig()
            )
        ),
        "collateralOnlyToken totalSupply & totalDeposits increase in a wrong way";
}

rule VC_Silo_collateralOnly_collateralOnlyDeposits_decrease(method f, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 totalDepositsBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupplyBefore = shareCollateralOnlyToken.totalSupply();

    require totalDepositsBefore >= totalSupplyBefore;

    SFSWithoutInterestWithCollateralOnly(f, siloAssetToken, collateralOnly);

    uint256 totalDepositsAfter = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupplyAfter = shareCollateralOnlyToken.totalSupply();

    assert totalSupplyBefore > totalSupplyAfter => totalDepositsBefore > totalDepositsAfter;
    assert (totalSupplyBefore > totalSupplyAfter && totalDepositsBefore > totalDepositsAfter) => (
            collateralOnly == true && (
                f.selector == withdrawSig() ||
                f.selector == withdrawForSig()
            )
        ),
        "collateralOnlyToken totalSupply & totalDeposits decrease in a wrong way";
}
