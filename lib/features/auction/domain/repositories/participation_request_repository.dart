import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/participation_request.dart';

/// Repository for per-product participation requests.
abstract class ParticipationRequestRepository {
  /// Get current user's participation requests for an auction.
  Future<Either<Failure, List<ParticipationRequest>>> getMyRequests(
    String auctionId,
    String userId,
  );

  /// Request participation for a product (phone, terms accepted).
  Future<Either<Failure, ParticipationRequest>> requestParticipation({
    required String auctionId,
    required String productId,
    required String userId,
    required String phoneNumber,
    required bool termsAccepted,
  });
}
