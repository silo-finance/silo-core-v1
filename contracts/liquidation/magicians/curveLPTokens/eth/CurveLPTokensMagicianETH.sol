// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../../interfaces/ICurvePoolLike.sol";
import "../../interfaces/ICurveLPTokensPriceProviderLike.sol";
import "../../../../interfaces/IPriceProvidersRepository.sol";
import "../../../../priceProviders/curveLPTokens/interfaces/ICurveLPTokensDetailsFetchersRepository.sol";

import "../CurveLPTokensMagician.sol";
import "../../interfaces/IWETH9Like.sol";

/// @dev Curve LP Tokens unwrapping
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
abstract contract CurveLPTokensMagicianETH is CurveLPTokensMagician {
    address public immutable NULL_ADDRESS; // solhint-disable-line var-name-mixedcase
    address public immutable WETH; // solhint-disable-line var-name-mixedcase

    constructor(
        ICurveLPTokensDetailsFetchersRepository _fetcherRepository,
        IPriceProvidersRepository _priceProvidersRepository,
        address _weth,
        address _nullAddress
    )
        CurveLPTokensMagician(_fetcherRepository, _priceProvidersRepository)
    {
        WETH = _weth;
        NULL_ADDRESS = _nullAddress;
    }

    /// @notice Reviews a `tokenOut`. If it is the `NULL_ADDRESS`, wraps ETH
    /// @param _tokenOut A token that the `_asset` in the `towardsNative` function was converted
    /// @param _withdrawn amount of the `_tokenOut` that we received
    /// @return tokenOut a token that we received
    function _reviewTokenOut(
        address _tokenOut,
        uint256 _withdrawn
    )
        internal
        virtual
        returns (address tokenOut)
    {
        // `tokenOut` should change only in the case with the `NULL_ADDRESS`
        tokenOut = _tokenOut;

        if (tokenOut == NULL_ADDRESS || (tokenOut == WETH && address(this).balance == _withdrawn)) {
            // Wrap ETH
            IWETH9Like(WETH).deposit{value: _withdrawn}();
            tokenOut = WETH;
        }
    }

    function _getCurvePoolUnderlyingCoin(address[] memory _coins) internal override view returns (address, uint256) {
        if (_coins.length == 0) revert InvalidCurvePriceProviderLPTokenPair();

        // if one of the pool underlying coins is the same as quote token or a null address
        // we must return it. The operation will be similar to swap.
        // Otherwise we need to unwrap LP token, so we return _coins[0] and an index 0
        for (uint256 i; i < _coins.length;) {
            if (QUOTE_TOKEN == _coins[i]) {
                return (QUOTE_TOKEN, i);
            }

            if (NULL_ADDRESS == _coins[i]) {
                return (NULL_ADDRESS, i);
            }

            // Because of the condition, `i < coins.length` overflow is impossible
            unchecked { i++; }
        }

        uint256 zeroIndex = 0;
        return (_coins[0], zeroIndex);
    }
}
