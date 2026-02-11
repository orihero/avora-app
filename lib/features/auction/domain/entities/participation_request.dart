import 'package:equatable/equatable.dart';
import 'enums/participation_status.dart';

/// Per-product participation request (SOW §8, §17.1).
class ParticipationRequest extends Equatable {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final String phoneNumber;
  final ParticipationStatus status;
  final bool termsAccepted;
  final DateTime? reviewedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ParticipationRequest({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.userId,
    required this.phoneNumber,
    required this.status,
    required this.termsAccepted,
    this.reviewedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        auctionId,
        productId,
        userId,
        phoneNumber,
        status,
        termsAccepted,
        reviewedAt,
        createdAt,
        updatedAt,
      ];
}
