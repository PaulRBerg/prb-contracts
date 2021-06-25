export enum Erc20PermitErrors {
  InvalidSignature = "InvalidSignature",
  OwnerZeroAddress = "OwnerZeroAddress",
  PermitExpired = "PermitExpired",
  RecoveredOwnerZeroAddress = "RecoveredOwnerZeroAddress",
  SpenderZeroAddress = "SpenderZeroAddress",
}

export enum Erc20RecoverErrors {
  NonRecoverableToken = "NonRecoverableToken",
  RecoverZero = "RecoverZero",
}

export enum GenericErrors {
  Initialized = "Initialized",
  NotInitialized = "NotInitialized",
}

export enum OwnableErrors {
  NotOwner = "NotOwner",
}
