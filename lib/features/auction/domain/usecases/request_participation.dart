import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/participation_request.dart';
import '../repositories/participation_request_repository.dart';

class RequestParticipation {
  final ParticipationRequestRepository repository;

  RequestParticipation(this.repository);

  Future<Either<Failure, ParticipationRequest>> call(
    RequestParticipationParams params,
  ) async {
    return repository.requestParticipation(
      auctionId: params.auctionId,
      productId: params.productId,
      userId: params.userId,
      phoneNumber: params.phoneNumber,
      termsAccepted: params.termsAccepted,
    );
  }
}

class RequestParticipationParams extends Equatable {
  final String auctionId;
  final String productId;
  final String userId;
  final String phoneNumber;
  final bool termsAccepted;

  const RequestParticipationParams({
    required this.auctionId,
    required this.productId,
    required this.userId,
    required this.phoneNumber,
    required this.termsAccepted,
  });

  @override
  List<Object?> get props =>
      [auctionId, productId, userId, phoneNumber, termsAccepted];
}
