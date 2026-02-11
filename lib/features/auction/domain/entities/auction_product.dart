import 'package:equatable/equatable.dart';

/// Product in an auction; link auction ↔ product (SOW §17.1).
class AuctionProduct extends Equatable {
  final String id;
  final String auctionId;
  final String productId;
  final bool selectedForLive;
  final double minBidPrice;
  final int sortOrder;
  final List<double> priceIncrementPresets;

  const AuctionProduct({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.selectedForLive,
    required this.minBidPrice,
    required this.sortOrder,
    this.priceIncrementPresets = const [],
  });

  @override
  List<Object?> get props => [
        id,
        auctionId,
        productId,
        selectedForLive,
        minBidPrice,
        sortOrder,
        priceIncrementPresets,
      ];
}
