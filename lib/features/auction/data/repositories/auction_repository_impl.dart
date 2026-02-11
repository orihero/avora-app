import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auction.dart';
import '../../domain/entities/auction_product.dart';
import '../../domain/repositories/auction_repository.dart';
import '../datasources/auction_remote_datasource.dart';

class AuctionRepositoryImpl implements AuctionRepository {
  final AuctionRemoteDataSource remoteDataSource;

  AuctionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Auction?>> getFeaturedAuction() async {
    try {
      final model = await remoteDataSource.getFeaturedAuction();
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Auction?>> getAuctionById(String id) async {
    try {
      final model = await remoteDataSource.getAuctionById(id);
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AuctionProduct>>> getAuctionProducts(
    String auctionId,
  ) async {
    try {
      final list = await remoteDataSource.getAuctionProducts(auctionId);
      return Right(list.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getVariable(String key) async {
    try {
      final value = await remoteDataSource.getVariable(key);
      return Right(value);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
