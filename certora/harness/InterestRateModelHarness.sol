// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/InterestRateModelV2.sol";
import "../../contracts/lib/EasyMathV2.sol";

contract InterestRateModelHarness is InterestRateModelV2 {
    constructor(Config memory _config, address owner) InterestRateModelV2(_config, owner) {}

    function getUopt(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).uopt;
    }

    function getUcrit(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).ucrit;
    }

    function getUlow(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).ulow;
    }

    function getKi(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).ki;
    }

    function getKcrit(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).kcrit;
    }

    function getKlow(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).klow;
    }

    function getKlin(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).klin;
    }

    function getBeta(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).beta;
    }

    function getRi(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).ri;
    }

    function getTcrit(address _silo, address _asset) external view returns (int256) {
        return getConfig(_silo, _asset).Tcrit;
    }

    function maxHarness(int256 a, int256 b) external pure returns (int256) {
        return _max(a, b);
    }

    function minHarness(int256 a, int256 b) external pure returns (int256) {
        return _min(a, b);
    }

    // @dev arithmetic operations are moved from spec to harness method to increase performance 
    function rcurOldRcompBalancedHarness(
        Config memory _c,
        uint256 _totalDeposits,
        uint256 _totalBorrowAmount
    ) external pure returns (uint256 rcur, uint256 rcomp) {
        rcur = calculateCurrentInterestRate(_c, _totalDeposits, _totalBorrowAmount, 0, 0);
        (rcomp,,) = calculateCompoundInterestRate(_c, _totalDeposits, _totalBorrowAmount, 0, 1);
        if (rcomp == RCOMP_MAX) {
            revert("rCurRCompHarness: this method checks exponent behaviour that is below RCOMP_MAX");
        }
        rcomp = (rcomp + 1000) * 31536000;
    }

    // @dev arithmetic operations are moved from spec to harness method to increase performance 
    function rcurRcompBalancedHarness(
        Config memory _c,
        uint256 _totalDeposits,
        uint256 _totalBorrowAmount
    ) external pure returns (uint256 rcur, uint256 rcomp) {
        rcur = calculateCurrentInterestRate(_c, _totalDeposits, _totalBorrowAmount, 0, 1);
        (rcomp,,) = calculateCompoundInterestRate(_c, _totalDeposits, _totalBorrowAmount, 0, 1);
        if (rcomp == RCOMP_MAX) {
            revert("rCurRCompHarness: this method checks exponent behaviour that is below RCOMP_MAX");
        }
        rcomp = (rcomp + 1000) * 31536000;
    }

    function calculateUtilization(uint256 _totalDeposits, uint256 _totalBorrowAmount) public view returns (uint256) {
        int256 _DP = int256(DP); // solhint-disable-line var-name-mixedcase
        uint256 utilization = EasyMathV2.calculateUtilization(DP, _totalDeposits, _totalBorrowAmount);
        return utilization;
    }
}
