/// Fine-grained phase of an auction (SOW §3.3).
enum AuctionProgress {
  votingOpen,
  votingClosed,
  participationApproval,
  liveAuction,
  winnerConfirmation,
  fallbackResolution,
}
