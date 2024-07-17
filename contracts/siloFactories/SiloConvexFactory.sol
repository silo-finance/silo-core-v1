// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../SiloConvex.sol";
import "./SiloFactoryV2.sol";

/// @title SiloConvexFactory
/// @notice Silo Factory has one job, deploy Silo implementation
/// @dev Silo Factory is registered within SiloRepository contract and it's given a version. Each version
/// is different Silo Factory that deploys different Silo implementation. Many Factory contracts can be
/// registered with the Repository contract.
/// @custom:security-contact security@silo.finance
contract SiloConvexFactory is SiloFactoryV2 {
    // solhint-disable-next-line var-name-mixedcase
    ISiloConvexStateChangesHandler internal immutable _STATE_CHANGES_HANDLER;

    /// @param _repository A silo repository address
    constructor(
        address _repository,
        ISiloConvexStateChangesHandler _stateChangesHandler
    ) SiloFactoryV2(_repository) {
        // Ping library call is not possible here, because the contract will exceed the gas limit.
        _STATE_CHANGES_HANDLER = _stateChangesHandler;
    }

    /// @inheritdoc ISiloFactoryV2
    function createSilo(
        address _siloAsset,
        uint128 _version,
        bytes memory
    )
        external
        virtual
        override
        returns (address silo)
    {
        // Only allow silo repository
        if (msg.sender != siloRepository) revert OnlyRepository();

        silo = address(new SiloConvex(
            ISiloRepository(msg.sender),
            _STATE_CHANGES_HANDLER,
            _siloAsset,
            _version
        ));

        emit NewSiloCreated(silo, _siloAsset, _version);
    }
}
