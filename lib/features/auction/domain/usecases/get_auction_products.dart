import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auction_product.dart';
import '../repositories/auction_repository.dart';

class GetAuctionProducts {
  final AuctionRepository repository;

  GetAuctionProducts(this.repository);

  Future<Either<Failure, List<AuctionProduct>>> call(
    GetAuctionProductsParams params,
  ) async {
    return repository.getAuctionProducts(params.auctionId);
  }
}

class GetAuctionProductsParams extends Equatable {
  final String auctionId;

  const GetAuctionProductsParams({required this.auctionId});

  @override
  List<Object?> get props => [auctionId];
}
