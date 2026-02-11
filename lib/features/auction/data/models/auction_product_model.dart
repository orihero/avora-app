import '../../domain/entities/auction_product.dart';

/// Data model for AuctionProduct (Appwrite document).
class AuctionProductModel {
  final String id;
  final String auctionId;
  final String productId;
  final bool selectedForLive;
  final double minBidPrice;
  final int sortOrder;
  final List<dynamic>? priceIncrementPresets;

  const AuctionProductModel({
    required this.id,
    required this.auctionId,
    required this.productId,
    required this.selectedForLive,
    required this.minBidPrice,
    required this.sortOrder,
    this.priceIncrementPresets,
  });

  factory AuctionProductModel.fromJson(Map<String, dynamic> json) {
    final presetsRaw = json['price_increment_presets'] ?? json['priceIncrementPresets'];
    List<dynamic>? presetsList;
    if (presetsRaw is List) presetsList = presetsRaw;
    return AuctionProductModel(
      id: json['\$id'] as String? ?? json['id'] as String? ?? '',
      auctionId: json['auctionId'] as String? ?? json['auction_id'] as String? ?? '',
      productId: json['productId'] as String? ?? json['product_id'] as String? ?? '',
      selectedForLive: json['selectedForLive'] as bool? ?? json['selected_for_live'] as bool? ?? false,
      minBidPrice: (json['minBidPrice'] ?? json['min_bid_price'] ?? 0) is int
          ? (json['minBidPrice'] ?? json['min_bid_price'] ?? 0).toDouble()
          : (json['minBidPrice'] ?? json['min_bid_price'] ?? 0.0) as double,
      sortOrder: json['sortOrder'] as int? ?? json['sort_order'] as int? ?? 0,
      priceIncrementPresets: presetsList,
    );
  }

  AuctionProduct toEntity() {
    List<double> presets = [];
    if (priceIncrementPresets != null) {
      for (final e in priceIncrementPresets!) {
        if (e is num) presets.add(e.toDouble());
      }
    }
    return AuctionProduct(
      id: id,
      auctionId: auctionId,
      productId: productId,
      selectedForLive: selectedForLive,
      minBidPrice: minBidPrice,
      sortOrder: sortOrder,
      priceIncrementPresets: presets,
    );
  }
}
