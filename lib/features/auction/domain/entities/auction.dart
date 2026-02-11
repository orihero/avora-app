import 'package:equatable/equatable.dart';
import 'enums/auction_progress.dart';
import 'enums/auction_status.dart';

/// Auction metadata, status, progress, dates (SOW §3, §17.1).
class Auction extends Equatable {
  final String id;
  final String title;
  final String description;
  final AuctionStatus status;
  final AuctionProgress progress;
  final DateTime? startAt;
  final DateTime? votingEndAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Auction({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    this.startAt,
    this.votingEndAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        progress,
        startAt,
        votingEndAt,
        createdAt,
        updatedAt,
      ];
}
