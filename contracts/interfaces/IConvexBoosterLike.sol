// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface IConvexBoosterLike {
    struct PoolInfo {
        address lptoken;
        address token;
        address gauge;
        address crvRewards;
        address stash;
        bool shutdown;
    }

    function poolInfo(uint256 pid) external view returns (PoolInfo memory);
    function poolLength() external view returns (uint256);
}
