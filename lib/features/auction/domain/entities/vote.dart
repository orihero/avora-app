import 'package:equatable/equatable.dart';

/// User vote per auction + product (SOW §6, §17.1). One vote per category.
class Vote extends Equatable {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final DateTime? updatedAt;

  const Vote({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.userId,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, auctionId, productId, userId, updatedAt];
}
