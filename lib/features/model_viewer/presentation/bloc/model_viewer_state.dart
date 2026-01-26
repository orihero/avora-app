import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/model_asset.dart';
import '../../../../core/error/failures.dart';

part 'model_viewer_state.freezed.dart';

@freezed
class ModelViewerState with _$ModelViewerState {
  const factory ModelViewerState.initial() = _Initial;
  const factory ModelViewerState.loading() = _Loading;
  const factory ModelViewerState.loaded(ModelAsset modelAsset) = _Loaded;
  const factory ModelViewerState.error(Failure failure) = _Error;
}
