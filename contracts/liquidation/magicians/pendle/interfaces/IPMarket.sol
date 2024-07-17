// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./IStandardizedYield.sol";
import "./IPPrincipalToken.sol";
import "./IPYieldToken.sol";

// solhint-disable var-name-mixedcase

interface IPMarket {
    function swapExactPtForSy(
        address receiver,
        uint256 exactPtIn,
        bytes calldata data
    ) external returns (uint256 netSyOut, uint256 netSyFee);

    function swapSyForExactPt(
        address receiver,
        uint256 exactPtOut,
        bytes calldata data
    ) external returns (uint256 netSyIn, uint256 netSyFee);

    function readTokens()
        external
        view
        returns (IStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT);
}
