// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../../lib/Ping.sol";
import "../../../interfaces/ISiloRepository.sol";
import "../../../interfaces/IConvexSiloWrapper.sol";
import "../../../interfaces/ISiloConvexStateChangesHandler.sol";
import "../../../interfaces/IConvexSiloWrapperFactory.sol";
import "../../../priceProviders/curveLPTokens/interfaces/ICurveLPTokensDetailsFetchersRepository.sol";

/// @dev `siloAsset` function is not defined in default Silo interface.
interface ISiloLike {
    function siloAsset() external returns (address);
}

/// @title SiloConvexStateChangesHandler is used in `SiloConvex` for checkpoints for users rewards.
///     This part of code can not be implemented in Silo code because of the smart contract bytecode limit.
contract SiloConvexStateChangesHandler is ISiloConvexStateChangesHandler {
    // solhint-disable-next-line var-name-mixedcase
    ISiloRepository public immutable SILO_REPOSITORY;

    // solhint-disable-next-line var-name-mixedcase
    ICurveLPTokensDetailsFetchersRepository public immutable FETCHERS_REPO;

    // solhint-disable-next-line var-name-mixedcase
    IConvexSiloWrapperFactory public immutable WRAPPER_FACTORY;

    /// @dev silo => wrapper cached data of Silo assets to reduce external calls.
    mapping(ISiloLike => IConvexSiloWrapper) public cachedSiloWrappers;

    error InvalidConvexSiloWrapperFactory();
    error InvalidFetchersRepo();
    error InvalidRepository();
    error OnlySilo();

    modifier onlySilo() {
        if (!SILO_REPOSITORY.isSilo(msg.sender)) revert OnlySilo();
        _;
    }

    constructor (
        ISiloRepository _repository,
        ICurveLPTokensDetailsFetchersRepository _fetchersRepo,
        IConvexSiloWrapperFactory _wrapperFactory
    ) {
        if (!Ping.pong(_repository.siloRepositoryPing)) {
            revert InvalidRepository();
        }

        if (!Ping.pong(_fetchersRepo.curveLPTokensFetchersRepositoryPing)) {
            revert InvalidFetchersRepo();
        }

        if (!Ping.pong(_wrapperFactory.convexSiloWrapperFactoryPing)) {
            revert InvalidConvexSiloWrapperFactory();
        }

        SILO_REPOSITORY = _repository;
        FETCHERS_REPO = _fetchersRepo;
        WRAPPER_FACTORY = _wrapperFactory;
    }

    /// @inheritdoc ISiloConvexStateChangesHandler
    function beforeBalanceUpdate(address _firstToCheckpoint, address _secondToCheckpoint)
        external
        virtual
        override
        onlySilo
    {
        IConvexSiloWrapper _wrapper = cachedSiloWrappers[ISiloLike(msg.sender)];

        if (address(_wrapper) == address(0)) {
            _wrapper = IConvexSiloWrapper(ISiloLike(msg.sender).siloAsset());
            cachedSiloWrappers[ISiloLike(msg.sender)] = _wrapper;
        }

        _wrapper.checkpointPair(_firstToCheckpoint, _secondToCheckpoint);
    }

    /// @inheritdoc ISiloConvexStateChangesHandler
    function wrapperSetupVerification(address _wrapper) external view virtual override returns (bool) {
        if (!WRAPPER_FACTORY.isWrapper(_wrapper)) return false;

        address underlyingToken = IConvexSiloWrapper(_wrapper).underlyingToken();
        address assetPool = FETCHERS_REPO.getLPTokenPool(underlyingToken);

        return assetPool != address(0);
    }
}
