import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/vote.dart';
import '../repositories/vote_repository.dart';

class SubmitVote {
  final VoteRepository repository;

  SubmitVote(this.repository);

  Future<Either<Failure, Vote>> call(SubmitVoteParams params) async {
    return repository.submitVote(
      auctionId: params.auctionId,
      productId: params.productId,
      userId: params.userId,
    );
  }
}

class SubmitVoteParams extends Equatable {
  final String auctionId;
  final String productId;
  final String userId;

  const SubmitVoteParams({
    required this.auctionId,
    required this.productId,
    required this.userId,
  });

  @override
  List<Object?> get props => [auctionId, productId, userId];
}
