// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../interfaces/IInterestRateModel.sol";
import "../interfaces/ISilo.sol";
import "../lib/Ping.sol";
import "../SiloLens.sol";

contract InterestRateDataResolver {
    ISiloRepository immutable public siloRepository;
    SiloLens public immutable lens;

    error InvalidSiloLens();
    error InvalidSiloRepository();
    error DifferentArrayLength();

    constructor (ISiloRepository _siloRepo, SiloLens _lens) {
        if (!Ping.pong(_siloRepo.siloRepositoryPing)) revert InvalidSiloRepository();
        if (!Ping.pong(_lens.lensPing)) revert InvalidSiloLens();

        siloRepository = _siloRepo;
        lens = _lens;
    }


    /// @dev batch method for `getData()`
    function getDataBatch(ISilo[] calldata _silos, address[] calldata _assets)
        external
        view
        returns (
            IInterestRateModel.Config[] memory modelConfigs,
            uint256[] memory currentInterestRates,
            uint256[] memory siloUtilizations,
            uint256[] memory totalDepositsWithInterest
        )
    {
        if (_silos.length != _assets.length) revert DifferentArrayLength();

        modelConfigs = new IInterestRateModel.Config[](_silos.length);
        currentInterestRates = new uint256[](_silos.length);
        siloUtilizations = new uint256[](_silos.length);
        totalDepositsWithInterest = new uint256[](_silos.length);

        unchecked {
            for(uint256 i; i < _silos.length; i++) {
                (
                modelConfigs[i],
                currentInterestRates[i],
                siloUtilizations[i],
                totalDepositsWithInterest[i]
                ) = getData(_silos[i], _assets[i]);
            }
        }
    }

    function getModel(ISilo _silo, address _asset) public view returns (IInterestRateModel) {
        return IInterestRateModel(siloRepository.getInterestRateModel(address(_silo), _asset));
    }

    /// @dev pulls all data required for bot that collect interest rate model data for researchers
    function getData(ISilo _silo, address _asset)
        public
        view
        returns (
            IInterestRateModel.Config memory modelConfig,
            uint256 currentInterestRate,
            uint256 siloUtilization,
            uint256 totalDepositsWithInterest
        )
    {
        IInterestRateModel model = getModel(_silo, _asset);

        modelConfig = model.getConfig(address(_silo), _asset);
        currentInterestRate = model.getCurrentInterestRate(address(_silo), _asset, block.timestamp);
        siloUtilization = lens.getUtilization(_silo, _asset);
        totalDepositsWithInterest = lens.totalDepositsWithInterest(_silo, _asset);
    }
}
