import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/model_viewer_bloc.dart';
import '../bloc/model_viewer_event.dart';
import '../bloc/model_viewer_state.dart';

class FurnitureViewerPage extends StatefulWidget {
  final String assetPath;
  
  const FurnitureViewerPage({
    super.key,
    this.assetPath = 'lib/assets/3d-objects/gaming_chair.glb',
  });

  @override
  State<FurnitureViewerPage> createState() => _FurnitureViewerPageState();
}

class _FurnitureViewerPageState extends State<FurnitureViewerPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFEEEEEE))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            debugPrint('Page finished loading');
            // Trigger model loading when page is ready
            context.read<ModelViewerBloc>().add(
                  ModelViewerEvent.loadModel(widget.assetPath),
                );
          },
        ),
      )
      ..loadRequest(
        Uri.dataFromString(
          _getHtmlContent(),
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
  }

  void _injectModel(String base64Data) {
    debugPrint('Injecting GLB model, base64 length: ${base64Data.length}');
    _controller.runJavaScript('''
      (function() {
        const viewer = document.querySelector('model-viewer');
        console.log('Looking for model-viewer:', viewer);
        if (viewer) {
          viewer.src = 'data:model/gltf-binary;base64,$base64Data';
          console.log('GLB model src set, waiting for load...');
          viewer.addEventListener('load', () => {
            console.log('Model loaded successfully!');
          });
          viewer.addEventListener('error', (e) => {
            console.error('Model load error:', e);
            console.error('Error details:', e.detail);
          });
        } else {
          console.error('Model viewer element not found');
        }
      })();
    ''');
  }

  String _getHtmlContent() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.3.0/model-viewer.min.js"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    html, body {
      width: 100%;
      height: 100vh;
      overflow: hidden;
      position: fixed;
      overscroll-behavior: none;
      -webkit-overflow-scrolling: touch;
    }
    body {
      background-color: #EEEEEE;
      touch-action: pan-x pan-y pinch-zoom;
    }
    model-viewer {
      width: 100%;
      height: 100vh;
      display: block;
      touch-action: pan-x pan-y pinch-zoom;
    }
  </style>
</head>
<body>
  <model-viewer
    id="model-viewer"
    alt="3D Furniture Model"
    ar
    auto-rotate
    camera-controls
    background-color="#EEEEEE"
    style="width: 100%; height: 100vh;">
  </model-viewer>
  <script>
    console.log('HTML loaded, model-viewer script should be loading...');
    // Prevent page scrolling but allow model-viewer gestures
    document.body.style.overflow = 'hidden';
    document.documentElement.style.overflow = 'hidden';
    
    // Wait for model-viewer to be defined
    customElements.whenDefined('model-viewer').then(() => {
      console.log('model-viewer custom element defined');
      const viewer = document.querySelector('model-viewer');
      if (viewer) {
        console.log('Model viewer found and ready');
      }
    });
  </script>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ModelViewerBloc>(),
      child: BlocListener<ModelViewerBloc, ModelViewerState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (modelAsset) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  _injectModel(modelAsset.base64Data);
                }
              });
            },
            error: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading model: ${failure.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            orElse: () {},
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('3D Furniture Viewer'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: BlocBuilder<ModelViewerBloc, ModelViewerState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (failure) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${failure.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ModelViewerBloc>().add(
                                ModelViewerEvent.loadModel(widget.assetPath),
                              );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                orElse: () => WebViewWidget(controller: _controller),
              );
            },
          ),
        ),
      ),
    );
  }
}
