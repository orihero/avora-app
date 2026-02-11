import '../../domain/entities/vote.dart';

/// Data model for Vote (Appwrite document).
class VoteModel {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final String? updatedAt;

  const VoteModel({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.userId,
    this.updatedAt,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['\$id'] as String? ?? json['id'] as String? ?? '',
      auctionId: json['auctionId'] as String? ?? json['auction_id'] as String? ?? '',
      productId: json['productId'] as String? ?? json['product_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      updatedAt: json['\$updatedAt'] as String? ?? json['updatedAt'] as String?,
    );
  }

  Vote toEntity() {
    return Vote(
      id: id,
      auctionId: auctionId,
      productId: productId,
      userId: userId,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}
