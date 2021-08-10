export enum Erc20Errors {
  ApproveOwnerZeroAddress = "Erc20__ApproveOwnerZeroAddress",
  ApproveSpenderZeroAddress = "Erc20__ApproveSpenderZeroAddress",
  BurnUnderflow = "Erc20__BurnUnderflow",
  BurnZeroAddress = "Erc20__BurnZeroAddress",
  DecreasedAllowanceBelowZero = "Erc20__DecreasedAllowanceBelowZero",
  MintZeroAddress = "Erc20__MintZeroAddress",
  TransferRecipientZeroAddress = "Erc20__TransferRecipientZeroAddress",
  TransferSenderZeroAddress = "Erc20__TransferSenderZeroAddress",
  TransferUnderflow = "Erc20__TransferUnderflow",
}
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
