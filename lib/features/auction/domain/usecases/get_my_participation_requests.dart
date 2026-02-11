import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/participation_request.dart';
import '../repositories/participation_request_repository.dart';

class GetMyParticipationRequests {
  final ParticipationRequestRepository repository;

  GetMyParticipationRequests(this.repository);

  Future<Either<Failure, List<ParticipationRequest>>> call(
    GetMyParticipationRequestsParams params,
  ) async {
    return repository.getMyRequests(params.auctionId, params.userId);
  }
}

class GetMyParticipationRequestsParams extends Equatable {
  final String auctionId;
  final String userId;

  const GetMyParticipationRequestsParams({
    required this.auctionId,
    required this.userId,
  });

  @override
  List<Object?> get props => [auctionId, userId];
}
