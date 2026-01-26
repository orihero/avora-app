import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/model_asset.dart';

/// Repository interface for model asset operations
abstract class ModelRepository {
  /// Load a 3D model asset from the specified path
  Future<Either<Failure, ModelAsset>> loadModelAsset(String assetPath);
}
