export enum Erc20Errors {
  ApproveOwnerZeroAddress = "Erc20__ApproveOwnerZeroAddress",
  ApproveSpenderZeroAddress = "Erc20__ApproveSpenderZeroAddress",
  BurnZeroAddress = "Erc20__BurnZeroAddress",
  InsufficientAllowance = "Erc20__InsufficientAllowance",
  InsufficientBalance = "Erc20__InsufficientBalance",
  MintZeroAddress = "Erc20__MintZeroAddress",
  TransferRecipientZeroAddress = "Erc20__TransferRecipientZeroAddress",
  TransferSenderZeroAddress = "Erc20__TransferSenderZeroAddress",
}
export enum Erc20PermitErrors {
  InvalidSignature = "InvalidSignature",
  OwnerZeroAddress = "OwnerZeroAddress",
  PermitExpired = "PermitExpired",
  RecoveredOwnerZeroAddress = "RecoveredOwnerZeroAddress",
  SpenderZeroAddress = "SpenderZeroAddress",
}

export enum Erc20RecoverErrors {
  Initialized = "Erc20Recover__Initialized",
  NotInitialized = "Erc20Recover__NotInitialized",
  NonRecoverableToken = "Erc20Recover__NonRecoverableToken",
  RecoverZero = "Erc20Recover__RecoverZero",
}

export enum OwnableErrors {
  NotOwner = "NotOwner",
}

export enum PanicCodes {
  ArithmeticOverflowOrUnderflow = "0x11",
}
