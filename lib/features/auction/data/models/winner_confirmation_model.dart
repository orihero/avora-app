import '../../domain/entities/enums/winner_confirmation_status.dart';
import '../../domain/entities/winner_confirmation.dart';

/// Data model for WinnerConfirmation (Appwrite document).
class WinnerConfirmationModel {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final String status;
  final String? confirmedAt;
  final int? fallbackRank;
  final String? createdAt;
  final String? updatedAt;

  const WinnerConfirmationModel({
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

  factory WinnerConfirmationModel.fromJson(Map<String, dynamic> json) {
    return WinnerConfirmationModel(
      id: json['\$id'] as String? ?? json['id'] as String? ?? '',
      auctionId: json['auctionId'] as String? ?? json['auction_id'] as String? ?? '',
      productId: json['productId'] as String? ?? json['product_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending_confirmation',
      confirmedAt: json['confirmedAt'] as String? ?? json['confirmed_at'] as String?,
      fallbackRank: json['fallbackRank'] as int? ?? json['fallback_rank'] as int?,
      createdAt: json['\$createdAt'] as String? ?? json['createdAt'] as String?,
      updatedAt: json['\$updatedAt'] as String? ?? json['updatedAt'] as String?,
    );
  }

  WinnerConfirmation toEntity() {
    return WinnerConfirmation(
      id: id,
      auctionId: auctionId,
      productId: productId,
      userId: userId,
      status: _parseStatus(status),
      confirmedAt: confirmedAt != null ? DateTime.tryParse(confirmedAt!) : null,
      fallbackRank: fallbackRank,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  static WinnerConfirmationStatus _parseStatus(String s) {
    final normalized = s.toLowerCase().replaceAll(' ', '_');
    return WinnerConfirmationStatus.values.firstWhere(
      (e) => e.name == s || e.name == normalized,
      orElse: () => WinnerConfirmationStatus.pendingConfirmation,
    );
  }
}
