// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../lib/Ping.sol";
import "../SiloV2.sol";
import "../interfaces/ISiloFactoryV2.sol";
import "../interfaces/ISiloRepository.sol";

/// @title SiloFactory
/// @notice Silo Factory has one job, deploy Silo implementation
/// @dev Silo Factory is registered within SiloRepository contract and it's given a version. Each version
/// is different Silo Factory that deploys different Silo implementation. Many Factory contracts can be
/// registered with the Repository contract.
/// @custom:security-contact security@silo.finance
contract SiloFactoryV2 is ISiloFactoryV2 {
    address public siloRepository;

    /// @dev Write info to the log about the Silo Repository initialization
    event InitSiloRepository();

    /// @dev Revert on a silo creation if a msg.sender is not a silo repository
    error OnlyRepository();
    /// @dev Revert on a false sanity check with `Ping` library
    error InvalidSiloRepository();

    /// @param _repository A silo repository address
    constructor(address _repository) {
        if (!Ping.pong(ISiloRepository(_repository).siloRepositoryPing)) {
            revert InvalidSiloRepository();
        }

        siloRepository = _repository;

        emit InitSiloRepository();
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

        silo = address(new SiloV2(ISiloRepository(msg.sender), _siloAsset, _version));
        emit NewSiloCreated(silo, _siloAsset, _version);
    }

    function siloFactoryPing() external pure virtual override returns (bytes4) {
        return this.siloFactoryPing.selector;
    }
}
