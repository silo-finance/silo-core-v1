import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/SiloFunctionsSig.spec"

methods {
    getCompoundInterestRateAndUpdate(address, uint256) => DISPATCHER(true)
}

rule VC_Silo_totalDeposits(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalDepositsBefore = getAssetTotalDeposits(siloAssetToken);
    SFSWithInterestWithInputs(f, siloAssetToken);
    uint256 totalDepositsAfter = getAssetTotalDeposits(siloAssetToken);

    assert totalDepositsBefore != totalDepositsAfter => (
            f.selector == depositSig() ||
            f.selector == depositForSig() ||
            f.selector == withdrawSig() ||
            f.selector == withdrawForSig() ||
            f.selector == repaySig() ||
            f.selector == repayForSig() ||
            f.selector == borrowSig() ||
            f.selector == borrowForSig() ||
            f.selector == accrueInterestSig() ||
            f.selector == flashLiquidateSig()
        ),
        "totalDeposits changed as a result of function other than expected";
}

rule VC_Silo_collateralOnlyDeposits(method f, bool collateralOnly)
    filtered { f -> !f.isView && !f.isFallback }
{
    set_tokens();

    uint256 collateralOnlyDepositsBefore = getAssetCollateralOnlyDeposits(siloAssetToken);

    SFSWithInterestCollateralOnly(f, siloAssetToken, collateralOnly);

    uint256 collateralOnlyDepositsAfter = getAssetCollateralOnlyDeposits(siloAssetToken);

    assert collateralOnlyDepositsBefore != collateralOnlyDepositsAfter => (
            collateralOnly == true && (
                f.selector == depositSig() ||
                f.selector == depositForSig() ||
                f.selector == withdrawSig() ||
                f.selector == withdrawForSig()
            ) || (
                f.selector == flashLiquidateSig()
            )
        ),
        "collateralOnlyDeposits changed as a result of function other than expected";
}

rule VC_Silo_totalBorrowAmount(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);
    SFSWithInterestWithInputs(f, siloAssetToken);
    uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);

    assert totalBorrowBefore != totalBorrowAfter => (
            f.selector == depositSig() ||
            f.selector == depositForSig() ||
            f.selector == withdrawSig() ||
            f.selector == withdrawForSig() ||
            f.selector == repaySig() ||
            f.selector == repayForSig() ||
            f.selector == borrowSig() ||
            f.selector == borrowForSig() ||
            f.selector == accrueInterestSig() ||
            f.selector == flashLiquidateSig()
        ),
        "collateralOnlyDeposits changed as a result of function other than expected";
}

rule VC_Silo_harvestedProtocolFees(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 harvestedProtocolFeesBefore = getHarvestProtocolFees(siloAssetToken);
    SFSWithInterestWithInputs(f, siloAssetToken);
    uint256 harvestedProtocolFeesAfter = getHarvestProtocolFees(siloAssetToken);

    assert harvestedProtocolFeesBefore != harvestedProtocolFeesAfter =>
        f.selector == harvestProtocolFeesSig(),
        "harvestedProtocolFees changed as a result of function other than expected";
}

rule VC_Silo_protocolFees(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 protocolFeesBefore = getProtocolFees(siloAssetToken);
    SFSWithInterestWithInputs(f, siloAssetToken);
    uint256 protocolFeesAfter = getProtocolFees(siloAssetToken);

    assert protocolFeesBefore != protocolFeesAfter => (
            f.selector == depositSig() ||
            f.selector == depositForSig() ||
            f.selector == withdrawSig() ||
            f.selector == withdrawForSig() ||
            f.selector == repaySig() ||
            f.selector == repayForSig() ||
            f.selector == borrowSig() ||
            f.selector == borrowForSig() ||
            f.selector == accrueInterestSig() ||
            f.selector == flashLiquidateSig()
        ),
        "protocolFees changed as a result of function other than expected";
}

rule VC_Silo_interestRateTimestamp(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 timestampBefore = getAssetInterestDataTimeStamp(siloAssetToken);
    SFSWithInterestWithInputs(f, siloAssetToken);
    uint256 timestampAfter = getAssetInterestDataTimeStamp(siloAssetToken);

    assert timestampBefore != timestampAfter => (
            f.selector == depositSig() ||
            f.selector == depositForSig() ||
            f.selector == withdrawSig() ||
            f.selector == withdrawForSig() ||
            f.selector == repaySig() ||
            f.selector == repayForSig() ||
            f.selector == borrowSig() ||
            f.selector == borrowForSig() ||
            f.selector == accrueInterestSig() ||
            f.selector == flashLiquidateSig()
        ),
        "interestRateTimestamp changed as a result of function other than expected";
}

