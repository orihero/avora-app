import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/winner_confirmation.dart';
import '../repositories/winner_confirmation_repository.dart';

class GetWinnerConfirmationsForProduct {
  final WinnerConfirmationRepository repository;

  GetWinnerConfirmationsForProduct(this.repository);

  Future<Either<Failure, List<WinnerConfirmation>>> call(
    GetWinnerConfirmationsForProductParams params,
  ) async {
    return repository.getConfirmationsForProduct(
      auctionId: params.auctionId,
      productId: params.productId,
    );
  }
}

class GetWinnerConfirmationsForProductParams extends Equatable {
  final String auctionId;
  final String productId;

  const GetWinnerConfirmationsForProductParams({
    required this.auctionId,
    required this.productId,
  });

  @override
  List<Object?> get props => [auctionId, productId];
}
