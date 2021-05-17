export enum AdminErrors {
  NotAdmin = "NOT_ADMIN",
}

export enum Erc20PermitErrors {
  Expired = "ERC20_PERMIT_EXPIRED",
  InvalidSignature = "ERC20_PERMIT_INVALID_SIGNATURE",
  OwnerZeroAddress = "ERC20_PERMIT_OWNER_ZERO_ADDRESS",
  RecoveredOwnerZeroAddress = "ERC20_PERMIT_RECOVERED_OWNER_ZERO_ADDRESS",
  SpenderZeroAddress = "ERC20_PERMIT_SPENDER_ZERO_ADDRESS",
}

export enum Erc20RecoverErrors {
  RecoverZero = "RECOVER_ZERO",
  RecoverNonRecoverableToken = "RECOVER_NON_RECOVERABLE_TOKEN",
}

export enum GenericErrors {
  Initialized = "INITALIZED",
  NotInitialized = "NOT_INITALIZED",
}
