export enum ERC20Errors {
  ApproveOwnerZeroAddress = "ERC20__ApproveOwnerZeroAddress",
  ApproveSpenderZeroAddress = "ERC20__ApproveSpenderZeroAddress",
  BurnZeroAddress = "ERC20__BurnZeroAddress",
  InsufficientAllowance = "ERC20__InsufficientAllowance",
  InsufficientBalance = "ERC20__InsufficientBalance",
  MintZeroAddress = "ERC20__MintZeroAddress",
  TransferRecipientZeroAddress = "ERC20__TransferRecipientZeroAddress",
  TransferSenderZeroAddress = "ERC20__TransferSenderZeroAddress",
}
export enum ERC20PermitErrors {
  InvalidSignature = "InvalidSignature",
  OwnerZeroAddress = "OwnerZeroAddress",
  PermitExpired = "PermitExpired",
  RecoveredOwnerZeroAddress = "RecoveredOwnerZeroAddress",
  SpenderZeroAddress = "SpenderZeroAddress",
}

export enum ERC20RecoverErrors {
  Initialized = "ERC20Recover__Initialized",
  NotInitialized = "ERC20Recover__NotInitialized",
  NonRecoverableToken = "ERC20Recover__NonRecoverableToken",
  RecoverZero = "ERC20Recover__RecoverZero",
}

export enum OwnableErrors {
  NotOwner = "NotOwner",
}

export enum PanicCodes {
  ArithmeticOverflowOrUnderflow = "0x11",
}
