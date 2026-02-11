import 'package:equatable/equatable.dart';
import 'enums/winner_confirmation_status.dart';

/// Winner/fallback state per product (SOW §11–12, §17.1).
class WinnerConfirmation extends Equatable {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final WinnerConfirmationStatus status;
  final DateTime? confirmedAt;
  final int? fallbackRank;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WinnerConfirmation({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.userId,
    required this.status,
    this.confirmedAt,
    this.fallbackRank,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        auctionId,
        productId,
        userId,
        status,
        confirmedAt,
        fallbackRank,
        createdAt,
        updatedAt,
      ];
}
