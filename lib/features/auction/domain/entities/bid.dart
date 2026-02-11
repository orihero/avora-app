import 'package:equatable/equatable.dart';

/// Bid per auction + product (SOW §10, §17.1).
class Bid extends Equatable {
  final String id;
  final String auctionId;
  final String productId;
  final String userId;
  final String? phoneNumber;
  final double amount;
  final int? fallbackRank;
  final DateTime? createdAt;

  const Bid({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.userId,
    this.phoneNumber,
    required this.amount,
    this.fallbackRank,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        auctionId,
        productId,
        userId,
        phoneNumber,
        amount,
        fallbackRank,
        createdAt,
      ];
}
