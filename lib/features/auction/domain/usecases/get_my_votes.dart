import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/vote.dart';
import '../repositories/vote_repository.dart';

class GetMyVotes {
  final VoteRepository repository;

  GetMyVotes(this.repository);

  Future<Either<Failure, List<Vote>>> call(GetMyVotesParams params) async {
    return repository.getMyVotes(params.auctionId, params.userId);
  }
}

class GetMyVotesParams extends Equatable {
  final String auctionId;
  final String userId;

  const GetMyVotesParams({required this.auctionId, required this.userId});

  @override
  List<Object?> get props => [auctionId, userId];
}
