import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/model_asset.dart';

/// Abstract class for model asset data source
abstract class ModelAssetDataSource {
  Future<ModelAsset> loadModelAsset(String assetPath);
}

/// Implementation of ModelAssetDataSource
class ModelAssetDataSourceImpl implements ModelAssetDataSource {
  @override
  Future<ModelAsset> loadModelAsset(String assetPath) async {
    try {
      final ByteData glbData = await rootBundle.load(assetPath);
      final List<int> glbBytes = glbData.buffer.asUint8List();
      final String base64Data = base64Encode(glbBytes);
      
      return ModelAsset(
        base64Data: base64Data,
        assetPath: assetPath,
        isLoaded: true,
      );
    } catch (e) {
      throw CacheException('Failed to load model asset: ${e.toString()}');
    }
  }
}
