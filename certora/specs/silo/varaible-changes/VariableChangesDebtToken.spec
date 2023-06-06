import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/SiloFunctionsSig.spec"

rule VC_Silo_debt_totalSupply_change(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalSupplyBefore = shareDebtToken.totalSupply();

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalSupplyAfter = shareDebtToken.totalSupply();

    assert totalSupplyBefore != totalSupplyAfter => (
            f.selector == repaySig() ||
            f.selector == repayForSig() ||
            f.selector == borrowSig() ||
            f.selector == borrowForSig()
        ),
        "collateralToken totalSupply changed as a result of function other than expected";
}

rule VC_Silo_debt_totalBorrow_increase(method f) filtered { f -> !f.isView && !f.isFallback } {
    env e;
    
    set_tokens();

    uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupplyBefore = shareDebtToken.totalSupply();

    require totalBorrowBefore >= totalSupplyBefore;
    
    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupplyAfter = shareDebtToken.totalSupply();

    assert totalSupplyBefore < totalSupplyAfter => totalBorrowBefore < totalBorrowAfter;
    assert (totalSupplyBefore < totalSupplyAfter && totalBorrowBefore < totalBorrowAfter) => (
            f.selector == borrowSig() ||
            f.selector == borrowForSig()
        ),
        "debtToken totalSupply & totalDeposits increase in a wrong way";
}

rule VC_Silo_debt_totalBorrow_decrease(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupplyBefore = shareDebtToken.totalSupply();

    require totalBorrowBefore >= totalSupplyBefore;
    
    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupplyAfter = shareDebtToken.totalSupply();

    assert totalSupplyBefore > totalSupplyAfter => totalBorrowBefore > totalBorrowAfter;
    assert (totalSupplyBefore > totalSupplyAfter && totalBorrowBefore > totalBorrowAfter) => (
            f.selector == repaySig() ||
            f.selector == repayForSig()
        ),
        "debtToken totalSupply & totalDeposits decrease in a wrong way";
}
