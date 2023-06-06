// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/utils/GuardedLaunch.sol";

contract GuardedLaunchHarness is GuardedLaunch {
    function getGlobalLimit() external view returns (bool) {
        return maxLiquidity.globalLimit;
    }

    function getDefaultMaxLiquidity() external view returns (uint256) {
        return maxLiquidity.defaultMaxLiquidity;
    }

    function getSiloMaxLiquidity(address silo, address asset) external view returns (uint256) {
        return maxLiquidity.siloMaxLiquidity[silo][asset];
    }

    function getGlobalPause() external view returns (bool) {
        return isPaused.globalPause;
    }

    function getSiloPause(address silo, address asset) external view returns (bool) {
        return isPaused.siloPause[silo][asset];
    }
}
