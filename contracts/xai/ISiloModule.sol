// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ISiloModule {
    event SiloModuleWithdraw(address silo, uint256 xaiAmount);

    function deposit(address silo, uint256 xaiAmount) external;
    function withdrawAll(address _silo) external;
    function withdrawFromDeposits(address _silo, uint256 _xaiAmount) external;
    function withdraw(address silo, uint256 xaiAmount) external;
    function transfer(address _to, uint256 _xaiAmount) external;
    function transferOwnership(address newOwner) external;
    function withdrawRevenue(address _silo) external;

    function availableXai(address silo) external view returns (uint256);
    function deposited(address silo) external view returns (uint256);
}
