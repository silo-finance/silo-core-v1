# Properties of Guarded Launch

## Types of Properties

- Variable Changes
- Unit Tests
- Risk assessment

### Variable Changes

- maxLiquidity.globalLimit can only change on setLimitedMaxLiquidity() call. globalLimit changed => f.selector == setLimitedMaxLiquidity.\
  Implementation: rule `VC_GuardedLaunch_globalLimit`

- maxLiquidity.defaultMaxLiquidity can only change on setDefaultSiloMaxDepositsLimit() call. defaultMaxLiquidity changed => f.selector == setDefaultSiloMaxDepositsLimit.\
  Implementation: rule `VC_GuardedLaunch_defaultMaxLiquidity`

- For every Silo and it's every asset siloMaxLiquidity can only change on setSiloMaxDepositsLimit() call. SiloMaxLiquidity changed => f.selector == setSiloMaxDepositsLimit.\
  Implementation: rule `VC_GuardedLaunch_siloMaxLiquidity`

- GlobalPause can only change on setGlobalPause() call. GlobalPause changed => f.selector == setGlobalPause.\
  Implementation: rule `VC_GuardedLaunch_globalPause`

- For every Silo and it's asset siloPause can only change on setSiloPause() call. SiloPause changed => f.selector == setSiloPause.\
  Implementation: rule `VC_GuardedLaunch_siloPause`

### Unit Tests

- Only Manager can call setLimitedMaxLiquidity().\
  Implementation: rule `UT_GuardedLaunch_setLimitedMaxLiquidity_onlyManager`

- Only Manager can call setDefaultSiloMaxDepositsLimit().\
  Implementation: rule `UT_GuardedLaunch_setDefaultSiloMaxDepositsLimit_onlyManager`

- Only Manager can call setSiloMaxDepositsLimit().\
  Implementation: rule `UT_GuardedLaunch_setSiloMaxDepositsLimit_onlyManager`

- Only Manager can call setGlobalPause().\
  Implementation: rule `UT_GuardedLaunch_setGlobalPause_onlyManager`

- Only Manager can call setSiloPause().\
  Implementation: rule `UT_GuardedLaunch_setSiloPause_onlyManager`

### Risk assessment

- For any silo and any asset we must be sure that after it was paused we can unpause it.\
  Implementation: rule `RA_GuardedLaunch_Silo_pause_unpause`

- If system been paused we must be sure that we can unpause it.\
  Implementation: rule `RA_GuardedLaunch_Global_pause_unpause`
