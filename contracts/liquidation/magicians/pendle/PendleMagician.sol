// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./interfaces/IStandardizedYield.sol";
import "./interfaces/IPPrincipalToken.sol";
import "./interfaces/IPYieldToken.sol";
import "./interfaces/IPMarket.sol";

abstract contract PendleMagician {
    // solhint-disable
    address public immutable PENDLE_TOKEN;
    address public immutable PENDLE_MARKET;
    // solhint-enable

    bytes internal constant _EMPTY_BYTES = abi.encode();

    error InvalidAsset();
    error Unsupported();

    constructor(address _asset, address _market) {
        PENDLE_TOKEN = _asset;
        PENDLE_MARKET = _market;
    }

    function _sellPtForUnderlying(uint256 _netPtIn, address _tokenOut) internal returns (uint256 netTokenOut) {
        // solhint-disable-next-line var-name-mixedcase
        (IStandardizedYield SY, IPPrincipalToken PT, IPYieldToken YT) = IPMarket(PENDLE_MARKET)
            .readTokens();

        uint256 netSyOut;
        if (PT.isExpired()) {
            PT.transfer(address(YT), _netPtIn);
            netSyOut = YT.redeemPY(address(SY));
        } else {
            // safeTransfer not required
            PT.transfer(PENDLE_MARKET, _netPtIn);
            (netSyOut, ) = IPMarket(PENDLE_MARKET).swapExactPtForSy(
                address(SY), // better gas optimization to transfer SY directly to itself and burn
                _netPtIn,
                _EMPTY_BYTES
            );
        }

        // solhint-disable-next-line func-named-parameters
        netTokenOut = SY.redeem(address(this), netSyOut, _tokenOut, 0, true);
    }
}
