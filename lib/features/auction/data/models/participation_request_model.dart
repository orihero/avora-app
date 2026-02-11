import '../../domain/entities/enums/participation_status.dart';
import '../../domain/entities/participation_request.dart';

/// Data model for ParticipationRequest (Appwrite document).
class ParticipationRequestModel {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final String phoneNumber;
  final String status;
  final bool termsAccepted;
  final String? reviewedAt;
  final String? createdAt;
  final String? updatedAt;

  const ParticipationRequestModel({
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

  factory ParticipationRequestModel.fromJson(Map<String, dynamic> json) {
    return ParticipationRequestModel(
      id: json['\$id'] as String? ?? json['id'] as String? ?? '',
      auctionId: json['auctionId'] as String? ?? json['auction_id'] as String? ?? '',
      productId: json['productId'] as String? ?? json['product_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? json['phone_number'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      termsAccepted: json['termsAccepted'] as bool? ?? json['terms_accepted'] as bool? ?? false,
      reviewedAt: json['reviewedAt'] as String? ?? json['reviewed_at'] as String?,
      createdAt: json['\$createdAt'] as String? ?? json['createdAt'] as String?,
      updatedAt: json['\$updatedAt'] as String? ?? json['updatedAt'] as String?,
    );
  }

  ParticipationRequest toEntity() {
    return ParticipationRequest(
      id: id,
      auctionId: auctionId,
      productId: productId,
      userId: userId,
      phoneNumber: phoneNumber,
      status: _parseStatus(status),
      termsAccepted: termsAccepted,
      reviewedAt: reviewedAt != null ? DateTime.tryParse(reviewedAt!) : null,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  static ParticipationStatus _parseStatus(String s) {
    return ParticipationStatus.values.firstWhere(
      (e) => e.name == s.toLowerCase(),
      orElse: () => ParticipationStatus.pending,
    );
  }
}
