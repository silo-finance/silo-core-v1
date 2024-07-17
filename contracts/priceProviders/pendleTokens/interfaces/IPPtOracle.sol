// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface IPPtOracle {
    event SetBlockCycleNumerator(uint16 newBlockCycleNumerator);

    function getPtToAssetRate(
        address market,
        uint32 duration
    ) external view returns (uint256 ptToAssetRate);

    function getPtToSyRate(
        address market,
        uint32 duration
    ) external view returns (uint256 ptToAssetRate);

    function getOracleState(
        address market,
        uint32 duration
    )
        external
        view
        returns (
            bool increaseCardinalityRequired,
            uint16 cardinalityRequired,
            bool oldestObservationSatisfied
        );
}
