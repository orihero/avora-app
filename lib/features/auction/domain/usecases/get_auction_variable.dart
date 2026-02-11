import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auction_repository.dart';

class GetAuctionVariable {
  final AuctionRepository repository;

  GetAuctionVariable(this.repository);

  Future<Either<Failure, String>> call(GetAuctionVariableParams params) async {
    return repository.getVariable(params.key);
  }
}

class GetAuctionVariableParams extends Equatable {
  final String key;

  const GetAuctionVariableParams({required this.key});

  @override
  List<Object?> get props => [key];
}
