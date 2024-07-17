// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./ICurveLPTokensDetailsFetcher.sol";
import "../_common/CurveLPTokensDataTypes.sol";

/// @title Curve LP Tokens details fetchers repository
/// @dev Designed to unify an interface of the Curve pool tokens details getter,
/// such registries as Main Registry, CryptoSwap Registry,  Metapool Factory, and Cryptopool Factory
/// have different interfaces.
interface ICurveLPTokensDetailsFetchersRepository {
    /// @notice Emitted when Curve LP token fetcher added to the repository
    /// @param fetcher Added fetcher address
    event FetcherAdded(ICurveLPTokensDetailsFetcher indexed fetcher);

    /// @notice Emitted when Curve LP token fetcher removed from the repository
    /// @param fetcher Removed fetcher address
    event FetcherRemoved(ICurveLPTokensDetailsFetcher indexed fetcher);

    /// @notice Add Curve LP token details fetcher to the repository
    /// @param _fetcher A Curve LP token details fetcher to be added to the repository
    function addFetcher(ICurveLPTokensDetailsFetcher _fetcher) external;

    /// @notice Remove Curve LP token details fetcher from the repository
    /// @param _fetcher A Curve LP token details fetcher to be removed from the repository
    function removeFetcher(ICurveLPTokensDetailsFetcher _fetcher) external;

    /// @notice Curve LP Token details getter
    /// @param _lpToken Curve LP token address
    /// @param _data Any additional data that can be required
    /// @return details LP token details. See CurveLPTokensDataTypes.LPTokenDetails
    /// @return data Any additional data to return
    function getLPTokenDetails(
        address _lpToken,
        bytes memory _data
    )
        external
        view
        returns (
            LPTokenDetails memory details,
            bytes memory data
        );

    /// @return pool of the `_lpToken`
    function getLPTokenPool(address _lpToken) external view returns (address pool);

    /// @dev Returns a list of the registered fetchers
    function getFetchers() external view returns (address[] memory);

    /// @notice Helper method that allows easily detects, if contract is Curve Repository fetcher
    /// @return always curveLPTokensFetchersRepositoryPing.selector
    function curveLPTokensFetchersRepositoryPing() external pure returns (bytes4);
}
