import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bid.dart';

/// Repository for bids (live auction).
abstract class BidRepository {
  /// Get bids for a product in an auction (e.g. for live view).
  Future<Either<Failure, List<Bid>>> getBidsForProduct({
    required String auctionId,
    required String productId,
  });

  /// Place a bid.
  Future<Either<Failure, Bid>> placeBid({
    required String auctionId,
    required String productId,
    required String userId,
    required String? phoneNumber,
    required double amount,
  });
}
