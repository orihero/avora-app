import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/bid.dart';
import '../repositories/bid_repository.dart';

class PlaceBid {
  final BidRepository repository;

  PlaceBid(this.repository);

  Future<Either<Failure, Bid>> call(PlaceBidParams params) async {
    return repository.placeBid(
      auctionId: params.auctionId,
      productId: params.productId,
      userId: params.userId,
      phoneNumber: params.phoneNumber,
      amount: params.amount,
    );
  }
}

class PlaceBidParams extends Equatable {
  final String auctionId;
  final String productId;
  final String userId;
  final String? phoneNumber;
  final double amount;

  const PlaceBidParams({
    required this.auctionId,
    required this.productId,
    required this.userId,
    this.phoneNumber,
    required this.amount,
  });

  @override
  List<Object?> get props => [auctionId, productId, userId, phoneNumber, amount];
}
