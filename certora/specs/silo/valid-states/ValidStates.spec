import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"

rule VS_Silo_totalDeposits_totalSupply(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    require getAssetTotalDeposits(siloAssetToken) == 0;
    require shareCollateralToken.totalSupply() == 0;

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalDeposits = getAssetTotalDeposits(siloAssetToken);
    uint256 totalSupply = shareCollateralToken.totalSupply();

    assert totalDeposits == 0 <=> totalSupply == 0,
        "Invalid state for totalDeposits and totalSupply";
}

rule VS_Silo_collateralOnlyDeposits_totalSupply(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    require getAssetCollateralOnlyDeposits(siloAssetToken) == 0;
    require shareCollateralOnlyToken.totalSupply() == 0;

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalDeposits = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupply = shareCollateralOnlyToken.totalSupply();

    assert totalDeposits == 0 <=> totalSupply == 0,
        "Invalid state for collateralOnlyDeposits and collateral only token totalSupply";
}

rule VS_Silo_totalBorrowAmount_totalSupply(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    require getAssetTotalBorrowAmount(siloAssetToken) == 0;
    require shareDebtToken.totalSupply() == 0;

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 totalBorrowed = getAssetTotalBorrowAmount(siloAssetToken);
    uint256 totalSupply = shareDebtToken.totalSupply();

    assert totalBorrowed == 0 <=> totalSupply == 0,
        "Invalid state for totalBorrowed and debt token totalSupply";
}

rule VS_Silo_lastTimestamp_protocolFees(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    require getProtocolFees(siloAssetToken) == 0;
    require getAssetInterestDataTimeStamp(siloAssetToken) == 0;

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 protocolFees = getProtocolFees(siloAssetToken);
    uint256 timestamp = getAssetInterestDataTimeStamp(siloAssetToken);

    assert protocolFees == 0 => timestamp == 0,
        "Invalid state for protocol fees and last timestamp";
}

rule VS_Silo_protocolFees(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    uint256 protocolFeesBefore = getProtocolFees(siloAssetToken);
    uint256 timestampBefore = getAssetInterestDataTimeStamp(siloAssetToken);
    uint256 totalDepositsBefore = getAssetTotalDeposits(siloAssetToken);

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    uint256 protocolFeesAfter = getProtocolFees(siloAssetToken);
    uint256 timestampAfter = getAssetInterestDataTimeStamp(siloAssetToken);
    uint256 totalDepositsAfter = getAssetTotalDeposits(siloAssetToken);

    assert protocolFeesBefore < protocolFeesAfter => (
            timestampBefore < timestampAfter
        ) || (
            f.selector != borrow(address, uint256).selector ||
            f.selector != borrowFor(address, address, address, uint256).selector
        ),
        "Invalid state for protocol fees and last timestamp";
}

rule VS_Silo_totalBorrowAmount(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    require getAssetTotalBorrowAmount(siloAssetToken) == 0;

    env e;

    require shareCollateralToken.balanceOf(e.msg.sender) == 0;
    require shareCollateralOnlyToken.balanceOf(e.msg.sender) == 0;

    require siloAssetToken.balanceOf(currentContract) == getAssetTotalDeposits(siloAssetToken);

    SFSWithoutInterestWithEnv(e, f, siloAssetToken);

    uint256 totalDeposits = getAssetTotalDeposits(siloAssetToken);
    uint256 totalBorrowed = getAssetTotalBorrowAmount(siloAssetToken);

    assert totalBorrowed != 0 => totalDeposits != 0,
        "Invalid state for totalBorrowed and totalDeposits";
}

rule VS_Silo_lastTimestamp_protocolFees_zero(method f) filtered { f -> !f.isView && !f.isFallback } {
    set_tokens();

    require getProtocolFees(siloAssetToken) == 0;
    require getAssetInterestDataTimeStamp(siloAssetToken) == 0;

    env e;
    SFSWithInputs(e, f, siloAssetToken);

    uint256 protocolFees = getProtocolFees(siloAssetToken);
    uint256 timestamp = getAssetInterestDataTimeStamp(siloAssetToken);

    assert protocolFees == 0 => timestamp == 0 || timestamp == e.block.timestamp,
        "Invalid state for protocolFees and timestamp";
}

rule VS_Silo_active_asset(method f) filtered { f -> !f.isView && !f.isFallback } {
    require getAssetCollateralToken(siloAssetToken) == 0;
    require getAssetCollateralOnlyToken(siloAssetToken) == 0;
    require getAssetDebtToken(siloAssetToken) == 0;
    require allSiloAssetsLength() < 1;
    uint256 currentAssetStatus = assetStatus(siloAssetToken);
    require currentAssetStatus == 0;

    SFSWithoutInterestWithInputs(f, siloAssetToken);

    address collateral = getAssetCollateralToken(siloAssetToken);
    address collateralOnlyToken = getAssetCollateralOnlyToken(siloAssetToken);
    address debt = getAssetDebtToken(siloAssetToken);
    bool assetStatus = assetIsActive(siloAssetToken);
    uint256 totalAssets = allSiloAssetsLength();

    assert assetStatus => collateral != 0 && collateralOnlyToken != 0 && debt != 0 && totalAssets > 0,
        "Invalid asset state";
}