rule VC_Silo_asset_status(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    bool statusBefore = assetIsActive(siloAssetToken);
    SFSWithInterestWithInputs(f, siloAssetToken);
    bool statusAfter = assetIsActive(siloAssetToken);

    assert statusBefore != statusAfter =>
        (f.selector == initAssetsTokensSig() ||
        f.selector == syncBridgeAssetsSig()),
        "asset status changed as a result of function other than expected";
}

rule VC_Silo_shares_tokens_change(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    address collateralTokenBefore = getAssetCollateralToken(siloAssetToken);
    address collateralOnlyTokenBefore = getAssetCollateralOnlyToken(siloAssetToken);
    address debtTokenBefore = getAssetDebtToken(siloAssetToken);
    bool statusBefore = assetIsActive(siloAssetToken);

    SFSWithInterestWithInputs(f, siloAssetToken);

    address collateralTokenAfter = getAssetCollateralToken(siloAssetToken);
    address collateralOnlyTokenAfter = getAssetCollateralOnlyToken(siloAssetToken);
    address debtTokenAfter = getAssetDebtToken(siloAssetToken);

    assert (
                collateralTokenBefore != collateralTokenAfter &&
                collateralOnlyTokenBefore != collateralOnlyTokenAfter &&
                debtTokenBefore != debtTokenAfter
            ) => (
                (assetIsActive(siloAssetToken) && !statusBefore) &&
                f.selector == initAssetsTokensSig() ||
                f.selector == syncBridgeAssetsSig()
            ),
        "Shares address changed as a result of function other than expected";
}

rule VC_Silo_balance(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 balanceBefore = siloAssetToken.balanceOf(currentContract);

    uint256 cDepositsBefore = getAssetTotalDeposits(siloAssetToken);
    uint256 cTotalSupplyBefore = shareCollateralToken.totalSupply();

    uint256 coDepositsBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 coTotalSupplyBefore = shareCollateralOnlyToken.totalSupply();

     uint256 totalBorrowBefore = getAssetTotalBorrowAmount(siloAssetToken);
     uint256 sdTotalSupplyBefore = shareDebtToken.totalSupply();

    SFSWithInterestWithInputs(f, siloAssetToken);

    uint256 balanceAfter = siloAssetToken.balanceOf(currentContract);

    uint256 cDepositsAfter = getAssetTotalDeposits(siloAssetToken);
    uint256 cTotalSupplyAfter = shareCollateralToken.totalSupply();

    uint256 coDepositsAfter = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 coTotalSupplyAfter = shareCollateralOnlyToken.totalSupply();

     uint256 totalBorrowAfter = getAssetTotalBorrowAmount(siloAssetToken);
     uint256 sdTotalSupplyAfter = shareDebtToken.totalSupply();

    assert balanceBefore < balanceAfter => 
        (
            (
                (cDepositsBefore < cDepositsAfter && cTotalSupplyBefore < cTotalSupplyAfter) ||
                (coDepositsBefore < cDepositsAfter && coTotalSupplyBefore < cTotalSupplyAfter)
            ) &&
            f.selector == depositSig() ||
            f.selector == depositForSig()
        ) ||
        (
            (totalBorrowBefore > totalBorrowAfter && sdTotalSupplyBefore > sdTotalSupplyAfter) &&
            f.selector == repaySig() ||
            f.selector == repayForSig()
        ),
        "The silo balance increased by another method than expected";

    assert balanceBefore > balanceAfter =>
        (
            (
                (cDepositsBefore > cDepositsAfter && cTotalSupplyBefore > cTotalSupplyAfter) ||
                (coDepositsBefore > cDepositsAfter && coTotalSupplyBefore > cTotalSupplyAfter)
            ) &&
            f.selector == withdrawSig() ||
            f.selector == withdrawForSig() ||
            f.selector == flashLiquidateSig()
        ) ||
        (
            (totalBorrowBefore < totalBorrowAfter && sdTotalSupplyBefore < sdTotalSupplyAfter) &&
            f.selector == borrowSig() ||
            f.selector == borrowForSig()
        ) ||
        f.selector == harvestProtocolFeesSig(),
        "The silo balance decreased by another method than expected";
}
