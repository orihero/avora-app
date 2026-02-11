import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auction.dart';
import '../repositories/auction_repository.dart';

class GetAuctionById {
  final AuctionRepository repository;

  GetAuctionById(this.repository);

  Future<Either<Failure, Auction?>> call(GetAuctionByIdParams params) async {
    return repository.getAuctionById(params.auctionId);
  }
}

class GetAuctionByIdParams extends Equatable {
  final String auctionId;

  const GetAuctionByIdParams({required this.auctionId});

  @override
  List<Object?> get props => [auctionId];
}
