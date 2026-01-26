import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/model_asset.dart';
import '../repositories/model_repository.dart';

/// Use case for loading a model asset
class LoadModelAsset {
  final ModelRepository repository;

  LoadModelAsset(this.repository);

  Future<Either<Failure, ModelAsset>> call(AssetPathParams params) async {
    return await repository.loadModelAsset(params.assetPath);
  }
}

/// Parameters class for LoadModelAsset use case
class AssetPathParams extends Equatable {
  final String assetPath;

  const AssetPathParams({required this.assetPath});

  @override
  List<Object> get props => [assetPath];
}
