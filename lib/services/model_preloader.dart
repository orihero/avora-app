import 'dart:convert';
import 'package:flutter/services.dart';

/// Service to preload and manage 3D model assets
/// Loads the model once at app startup and provides it to multiple screens
class ModelPreloader {
  static final ModelPreloader _instance = ModelPreloader._internal();
  factory ModelPreloader() => _instance;
  ModelPreloader._internal();

  String? _modelBase64;
  bool _isLoading = false;
  bool _isLoaded = false;
  
  /// Get the preloaded model base64 string
  /// Returns null if not loaded yet
  String? get modelBase64 => _modelBase64;
  
  /// Check if the model is currently loading
  bool get isLoading => _isLoading;
  
  /// Check if the model has been loaded
  bool get isLoaded => _isLoaded;
  
  /// Load the 3D model from assets
  /// This should be called once at app startup
  Future<void> preloadModel({String assetPath = 'lib/assets/3d-objects/gaming_chair.glb'}) async {
    if (_isLoaded || _isLoading) {
      return;
    }
    
    _isLoading = true;
    
    try {
      final ByteData glbData = await rootBundle.load(assetPath);
      final List<int> glbBytes = glbData.buffer.asUint8List();
      _modelBase64 = base64Encode(glbBytes);
      _isLoaded = true;
      
      // Print size for debugging
      // ignore: avoid_print
      print('Model preloaded: ${glbBytes.length} bytes');
    } catch (e) {
      // ignore: avoid_print
      print('Error preloading model: $e');
      _modelBase64 = null;
      _isLoaded = false;
    } finally {
      _isLoading = false;
    }
  }
  
  /// Release the model from memory
  /// Call this after onboarding finishes if you want to free memory
  /// Note: This will make the model unavailable to other screens
  void releaseModel() {
    _modelBase64 = null;
    _isLoaded = false;
    // ignore: avoid_print
    print('Model released from memory');
  }
  
  /// Wait for the model to be loaded
  /// Returns when the model is ready, or throws if loading fails
  Future<void> waitForLoad() async {
    if (_isLoaded) {
      return;
    }
    
    if (!_isLoading) {
      await preloadModel();
    }
    
    // Wait for loading to complete
    while (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    
    if (!_isLoaded || _modelBase64 == null) {
      throw Exception('Failed to load 3D model');
    }
  }
}
