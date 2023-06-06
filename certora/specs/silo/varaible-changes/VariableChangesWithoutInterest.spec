import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/SiloFunctionsSig.spec"

rule VC_Silo_totalDeposits_without_interest(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalDepositsBefore = getAssetTotalDeposits(siloAssetToken);

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalDepositsAfter = getAssetTotalDeposits(siloAssetToken);

    assert totalDepositsBefore != totalDepositsAfter => (
            f.selector == depositSig() ||
            f.selector == depositForSig() ||
            f.selector == withdrawSig() ||
            f.selector == withdrawForSig() ||
            f.selector == flashLiquidateSig()
        ),
        "totalDeposits changed as a result of function other than expected";
}

rule VC_Silo_totalBorrowAmount_without_interest(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);

    assert totalBorrowBefore != totalBorrowAfter => (
            f.selector == repaySig() ||
            f.selector == repayForSig() ||
            f.selector == borrowSig() ||
            f.selector == borrowForSig()
        ),
        "collateralOnlyDeposits changed as a result of function other than expected";
}

rule VC_Silo_protocolFees_without_interest(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 protocolFeesBefore = getProtocolFees(siloAssetToken);

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 protocolFeesAfter = getProtocolFees(siloAssetToken);

    assert protocolFeesBefore != protocolFeesAfter => (
            f.selector == borrowSig() ||
            f.selector == borrowForSig()
        ),
        "protocolFees changed as a result of function other than expected";
}

rule VC_Silo_interestRateTimestamp_in_the_same_block(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 timestampBefore = getAssetInterestDataTimeStamp(siloAssetToken);

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 timestampAfter = getAssetInterestDataTimeStamp(siloAssetToken);

    assert timestampBefore == timestampAfter, "interestRateTimestamp changed";
}
