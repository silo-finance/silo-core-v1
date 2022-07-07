// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

import "./lib/PRBMathSD59x18.sol";
import "./lib/EasyMath.sol";
import "./interfaces/ISilo.sol";
import "./interfaces/IInterestRateModel.sol";
import "./utils/TwoStepOwnable.sol";

/// @title InterestRateModel
/// @notice Dynamic interest rate model implementation
/// @dev Model stores some Silo specific data. If model is replaced, it needs to set proper config after redeployment
/// for seamless service. Please refer to separte litepaper about model for design details.
/// @custom:security-contact security@silo.finance
contract InterestRateModel is IInterestRateModel, TwoStepOwnable {
    using PRBMathSD59x18 for int256;
    using SafeCast for int256;
    using SafeCast for uint256;

    /// @dev DP is 18 decimal points used for integer calculations
    uint256 public constant override DP = 1e18;

    /// @dev maximum value of compound interest the model will return
    uint256 public constant RCOMP_MAX = (2**128) * 1e18;

    /// @dev maximum value of X for which, RCOMP_MAX should be returned
    int256 public constant X_MAX = 88722839111672999627;

    // Silo => asset => ModelData
    mapping(address => mapping(address => Config)) public config;

    /// @notice Emitted on config change
    /// @param silo Silo address for which config should be set
    /// @param asset asset address for which config should be set
    /// @param config config struct for asset in Silo
    event ConfigUpdate(address indexed silo, address indexed asset, Config config);

    error InvalidBeta();
    error InvalidKcrit();
    error InvalidKi();
    error InvalidKlin();
    error InvalidKlow();
    error InvalidTcrit();
    error InvalidTimestamps();
    error InvalidUcrit();
    error InvalidUlow();
    error InvalidUopt();
    error InvalidRi();

    constructor(Config memory _config) {
        _setConfig(address(0), address(0), _config);
    }

    /// @inheritdoc IInterestRateModel
    function setConfig(address _silo, address _asset, Config calldata _config) external override onlyOwner {
        _setConfig(_silo, _asset, _config);
    }

    /// @inheritdoc IInterestRateModel
    function getCompoundInterestRateAndUpdate(
        address _asset,
        uint256 _blockTimestamp
    ) external override returns (uint256 rcomp) {
        // assume that caller is Silo
        address silo = msg.sender;

        ISilo.UtilizationData memory data = ISilo(silo).utilizationData(_asset);

        // TODO when depositing, we doing two calls for `calculateCompoundInterestRate`, maybe we can optimize?
        Config storage currentConfig = config[silo][_asset];
        (rcomp, currentConfig.ri, currentConfig.Tcrit) = calculateCompoundInterestRate(
            getConfig(silo, _asset),
            EasyMath.calculateUtilization(DP, data.totalDeposits, data.totalBorrowAmount).toInt256(),
            data.interestRateTimestamp,
            _blockTimestamp
        );
    }

    /// @inheritdoc IInterestRateModel
    function getCompoundInterestRate(
        address _silo,
        address _asset,
        uint256 _blockTimestamp
    ) external view override returns (uint256 rcomp) {
        ISilo.UtilizationData memory data = ISilo(_silo).utilizationData(_asset);

        (rcomp,,) = calculateCompoundInterestRate(
            getConfig(_silo, _asset),
            EasyMath.calculateUtilization(DP, data.totalDeposits, data.totalBorrowAmount).toInt256(),
            data.interestRateTimestamp,
            _blockTimestamp
        );
    }

    /// @inheritdoc IInterestRateModel
    function getCurrentInterestRate(
        address _silo,
        address _asset,
        uint256 _blockTimestamp
    ) external view override returns (uint256 rcur) {
        ISilo.UtilizationData memory data = ISilo(_silo).utilizationData(_asset);

        rcur = calculateCurrentInterestRate(
            getConfig(_silo, _asset),
            EasyMath.calculateUtilization(DP, data.totalDeposits, data.totalBorrowAmount).toInt256(),
            data.interestRateTimestamp,
            _blockTimestamp
        );
    }

    /// @inheritdoc IInterestRateModel
    function getConfig(address _silo, address _asset) public view override returns (Config memory) {
        Config storage currentConfig = config[_silo][_asset];

        if (currentConfig.uopt != 0) {
            return currentConfig;
        }

        // use default config
        Config memory c = config[address(0)][address(0)];

        // model data is always stored for each silo and asset so default values must be replaced
        c.ri = currentConfig.ri;
        c.Tcrit = currentConfig.Tcrit;
        return c;
    }

    /* solhint-disable */

    /// @inheritdoc IInterestRateModel
    function calculateCurrentInterestRate(
        Config memory _c,
        int256 _u,
        uint256 _interestRateTimestamp,
        uint256 _blockTimestamp
    ) public pure override returns (uint256 rcur) {
        if (_interestRateTimestamp > _blockTimestamp) revert InvalidTimestamps();

        int256 T;
        // There can't be an underflow in the subtraction because of the previous check
        unchecked {
            // T := t1 - t0 # length of time period in seconds
            T = (_blockTimestamp - _interestRateTimestamp).toInt256();
        }

        int256 _DP = int256(DP);

        int256 rp;
        if (_u > _c.ucrit) {
            // rp := kcrit *(1 + Tcrit + beta *T)*( u0 - ucrit )
            rp = _c.kcrit * (_DP + _c.Tcrit + _c.beta * T) / _DP * (_u - _c.ucrit) / _DP;
        } else {
            // rp := min (0, klow * (u0 - ulow ))
            rp = _min(0, _c.klow * (_u - _c.ulow) / _DP);
        }

        // rlin := klin * u0 # lower bound between t0 and t1
        int256 rlin = _c.klin * _u / _DP;
        // ri := max(ri , rlin )
        int256 ri = _max(_c.ri, rlin);
        // ri := max(ri + ki * (u0 - uopt ) * T, rlin )
        ri = _max(ri + _c.ki * (_u - _c.uopt) * T / _DP, rlin);
        // rcur := max (ri + rp , rlin ) # current per second interest rate
        rcur = (_max(ri + rp, rlin)).toUint256();
        rcur *= 365 days;
    }

    struct LocalVars {
        int256 T;
        int256 slopei;
        int256 rp;
        int256 slope;
        int256 r0;
        int256 rlin;
        int256 r1;
        int256 x;
        int256 rlin1;
        int256 rcomp;
    }

    function interestRateModelPing() external pure override returns (bytes4) {
        return this.interestRateModelPing.selector;
    }

    /// @inheritdoc IInterestRateModel
    function calculateCompoundInterestRate(
        Config memory _c,
        int256 _u,
        uint256 _interestRateTimestamp,
        uint256 _blockTimestamp
    ) public pure override returns (
        uint256 rcomp,
        int256 ri,
        int256 Tcrit
    ) {
        ri = _c.ri;
        Tcrit = _c.Tcrit;

        // struct for local vars to avoid "Stack too deep"
        LocalVars memory _l = LocalVars(0,0,0,0,0,0,0,0,0,0);

        if (_interestRateTimestamp > _blockTimestamp) revert InvalidTimestamps();

        // There can't be an underflow in the subtraction because of the previous check
        unchecked {
            // length of time period in seconds
            _l.T = (_blockTimestamp - _interestRateTimestamp).toInt256();
        }

        int256 _DP = int256(DP);

        // slopei := ki * (u0 - uopt )
        _l.slopei = _c.ki * (_u - _c.uopt) / _DP;

        if (_u > _c.ucrit) {
            // rp := kcrit * (1 + Tcrit) * (u0 - ucrit )
            _l.rp = _c.kcrit * (_DP + Tcrit) / _DP * (_u - _c.ucrit) / _DP;
            // slope := slopei + kcrit * beta * (u0 - ucrit )
            _l.slope = _l.slopei + _c.kcrit * _c.beta / _DP * (_u - _c.ucrit) / _DP;
            // Tcrit := Tcrit + beta * T
            Tcrit = Tcrit + _c.beta * _l.T;
        } else {
            // rp := min (0, klow * (u0 - ulow ))
            _l.rp = _min(0, _c.klow * (_u - _c.ulow) / _DP);
            // slope := slopei
            _l.slope = _l.slopei;
            // Tcrit := max (0, Tcrit - beta * T)
            Tcrit = _max(0, Tcrit - _c.beta * _l.T);
        }

        // rlin := klin * u0 # lower bound between t0 and t1
        _l.rlin = _c.klin * _u / _DP;
        // ri := max(ri , rlin )
        ri = _max(ri , _l.rlin);
        // r0 := ri + rp # interest rate at t0 ignoring lower bound
        _l.r0 = ri + _l.rp;
        // r1 := r0 + slope *T # what interest rate would be at t1 ignoring lower bound
        _l.r1 = _l.r0 + _l.slope * _l.T;

        // Calculating the compound interest

        if (_l.r0 >= _l.rlin && _l.r1 >= _l.rlin) {
            // lower bound isn’t activated
            // rcomp := exp (( r0 + r1) * T / 2) - 1
            _l.x = (_l.r0 + _l.r1) * _l.T / 2;
        } else if (_l.r0 < _l.rlin && _l.r1 < _l.rlin) {
            // lower bound is active during the whole time
            // rcomp := exp( rlin * T) - 1
            _l.x = _l.rlin * _l.T;
        } else if (_l.r0 >= _l.rlin && _l.r1 < _l.rlin) {
            // lower bound is active after some time
            // rcomp := exp( rlin *T - (r0 - rlin )^2/ slope /2) - 1
            _l.x = _l.rlin * _l.T - (_l.r0 - _l.rlin)**2 / _l.slope / 2;
        } else {
            // lower bound is active before some time
            // rcomp := exp( rlin *T + (r1 - rlin )^2/ slope /2) - 1
            _l.x = _l.rlin * _l.T + (_l.r1 - _l.rlin)**2 / _l.slope / 2;
        }

        if (_l.x >= X_MAX) {
            rcomp = RCOMP_MAX;
        } else {
            _l.rcomp = _l.x.exp() - _DP;
            rcomp = _l.rcomp > 0 ? _l.rcomp.toUint256() : 0;
        }

        // ri := max(ri + slopei * T, rlin )
        ri = _max(ri + _l.slopei * _l.T, _l.rlin);
    }

    /// @dev set config for silo and asset
    function _setConfig(address _silo, address _asset, Config memory _config) internal {
        int256 _DP = int256(DP);

        if (_config.uopt <= 0 || _config.uopt >= _DP) revert InvalidUopt();
        if (_config.ucrit <= _config.uopt || _config.ucrit >= _DP) revert InvalidUcrit();
        if (_config.ulow <= 0 || _config.ulow >= _config.uopt) revert InvalidUlow();
        if (_config.ki <= 0) revert InvalidKi();
        if (_config.kcrit <= 0) revert InvalidKcrit();
        if (_config.klow < 0) revert InvalidKlow();
        if (_config.klin < 0) revert InvalidKlin();
        if (_config.beta < 0) revert InvalidBeta();
        if (_config.ri < 0) revert InvalidRi();
        if (_config.Tcrit < 0) revert InvalidTcrit();

        config[_silo][_asset] = _config;
        emit ConfigUpdate(_silo, _asset, _config);
    }

    /* solhint-enable */

    /// @dev Returns the largest of two numbers
    function _max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /// @dev Returns the smallest of two numbers
    function _min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }
}
