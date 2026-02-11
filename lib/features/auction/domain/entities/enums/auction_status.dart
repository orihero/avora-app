/// High-level lifecycle state of an auction (SOW §3.2).
enum AuctionStatus {
  draft,
  scheduled,
  active,
  completed,
  cancelled,
}
