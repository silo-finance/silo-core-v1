// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/Silo.sol";
import "../../contracts/interfaces/IBaseSilo.sol";

contract SiloHarness is Silo {
    constructor (ISiloRepository _repository, address _siloAsset, uint128 _version)
        Silo(_repository, _siloAsset, _version) {}

    function getAssetInterestDataTimeStamp(address asset) external view returns (uint64) {
        return IBaseSilo(address(this)).interestData(asset).interestRateTimestamp;
    }

    function getProtocolFees(address asset) external view returns (uint256) {
        return IBaseSilo(address(this)).interestData(asset).protocolFees;
    }

    function assetIsActive(address asset) external view returns (bool) {
        return IBaseSilo(address(this)).interestData(asset).status == AssetStatus.Active;
    }

    function assetStatus(address asset) external view returns (uint256) {
        return uint256(IBaseSilo(address(this)).interestData(asset).status);
    }

    function getHarvestProtocolFees(address asset) external view returns (uint256) {
        return IBaseSilo(address(this)).interestData(asset).harvestedProtocolFees;
    }

    function getAssetCollateralToken(address asset) external view returns (address) {
        return address(IBaseSilo(address(this)).assetStorage(asset).collateralToken);
    }
    
    function getAssetDebtToken(address asset) external view returns (address) {
        return address(IBaseSilo(address(this)).assetStorage(asset).debtToken);
    }
    
    function getAssetCollateralOnlyToken(address asset) external view returns (address) {
        return address(IBaseSilo(address(this)).assetStorage(asset).collateralOnlyToken);
    }

    function getAssetTotalDeposits(address asset) external view returns (uint256) {
        return IBaseSilo(address(this)).assetStorage(asset).totalDeposits;
    }

    function getAssetCollateralOnlyDeposits(address asset) external view returns (uint256) {
        return IBaseSilo(address(this)).assetStorage(asset).collateralOnlyDeposits;
    }

    function getAssetTotalBorrowAmount(address asset) external view returns (uint256) {
        return IBaseSilo(address(this)).assetStorage(asset).totalBorrowAmount;
    }

    function allSiloAssetsLength() external view returns (uint256) {
        return IBaseSilo(address(this)).getAssets().length;
    }
}
