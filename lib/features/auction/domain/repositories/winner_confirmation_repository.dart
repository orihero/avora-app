import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/winner_confirmation.dart';

/// Repository for winner/fallback confirmation (read-only for app).
abstract class WinnerConfirmationRepository {
  /// Get winner confirmation for a product in an auction.
  Future<Either<Failure, List<WinnerConfirmation>>> getConfirmationsForProduct({
    required String auctionId,
    required String productId,
  });
}
