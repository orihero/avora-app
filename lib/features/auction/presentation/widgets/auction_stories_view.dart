import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/story_item.dart';

/// Instagram-style full-screen stories view. Supports multiple stories from AppWrite.
class AuctionStoriesView extends StatefulWidget {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final List<StoryItem>? stories;

  const AuctionStoriesView({
    super.key,
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    this.stories,
  });

  static Future<void> open(
    BuildContext context, {
    String? promoVideoUrl,
    String? promoVideoThumbnailUrl,
    List<StoryItem>? stories,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AuctionStoriesView(
          promoVideoUrl: promoVideoUrl,
          promoVideoThumbnailUrl: promoVideoThumbnailUrl,
          stories: stories,
        ),
      ),
    );
  }

  @override
  State<AuctionStoriesView> createState() => _AuctionStoriesViewState();
}

class _AuctionStoriesViewState extends State<AuctionStoriesView> {
  late PageController _pageController;
  final Map<int, VideoPlayerController> _videoControllers = {};
  int _currentPage = 0;

  List<StoryItem> get _stories {
    // If stories list is provided, use it; otherwise fallback to promo video as single story
    if (widget.stories != null && widget.stories!.isNotEmpty) {
      return widget.stories!;
    }
    // Fallback: create a single story from promo video
    if (widget.promoVideoUrl != null && widget.promoVideoUrl!.isNotEmpty) {
      return [
        StoryItem(
          id: 'promo',
          videoUrl: widget.promoVideoUrl,
          thumbnailUrl: widget.promoVideoThumbnailUrl,
        ),
      ];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initVideos();
  }

  void _initVideos() {
    final stories = _stories;
    for (int i = 0; i < stories.length; i++) {
      final story = stories[i];
      if (story.videoUrl != null && story.videoUrl!.isNotEmpty) {
        final controller = VideoPlayerController.networkUrl(Uri.parse(story.videoUrl!));
        final index = i;
        _videoControllers[index] = controller;
        controller.initialize().then((_) {
          if (mounted) {
            setState(() {});
            // Auto-play first video
            if (index == 0) {
              controller.play();
            }
          }
        }).catchError((_) {
          if (mounted) setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    _pageController.dispose();
    super.dispose();
  }

  void _onClose() {
    for (final controller in _videoControllers.values) {
      controller.pause();
    }
    Navigator.of(context).pop();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    // Pause all videos
    for (final controller in _videoControllers.values) {
      controller.pause();
    }
    // Play current video if available
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isInitialized) {
      controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = _stories;
    final storyCount = stories.length;

    if (storyCount == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _StoryPage._placeholder(),
        ),
      );
    }

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
              onPageChanged: _onPageChanged,
              children: stories.asMap().entries.map((entry) {
                final index = entry.key;
                final story = entry.value;
                return _StoryPage(
                  story: story,
                  videoController: _videoControllers[index],
                );
              }).toList(),
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
                          children: List.generate(storyCount, (index) {
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
  final StoryItem story;
  final VideoPlayerController? videoController;

  const _StoryPage({
    required this.story,
    this.videoController,
  });

  @override
  Widget build(BuildContext context) {
    // If video controller is initialized, show video
    if (videoController != null && videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
      );
    }

    // If story has video URL, show loading indicator
    if (story.videoUrl != null && story.videoUrl!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    // Show thumbnail image if available
    if (story.thumbnailUrl != null && story.thumbnailUrl!.isNotEmpty) {
      return Center(
        child: Image.network(
          story.thumbnailUrl!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }

    // Fallback placeholder
    return _placeholder();
  }

  static Widget _placeholder() {
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
