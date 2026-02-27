import 'package:equatable/equatable.dart';

/// Entity representing a story item (video or image) for Instagram-like stories.
class StoryItem extends Equatable {
  final String id;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int? duration; // Duration in milliseconds, optional

  const StoryItem({
    required this.id,
    this.videoUrl,
    this.thumbnailUrl,
    this.duration,
  });

  @override
  List<Object?> get props => [id, videoUrl, thumbnailUrl, duration];
}
