/// Winner/fallback confirmation status (SOW §17.1).
enum WinnerConfirmationStatus {
  pendingConfirmation,
  confirmed,
  rejected,
  paymentFailed,
  unreachable,
}
