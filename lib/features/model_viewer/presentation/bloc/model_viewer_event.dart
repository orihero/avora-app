import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_viewer_event.freezed.dart';

@freezed
class ModelViewerEvent with _$ModelViewerEvent {
  const factory ModelViewerEvent.loadModel(String assetPath) = _LoadModel;
}
