import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/vote.dart';

/// Repository for voting (one vote per category per user).
abstract class VoteRepository {
  /// Get current user's votes for an auction.
  Future<Either<Failure, List<Vote>>> getMyVotes(String auctionId, String userId);

  /// Submit or update vote for a product in an auction.
  Future<Either<Failure, Vote>> submitVote({
    required String auctionId,
    required String productId,
    required String userId,
  });
}
