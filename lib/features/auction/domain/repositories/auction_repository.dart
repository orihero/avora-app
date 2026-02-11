import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auction.dart';
import '../entities/auction_product.dart';

/// Repository for auction metadata and products.
abstract class AuctionRepository {
  /// Featured auction: first active, else first completed, else first scheduled.
  Future<Either<Failure, Auction?>> getFeaturedAuction();

  /// Get auction by id.
  Future<Either<Failure, Auction?>> getAuctionById(String id);

  /// Get products linked to an auction.
  Future<Either<Failure, List<AuctionProduct>>> getAuctionProducts(String auctionId);

  /// Get configurable variable by key (e.g. auction_promo_video_url).
  Future<Either<Failure, String>> getVariable(String key);
}
