import 'dart:convert';
import '../../domain/entities/story_item.dart';

/// Data model for StoryItem (parsed from AppWrite variable JSON).
class StoryItemModel {
  final String id;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int? duration;

  const StoryItemModel({
    required this.id,
    this.videoUrl,
    this.thumbnailUrl,
    this.duration,
  });

  factory StoryItemModel.fromJson(Map<String, dynamic> json) {
    return StoryItemModel(
      id: json['id'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? json['video_url'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? json['thumbnail_url'] as String?,
      duration: json['duration'] as int?,
    );
  }

  StoryItem toEntity() {
    return StoryItem(
      id: id,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
    );
  }

  static List<StoryItem> parseStoriesJson(String jsonString) {
    if (jsonString.isEmpty) return [];
    try {
      final dynamic parsed = json.decode(jsonString);
      if (parsed is List) {
        return parsed
            .map((item) {
              if (item is Map<String, dynamic>) {
                return StoryItemModel.fromJson(item).toEntity();
              }
              return null;
            })
            .whereType<StoryItem>()
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
