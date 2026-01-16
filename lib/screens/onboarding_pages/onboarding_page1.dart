import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/model_preloader.dart';

class OnboardingPage1 extends StatefulWidget {
  const OnboardingPage1({super.key});

  @override
  State<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1>
    with TickerProviderStateMixin {
  late final WebViewController _controller;
  late final AnimationController _modelAnimationController;
  late final AnimationController _textAnimationController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _textScaleAnimation;
  final ModelPreloader _preloader = ModelPreloader();
  double _rotationValue = 0.5; // Start at center position
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeWebView();
    // Wait for preloaded model
    _preloader.waitForLoad().then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _injectModel();
        });
      }
    }).catchError((e) {
      debugPrint('Error waiting for model: $e');
    });
  }

  void _setupAnimations() {
    // Model animation - slower slide and rotate
    _modelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Slower: 1.5 seconds
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0, // Off-screen to the right
      end: 0.0,   // Center position
    ).animate(CurvedAnimation(
      parent: _modelAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.8, // More rotation at start
      end: 0.0,   // Final rotation
    ).animate(CurvedAnimation(
      parent: _modelAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Text animation - fade and scale
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ));

    _textScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ));

    // Start animations after a short delay to ensure WebView is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _modelAnimationController.forward();
        // Start text animation slightly after model animation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _textAnimationController.forward();
          }
        });
      }
    });
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'RotationChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle messages from JavaScript if needed
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (_preloader.isLoaded && !_modelLoaded) {
              Future.delayed(const Duration(milliseconds: 300), () {
                _injectModel();
              });
            } else if (!_preloader.isLoaded && !_preloader.isLoading) {
              // Wait for model to be loaded
              _preloader.waitForLoad().then((_) {
                if (mounted && !_modelLoaded) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _injectModel();
                  });
                }
              });
            }
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

  void _injectModel() {
    final modelBase64 = _preloader.modelBase64;
    if (modelBase64 == null) {
      return;
    }
    // Set initial rotation to match slider center position (0.5 = 180 degrees)
    final double initialRotation = _rotationValue * 360;
    
    _controller.runJavaScript('''
      (function() {
        const viewer = document.querySelector('model-viewer');
        if (viewer) {
          viewer.src = 'data:model/gltf-binary;base64,$modelBase64';
          viewer.cameraOrbit = '$initialRotation deg auto 105%';
          viewer.addEventListener('load', () => {
            console.log('Model loaded successfully!');
          });
        }
      })();
    ''');
    
    if (mounted) {
      setState(() {
        _modelLoaded = true;
      });
    }
  }

  void _updateRotation(double value) {
    setState(() {
      _rotationValue = value;
    });

    // Convert slider value (0-1) to rotation angle (0 to 360 degrees)
    final double rotationAngle = value * 360;

    _controller.runJavaScript('''
      if (typeof updateModelRotation === 'function') {
        updateModelRotation($rotationAngle);
      } else {
        const viewer = document.querySelector('model-viewer');
        if (viewer) {
          viewer.cameraOrbit = '$rotationAngle deg auto 105%';
        }
      }
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
      height: 100%;
      overflow: hidden;
      background: transparent;
    }
    model-viewer {
      width: 100%;
      height: 100%;
      display: block;
      background: transparent;
    }
  </style>
</head>
<body>
  <model-viewer
    id="model-viewer"
    alt="3D Furniture Model"
    camera-orbit="0deg auto 105%"
    camera-controls="false"
    disable-zoom
    disable-pan
    interaction-policy="allow-when-focused"
    background-color="transparent"
    style="width: 100%; height: 100%;">
  </model-viewer>
  <script>
    // Function to update rotation
    window.updateModelRotation = function(degrees) {
      const viewer = document.querySelector('model-viewer');
      if (viewer) {
        viewer.cameraOrbit = degrees + 'deg auto 105%';
      }
    };
  </script>
</body>
</html>
    ''';
  }

  @override
  void dispose() {
    _modelAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        // Light green background placeholder
        color: Color(0xFFE8F5E9),
        // Uncomment and add your background image here:
        // image: DecorationImage(
        //   image: AssetImage('path/to/your/background/image.png'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top section: 3D model viewer with animation
            Expanded(
              flex: 5,
              child: AnimatedBuilder(
                animation: _modelAnimationController,
                builder: (context, child) {
                  return ClipRect(
                    child: Transform.translate(
                      offset: Offset(
                        _slideAnimation.value * screenWidth,
                        0,
                      ),
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 1.0, // More rotation
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: WebViewWidget(controller: _controller),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Middle section: Slider, text, and progress dots
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // White curved slider
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      height: 40,
                      child: Stack(
                        children: [
                          // Curved track background
                          CustomPaint(
                            size: Size.infinite,
                            painter: CurvedSliderPainter(
                              value: _rotationValue,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          // Slider on top
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                              trackHeight: 0,
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                            ),
                            child: Slider(
                              value: _rotationValue,
                              onChanged: _updateRotation,
                              min: 0.0,
                              max: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text with animation
                    AnimatedBuilder(
                      animation: _textAnimationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: const Text(
                              'View and Experience Furniture with the help of Augmented Reality',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 0 ? 10 : 8,
                          height: index == 0 ? 10 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? const Color(0xFF424242)
                                : const Color(0xFF424242).withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for curved slider track
class CurvedSliderPainter extends CustomPainter {
  final double value;
  final Color activeColor;
  final Color inactiveColor;

  CurvedSliderPainter({
    required this.value,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = activeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Create a curved path (slight arc upward)
    // The curve goes from bottom-left to bottom-right with a peak in the middle
    final startPoint = Offset(0, size.height * 0.7);
    final endPoint = Offset(size.width, size.height * 0.7);
    final controlPoint = Offset(size.width / 2, size.height * 0.2);

    // Draw full inactive path
    final fullPath = Path();
    fullPath.moveTo(startPoint.dx, startPoint.dy);
    fullPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    canvas.drawPath(fullPath, inactivePaint);

    // Draw active portion (up to the thumb position)
    if (value > 0) {
      final activePath = Path();
      final activeEndX = value * size.width;
      final activeEndY = _calculateYOnCurve(activeEndX, size.width, size.height);

      activePath.moveTo(startPoint.dx, startPoint.dy);
      activePath.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        activeEndX,
        activeEndY,
      );

      canvas.drawPath(activePath, paint);
    }
  }

  double _calculateYOnCurve(double x, double width, double height) {
    // Calculate Y position on the quadratic bezier curve
    final t = x / width;
    final startY = height * 0.7;
    final endY = height * 0.7;
    final controlY = height * 0.2;
    return (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;
  }

  @override
  bool shouldRepaint(CurvedSliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}

