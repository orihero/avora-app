import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/winner_confirmation.dart';
import '../../domain/repositories/winner_confirmation_repository.dart';
import '../datasources/auction_remote_datasource.dart';

class WinnerConfirmationRepositoryImpl
    implements WinnerConfirmationRepository {
  final AuctionRemoteDataSource remoteDataSource;

  WinnerConfirmationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WinnerConfirmation>>> getConfirmationsForProduct({
    required String auctionId,
    required String productId,
  }) async {
    try {
      final list = await remoteDataSource.getWinnerConfirmationsForProduct(
        auctionId: auctionId,
        productId: productId,
      );
      return Right(list.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
