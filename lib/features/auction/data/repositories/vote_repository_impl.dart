import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/vote.dart';
import '../../domain/repositories/vote_repository.dart';
import '../datasources/auction_remote_datasource.dart';

class VoteRepositoryImpl implements VoteRepository {
  final AuctionRemoteDataSource remoteDataSource;

  VoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Vote>>> getMyVotes(
    String auctionId,
    String userId,
  ) async {
    try {
      final list = await remoteDataSource.getMyVotes(auctionId, userId);
      return Right(list.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Vote>> submitVote({
    required String auctionId,
    required String productId,
    required String userId,
  }) async {
    try {
      final model = await remoteDataSource.submitVote(
        auctionId: auctionId,
        productId: productId,
        userId: userId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
