import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Full-screen video player. Accepts a video URL and shows play/pause and close.
class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPage({
    super.key,
    required this.videoUrl,
  });

  static Future<void> open(BuildContext context, String videoUrl) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenVideoPage(videoUrl: videoUrl),
      ),
    );
  }

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _controller.play();
      }).catchError((Object e) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Loading video...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (_controller.value.isInitialized)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _controller.value.isPlaying
                        ? const SizedBox.shrink()
                        : const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white54,
                            size: 72,
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
