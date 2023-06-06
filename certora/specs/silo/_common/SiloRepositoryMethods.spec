methods {
    createShareCollateralToken(string, string, address) => DISPATCHER(true)
    createShareDebtToken(string, string, address) => DISPATCHER(true)
    getNotificationReceiver(address) => DISPATCHER(false)
    siloRepository.getNotificationReceiver(address) returns address envfree
}
