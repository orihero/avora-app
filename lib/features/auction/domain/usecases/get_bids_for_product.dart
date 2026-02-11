import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/bid.dart';
import '../repositories/bid_repository.dart';

class GetBidsForProduct {
  final BidRepository repository;

  GetBidsForProduct(this.repository);

  Future<Either<Failure, List<Bid>>> call(GetBidsForProductParams params) async {
    return repository.getBidsForProduct(
      auctionId: params.auctionId,
      productId: params.productId,
    );
  }
}

class GetBidsForProductParams extends Equatable {
  final String auctionId;
  final String productId;

  const GetBidsForProductParams({
    required this.auctionId,
    required this.productId,
  });

  @override
  List<Object?> get props => [auctionId, productId];
}
