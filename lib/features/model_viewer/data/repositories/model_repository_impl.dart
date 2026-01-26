import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/model_asset.dart';
import '../../domain/repositories/model_repository.dart';
import '../datasources/model_asset_datasource.dart';

/// Implementation of ModelRepository
class ModelRepositoryImpl implements ModelRepository {
  final ModelAssetDataSource dataSource;

  ModelRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ModelAsset>> loadModelAsset(String assetPath) async {
    try {
      final modelAsset = await dataSource.loadModelAsset(assetPath);
      return Right(modelAsset);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
