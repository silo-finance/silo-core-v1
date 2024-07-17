// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface ICurveHackyPool {
    // We do not expect to write in the store on this call.
    // Our expectation is 1 sload operation for the `lock` status check + revert.
    // Because of it this function can be view which opens a possibility to do
    // a verification in the price provider on the `getPrice` fn execution.
    //  solhint-disable func-name-mixedcase
    function remove_liquidity(uint256 _tokenAmount, uint256[2] calldata _amounts) external view;
    function remove_liquidity(uint256 _tokenAmount, uint256[3] calldata _amounts) external view;
    function remove_liquidity(uint256 _tokenAmount, uint256[4] calldata _amounts) external view;
    function remove_liquidity(uint256 _tokenAmount, uint256[5] calldata _amounts) external view;
    function remove_liquidity(uint256 _tokenAmount, uint256[6] calldata _amounts) external view;
    function remove_liquidity(uint256 _tokenAmount, uint256[7] calldata _amounts) external view;
    function remove_liquidity(uint256 _tokenAmount, uint256[8] calldata _amounts) external view;
    //  solhint-enable func-name-mixedcase
}
