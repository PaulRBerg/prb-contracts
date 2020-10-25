export enum AdminErrors {
  NotAdmin = "ERR_NOT_ADMIN",
}

export enum Erc20PermitErrors {
  Expired = "ERR_ERC20_PERMIT_EXPIRED",
  InvalidSignature = "ERR_ERC20_PERMIT_INVALID_SIGNATURE",
  OwnerZeroAddress = "ERR_ERC20_PERMIT_OWNER_ZERO_ADDRESS",
  RecoveredOwnerZeroAddress = "ERR_ERC20_PERMIT_RECOVERED_OWNER_ZERO_ADDRESS",
  SpenderZeroAddress = "ERR_ERC20_PERMIT_SPENDER_ZERO_ADDRESS",
}

export enum Erc20RecoverErrors {
  RecoverZero = "ERR_RECOVER_ZERO",
  RecoverNonRecoverableToken = "ERR_RECOVER_NON_RECOVERABLE_TOKEN",
}

export enum GenericErrors {
  Initialized = "ERR_INITALIZED",
  NotInitialized = "ERR_NOT_INITALIZED",
}
