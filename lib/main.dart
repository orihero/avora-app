import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'screens/onboarding_screen.dart';
import 'services/model_preloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Preload the 3D model at app startup
  ModelPreloader().preloadModel();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avora - 3D Furniture Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class FurnitureViewer extends StatefulWidget {
  const FurnitureViewer({super.key});

  @override
  State<FurnitureViewer> createState() => _FurnitureViewerState();
}

class _FurnitureViewerState extends State<FurnitureViewer> {
  late final WebViewController _controller;
  final ModelPreloader _preloader = ModelPreloader();

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
            // Wait for preloaded model if not ready yet
            _preloader.waitForLoad().then((_) {
              if (mounted) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  _injectModel();
                });
              }
            }).catchError((e) {
              debugPrint('Error waiting for model: $e');
            });
          },
        ),
      )
      ..loadRequest(Uri.dataFromString(_getHtmlContent(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

  void _injectModel() {
    final modelBase64 = _preloader.modelBase64;
    if (modelBase64 == null) {
      debugPrint('Model base64 is null');
      return;
    }
    debugPrint('Injecting GLB model, base64 length: ${modelBase64.length}');
    _controller.runJavaScript('''
      (function() {
        const viewer = document.querySelector('model-viewer');
        console.log('Looking for model-viewer:', viewer);
        if (viewer) {
          viewer.src = 'data:model/gltf-binary;base64,$modelBase64';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Furniture Viewer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
