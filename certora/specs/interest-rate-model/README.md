# Properties of Interest Rate Model

## Types of Properties

- Valid States
- Variable Changes
- Unit Tests
- High level properties

### Valid States

- Decimal points is 10^18 and can not be changed.\
  Implementation: rule `VS_DP`

- RCOMP_MAX is equal to (2^16) * 10^18 and can not be changed.\
  Implementation: rule `VS_RCOMP_MAX`
  
- ASSET_DATA_OVERFLOW_LIMIT is equal to (2^196) and can not be changed.\
  Implementation: rule `VS_ASSET_DATA_OVERFLOW_LIMIT`

- X_MAX is equal to 11090370147631773313 (X_MAX ≈ ln(RCOMP_MAX + 1)) and can not be changed.\
  Implementation: rule `VS_X_MAX`

- For every Silo and every asset Config.uopt ∈ (0, 10^18) in DP.\
  Implementation: rule `VS_uopt`

- For every Silo and every asset Config.ucrit ∈ (uopt, 10^18) in DP.\
  Implementation: rule `VS_ucrit`

- For every Silo and every asset Config.ulow ∈ (0, uopt) in DP.\
  Implementation: rule `VS_ulow`

- For every Silo and every asset Config.ki > 0 (integrator gain).\
  Implementation: rule `VS_ki`

- For every Silo and every asset Config.kcrit > 0 (proportional gain for large utilization).\
  Implementation: rule `VS_kcrit`

- For every Silo and every asset Config.klow ≥ 0 (proportional gain for low utilization).\
  Implementation: rule `VS_klow`

- For every Silo and every asset Config.klin ≥ 0 (coefficient of the lower linear bound).\
  Implementation: rule `VS_klin`

- For every Silo and every asset Config.beta ≥ 0.\
  Implementation: rule `VS_beta`

- For every Silo and every asset Config.ri ≥ 0.\
  Implementation: rule `VS_complexInvariant_ri`

- For every Silo and every asset Config.tcrit ≥ 0.\
  Implementation: rule `VS_complexInvariant_tcrit`

### Variable Changes

- Config.uopt can be set only by setConfig. ∀ Silo ∀ Asset ((uopt changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_uoptChangedOnlyOwner`

- Config.ucrit can be set only by setConfig. ∀ Silo ∀ Asset ((ucrit changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_ucritChangedOnlyOwner`

- Config.ulow can be set only by setConfig. ∀ Silo ∀ Asset ((ulow changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_ulowChangedOnlyOwner`

- Config.ki can be set only by setConfig. ∀ Silo ∀ Asset ((ki changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_kiChangedOnlyOwner`

- Config.kcrit can be set only by setConfig. ∀ Silo ∀ Asset ((kcrit changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_kcritChangedOnlyOwner`

- Config.klow can be set only by setConfig. ∀ Silo ∀ Asset ((klow changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_klowChangedOnlyOwner`

- Config.klin can be set only by setConfig. ∀ Silo ∀ Asset ((klin changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_klinChangedOnlyOwner`

- Config.beta can be set only by setConfig. ∀ Silo ∀ Asset ((beta changed) <=> (f.selector == setConfig && msg.sender == owner)).\
  Implementation: rule `VCH_betaChangedOnlyOwner`

- Config.ri can be set only by setConfig or by getCompoundInterestRateAndUpdate. ∀ Silo ∀ Asset ((ri changed) <=> (f.selector == setConfig && msg.sender == owner || f.selector == getCompoundInterestRateAndUpdate && msg.sender == silo)).\
  Implementation: rule `VCH_riChangedOnlyOwnerOrInterestUpdate`

- Config.tcrit can be set only by setConfig or by getCompoundInterestRateAndUpdate. ∀ Silo ∀ Asset ((tcrit changed) <=> (f.selector == setConfig && msg.sender == owner || f.selector == getCompoundInterestRateAndUpdate && msg.sender == silo)).\
  Implementation: rule `VCH_tcritChangedOnlyOwnerOrInterestUpdate`

### Unit Tests

- Only owner can call setConfig. (f call was without revert) && (f.selector == setConfig) => msg.sender == owner().\
  Implementation: rule `UT_onlyOwnerSetConfig`

- CalculateCompoundInterestRate. Proved with rcomp overflow cases excluded. `tcrit` and `ri` were in a state before function call. Utilisation before the call was `u`. `tcritNew`, `riNew` and `rcomp` are the return values.
  - Assert (u > Config.ucrit && Config.beta != 0) <=> (tcritNew > tcrit).
  - Assert (u > Config.uopt) => (riNew >= ri).
  - Assert (u > Config.uopt) && (ri <= Config.klin * u / DP()) => (riNew >= Config.klin * u / DP()).
  - Assert (u == Config.uopt) && (ri < Config.klin * u / DP()) => (riNew == Config.klin * u / DP()).
  - Assert (u == Config.uopt) && (ri >= Config.klin * u / DP()) => (riNew == ri).
  - Assert (u <= Config.uopt) && (ri <= Config.klin * u / DP()) => (riNew == Config.klin * u / DP()).
  - Assert (u < Config.uopt) && (ri > Config.klin * u / DP()) => (riNew <= ri) && (riNew >= Config.klin * u / DP()).\
  Implementation: rule `UT_calculateCompoundInterestRate_*`

- GetCurrentInterestRate. Proved with rcomp overflow cases excluded. For two consecutive block timestamps `tNew > tOld`. Let `uOld` is utilisation ratio at `tOld` timestamp, `rCurOld` is current interest rate at `tOld`. Let `uNew` is utilisation ratio at `tNew` timestamp, `rCurNew` is current interest rate at `tNew`.
  - Assert (uOld < uNew) && (rCurOld <= Config.klin * uOld / DP()) => (rCurNew >= rCurOld).
  - Assert (uOld > Config.uopt && uNew > uOld) => (rCurNew >= rCurOld).
  - Assert (uOld >= uNew) && (rCurNew > rCurOld) => (uOld >= Config.uopt).
  - Assert (rCurNew == 0) => (u * Config.klin / DP() == 0).\
  Implementation: rule `UT_calculateCurrentInterestRate_*`

- Max. a >= b <=> max(a, b) returns a.\
  Implementation: rule `UT_max`

- Min. a <= b <=> min(a, b) returns a.\
  Implementation: rule `UT_min`

### High level properties
High level properties are proved with overflow cases excluded. These properties require significant time, memory and CPU resources. Rules were proven with new Certora fuzzy mining feature to solve 2 hours timeout problem.

- `rComp` is the current output of getCompoundInterestRate, `rCurNew` is the current interest rate, `uNew` is the current utilisation ratio, `T` is the difference of the last interest rate update timestamp and current timestamp. Assert (u <= Config.uopt) => (rComp >= rCurNew * T).\
  Implementation: rule `PMTH_compoundAndCurrentInterest_uGreaterUopt`

- `rComp` is the current output of getCompoundInterestRate, `rCurOld` is the interest rate on the last interest rate update timestamp, `uNew` is the current utilisation ratio, `T` is the difference of the last interest rate update timestamp and current timestamp. Assert (u >= Config.uopt) => (rComp >= rCurOld * T).\
  Implementation: rule `PMTH_compoundAndCurrentInterest_uLessUopt`
