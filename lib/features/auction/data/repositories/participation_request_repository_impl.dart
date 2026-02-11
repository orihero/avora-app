import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/participation_request.dart';
import '../../domain/repositories/participation_request_repository.dart';
import '../datasources/auction_remote_datasource.dart';

class ParticipationRequestRepositoryImpl
    implements ParticipationRequestRepository {
  final AuctionRemoteDataSource remoteDataSource;

  ParticipationRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ParticipationRequest>>> getMyRequests(
    String auctionId,
    String userId,
  ) async {
    try {
      final list = await remoteDataSource.getMyParticipationRequests(
        auctionId,
        userId,
      );
      return Right(list.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ParticipationRequest>> requestParticipation({
    required String auctionId,
    required String productId,
    required String userId,
    required String phoneNumber,
    required bool termsAccepted,
  }) async {
    try {
      final model = await remoteDataSource.createParticipationRequest(
        auctionId: auctionId,
        productId: productId,
        userId: userId,
        phoneNumber: phoneNumber,
        termsAccepted: termsAccepted,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
