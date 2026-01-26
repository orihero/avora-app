import 'package:equatable/equatable.dart';

/// Entity representing a 3D model asset
class ModelAsset extends Equatable {
  final String base64Data;
  final String assetPath;
  final bool isLoaded;

  const ModelAsset({
    required this.base64Data,
    required this.assetPath,
    required this.isLoaded,
  });

  @override
  List<Object> get props => [base64Data, assetPath, isLoaded];
}
