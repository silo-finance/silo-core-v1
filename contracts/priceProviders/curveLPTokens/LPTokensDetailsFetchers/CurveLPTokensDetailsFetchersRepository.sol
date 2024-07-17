// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "../interfaces/ICurveLPTokensDetailsFetchersRepository.sol";
import "../../_common/PriceProvidersRepositoryManager.sol";
import "../../../lib/Ping.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve LP Tokens details fetchers repository
/// @dev For more info about Curve LP Tokens details fetchers see ICurveLPTokensDetailsFetcher
contract CurveLPTokensDetailsFetchersRepository is
    ICurveLPTokensDetailsFetchersRepository,
    PriceProvidersRepositoryManager
{
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @dev Curve LP Tokens details fetchers set
    EnumerableSet.AddressSet internal _fetchers;

    /// @dev Revert if Curve LP Tokens details fetcher is already added to the set
    error FetcherAlreadyAdded();
    /// @dev Revert if Curve LP Tokens details fetcher is not registered in the repository
    error FetcherIsNotRegistered();
    /// @dev Revert on a false sanity check with `Ping` library for a fetcher
    error InvalidFetcher();

    /// @dev Constructor is required for indirect PriceProvidersRepositoryManager initialization.
    /// Arguments for PriceProvidersRepositoryManager initialization are given in the modifier-style
    /// in the derived constructor.
    /// CurveLPTokensDetailsFetchersRepository constructor body should be empty as we need to do nothing.
    /// @param _repository Price providers repository address
    constructor(IPriceProvidersRepository _repository) PriceProvidersRepositoryManager(_repository) {
        // The code will not compile without it. So, we need to keep an empty constructor.
    }

    /// @inheritdoc ICurveLPTokensDetailsFetchersRepository
    function addFetcher(ICurveLPTokensDetailsFetcher _fetcher) external virtual onlyManager() {
        if (!Ping.pong(_fetcher.curveLPTokensDetailsFetcherPing)) revert InvalidFetcher();
        if (!_fetchers.add(address(_fetcher))) revert FetcherAlreadyAdded();

        emit FetcherAdded(_fetcher);
    }

    /// @inheritdoc ICurveLPTokensDetailsFetchersRepository
    function removeFetcher(ICurveLPTokensDetailsFetcher _fetcher) external virtual onlyManager() {
        if (!_fetchers.remove(address(_fetcher))) revert FetcherIsNotRegistered();

        emit FetcherRemoved(_fetcher);
    }

    /// @inheritdoc ICurveLPTokensDetailsFetchersRepository
    function getLPTokenDetails(
        address _lpToken,
        bytes memory _data
    )
        external
        virtual
        view
        returns (
            LPTokenDetails memory details,
            bytes memory data
        )
    {
        uint256 i = 0;
        uint256 numberOfFetchers = _fetchers.length();

        while(i < numberOfFetchers) {
            ICurveLPTokensDetailsFetcher fetcher = ICurveLPTokensDetailsFetcher(_fetchers.at(i));

            (details, data) = fetcher.getLPTokenDetails(_lpToken, _data);

            // Assume that if a pool address is not address(0), we are done
            if (details.pool.addr != address(0)) {
                return (details, data);
            }

            // variables 'i' and 'numberOfFetchers' have the same data type,
            // so due to condition (i < numberOfFetchers) overflow is impossible.
            unchecked { i++; }
        }
    }

    /// @return pool of the `_lpToken`
    function getLPTokenPool(address _lpToken) external view returns (address pool) {
        uint256 i = 0;
        bytes memory data;
        LPTokenDetails memory details;
        uint256 numberOfFetchers = _fetchers.length();

        while(i < numberOfFetchers) {
            ICurveLPTokensDetailsFetcher fetcher = ICurveLPTokensDetailsFetcher(_fetchers.at(i));

            (details, data) = fetcher.getLPTokenDetails(_lpToken, data);

            // Assume that if a pool address is not address(0), we are done
            if (details.pool.addr != address(0)) {
                return details.pool.addr;
            }

            // variables 'i' and 'numberOfFetchers' have the same data type,
            // so due to condition (i < numberOfFetchers) overflow is impossible.
            unchecked { i++; }
        }
    }

    /// @inheritdoc ICurveLPTokensDetailsFetchersRepository
    function getFetchers() external virtual view returns (address[] memory) {
        return _fetchers.values();
    }

    /// @inheritdoc ICurveLPTokensDetailsFetchersRepository
    function curveLPTokensFetchersRepositoryPing() external virtual pure returns (bytes4) {
        return this.curveLPTokensFetchersRepositoryPing.selector;
    }
}
