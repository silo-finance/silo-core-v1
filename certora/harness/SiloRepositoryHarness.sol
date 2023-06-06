// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/SiloRepository.sol";

contract SiloRepositoryHarness is SiloRepository {
    constructor(
        address _siloFactory,
        address _tokensFactory,
        uint64 _defaultMaxLTV,
        uint64 _defaultLiquidationThreshold,
        address[] memory _initialBridgeAssets
     ) SiloRepository(_siloFactory, _tokensFactory, _defaultMaxLTV, _defaultLiquidationThreshold, _initialBridgeAssets) {}

    function getDefaultLiquidationThreshold() external view returns (uint64) {
        return defaultAssetConfig.liquidationThreshold;
    }

    function getDefaultMaxLoanToValue() external view returns (uint64) {
        return defaultAssetConfig.maxLoanToValue;
    }

    function getDefaultInterestRateModel() external view returns (address) {
        return address(defaultAssetConfig.interestRateModel);
    }

    function getDefaultSiloVersion() external view returns (uint128) {
        return siloVersion.byDefault;
    }

    function getLatestSiloVersion() external view returns (uint128) {
        return siloVersion.latest;
    }

    function solvencyPrecisionDecimals() external view returns (uint256) {
        return Solvency._PRECISION_DECIMALS;
    }

    function assetConfigLTVHarness(address silo, address asset) external view returns (uint64) {
        return assetConfigs[silo][asset].maxLoanToValue;
    }

    function assetConfigLiquidationThresholdHarness(address silo, address asset) external view returns (uint64) {
        return assetConfigs[silo][asset].liquidationThreshold;
    }

    function bridgeAssetsAmountHarness() external view returns (uint256) {
        address[] memory bridgeAssets = this.getBridgeAssets();
        return bridgeAssets.length;
    }

    function removedBridgeAssetsAmountHarness() external view returns (uint256) {
        address[] memory removedBridgeAssets = this.getRemovedBridgeAssets();
        return removedBridgeAssets.length;
    }

    function bridgeAssetsContainsHarness(address asset) external view returns (bool) {
        address[] memory bridgeAssets = this.getBridgeAssets();

        if (bridgeAssets.length > 3) {
            revert("Too many assets for unlooping");
        }

        if (bridgeAssets.length >= 1 && bridgeAssets[0] == asset) {
                return true;
        }

        if (bridgeAssets.length >= 2 && bridgeAssets[1] == asset) {
                return true;
        }

        if (bridgeAssets.length == 3 && bridgeAssets[2] == asset) {
                return true;
        }

        return false;
    }

    function removedBridgeAssetsContainsHarness(address asset) external view returns (bool) {
        address[] memory removedBridgeAssets = this.getRemovedBridgeAssets();

        if (removedBridgeAssets.length > 3) {
            revert("Too many assets for unlooping");
        }

        if (removedBridgeAssets.length >= 1 && removedBridgeAssets[0] == asset) {
                return true;
        }

        if (removedBridgeAssets.length >= 2 && removedBridgeAssets[1] == asset) {
                return true;
        }

        if (removedBridgeAssets.length == 3 && removedBridgeAssets[2] == asset) {
                return true;
        }

        return false;
    }

    function getBridgeAssetsHarness() external view returns (address[] memory) {
        return this.getBridgeAssets();
    }

    function getRemovedBridgeAssetsHarness() external view returns (address[] memory) {
        return this.getRemovedBridgeAssets();
    }

    function getBridgeAssetHarness(uint256 index) external view returns (address) {
        address[] memory bridgeAssets = this.getBridgeAssets();

        if (bridgeAssets.length >= index) {
            return address(0);
        }

        return bridgeAssets[index];
    }

    function getRemovedBridgeAssetHarness(uint256 index) external view returns (address) {
        address[] memory removedBridgeAssets = this.getRemovedBridgeAssets();

        if (removedBridgeAssets.length >= index) {
            return address(0);
        }

        return removedBridgeAssets[index];
    }
}
