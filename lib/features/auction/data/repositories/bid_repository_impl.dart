import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/bid.dart';
import '../../domain/repositories/bid_repository.dart';
import '../datasources/auction_remote_datasource.dart';

class BidRepositoryImpl implements BidRepository {
  final AuctionRemoteDataSource remoteDataSource;

  BidRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Bid>>> getBidsForProduct({
    required String auctionId,
    required String productId,
  }) async {
    try {
      final list = await remoteDataSource.getBidsForProduct(
        auctionId: auctionId,
        productId: productId,
      );
      return Right(list.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Bid>> placeBid({
    required String auctionId,
    required String productId,
    required String userId,
    required String? phoneNumber,
    required double amount,
  }) async {
    try {
      final model = await remoteDataSource.createBid(
        auctionId: auctionId,
        productId: productId,
        userId: userId,
        phoneNumber: phoneNumber,
        amount: amount,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
