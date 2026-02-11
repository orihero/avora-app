import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auction.dart';
import '../repositories/auction_repository.dart';

class GetFeaturedAuction {
  final AuctionRepository repository;

  GetFeaturedAuction(this.repository);

  Future<Either<Failure, Auction?>> call(NoParams params) async {
    return repository.getFeaturedAuction();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
