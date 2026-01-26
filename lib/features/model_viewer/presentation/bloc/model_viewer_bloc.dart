import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/load_model_asset.dart';
import 'model_viewer_event.dart';
import 'model_viewer_state.dart';
import '../../domain/usecases/load_model_asset.dart' show AssetPathParams;

class ModelViewerBloc extends Bloc<ModelViewerEvent, ModelViewerState> {
  final LoadModelAsset loadModelAsset;

  ModelViewerBloc({required this.loadModelAsset})
      : super(const ModelViewerState.initial()) {
    on<ModelViewerEvent>(_onModelViewerEvent);
  }

  Future<void> _onModelViewerEvent(
    ModelViewerEvent event,
    Emitter<ModelViewerState> emit,
  ) async {
    await event.when(
      loadModel: (assetPath) async {
        emit(const ModelViewerState.loading());
        final result = await loadModelAsset(
          AssetPathParams(assetPath: assetPath),
        );
        result.fold(
          (failure) => emit(ModelViewerState.error(failure)),
          (modelAsset) => emit(ModelViewerState.loaded(modelAsset)),
        );
      },
    );
  }
}
