import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Instagram-style full-screen stories view. For no-auction: one story (promo video or placeholder).
class AuctionStoriesView extends StatefulWidget {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;

  const AuctionStoriesView({
    super.key,
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
  });

  static Future<void> open(
    BuildContext context, {
    String? promoVideoUrl,
    String? promoVideoThumbnailUrl,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AuctionStoriesView(
          promoVideoUrl: promoVideoUrl,
          promoVideoThumbnailUrl: promoVideoThumbnailUrl,
        ),
      ),
    );
  }

  @override
  State<AuctionStoriesView> createState() => _AuctionStoriesViewState();
}

class _AuctionStoriesViewState extends State<AuctionStoriesView> {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initVideoIfNeeded();
  }

  void _initVideoIfNeeded() {
    final url = widget.promoVideoUrl;
    if (url != null && url.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          if (mounted) setState(() {});
          _videoController!.play();
        }).catchError((_) {
          if (mounted) setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onClose() {
    _videoController?.pause();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 100) {
            _onClose();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                if (index == 0 && _videoController != null) {
                  _videoController!.play();
                }
              },
              children: [
                _StoryPage(
                  promoVideoUrl: widget.promoVideoUrl,
                  promoVideoThumbnailUrl: widget.promoVideoThumbnailUrl,
                  videoController: _videoController,
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: _onClose,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: List.generate(1, (index) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: _currentPage >= index
                                      ? Colors.white
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryPage extends StatelessWidget {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final VideoPlayerController? videoController;

  const _StoryPage({
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    this.videoController,
  });

  @override
  Widget build(BuildContext context) {
    if (videoController != null && videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
      );
    }
    if (promoVideoUrl != null && promoVideoUrl!.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }
    return Center(
      child: promoVideoThumbnailUrl != null && promoVideoThumbnailUrl!.isNotEmpty
          ? Image.network(
              promoVideoThumbnailUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.gavel, size: 80, color: Colors.white38),
        SizedBox(height: 16),
        Text(
          'Auction',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
