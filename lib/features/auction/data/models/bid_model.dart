import '../../domain/entities/bid.dart';

/// Data model for Bid (Appwrite document).
class BidModel {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final String? phoneNumber;
  final double amount;
  final int? fallbackRank;
  final String? createdAt;

  const BidModel({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.userId,
    this.phoneNumber,
    required this.amount,
    this.fallbackRank,
    this.createdAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['\$id'] as String? ?? json['id'] as String? ?? '',
      auctionId: json['auctionId'] as String? ?? json['auction_id'] as String? ?? '',
      productId: json['productId'] as String? ?? json['product_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? json['phone_number'] as String?,
      amount: (json['amount'] ?? 0) is int
          ? (json['amount'] ?? 0).toDouble()
          : (json['amount'] ?? 0.0) as double,
      fallbackRank: json['fallbackRank'] as int? ?? json['fallback_rank'] as int?,
      createdAt: json['\$createdAt'] as String? ?? json['createdAt'] as String?,
    );
  }

  Bid toEntity() {
    return Bid(
      id: id,
      auctionId: auctionId,
      productId: productId,
      userId: userId,
      phoneNumber: phoneNumber,
      amount: amount,
      fallbackRank: fallbackRank,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}
