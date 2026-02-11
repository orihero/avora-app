import '../../domain/entities/auction.dart';
import '../../domain/entities/enums/auction_progress.dart';
import '../../domain/entities/enums/auction_status.dart';

/// Data model for Auction (Appwrite document).
class AuctionModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String progress;
  final String? startAt;
  final String? votingEndAt;
  final String? createdAt;
  final String? updatedAt;

  const AuctionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    this.startAt,
    this.votingEndAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['\$id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      progress: json['progress'] as String? ?? 'voting_open',
      startAt: json['startAt'] as String?,
      votingEndAt: json['votingEndAt'] as String?,
      createdAt: json['\$createdAt'] as String? ?? json['createdAt'] as String?,
      updatedAt: json['\$updatedAt'] as String? ?? json['updatedAt'] as String?,
    );
  }

  Auction toEntity() {
    return Auction(
      id: id,
      title: title,
      description: description,
      status: _parseStatus(status),
      progress: _parseProgress(progress),
      startAt: _parseDateTime(startAt),
      votingEndAt: _parseDateTime(votingEndAt),
      createdAt: _parseDateTime(createdAt),
      updatedAt: _parseDateTime(updatedAt),
    );
  }

  static AuctionStatus _parseStatus(String s) {
    final normalized = s.toLowerCase().replaceAll(' ', '_');
    for (final e in AuctionStatus.values) {
      if (e.name == normalized) return e;
    }
    return AuctionStatus.draft;
  }

  static AuctionProgress _parseProgress(String s) {
    final normalized = s.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
    final camel = _snakeToCamel(normalized);
    for (final e in AuctionProgress.values) {
      if (e.name == normalized || e.name == camel) return e;
    }
    return AuctionProgress.votingOpen;
  }

  static String _snakeToCamel(String s) {
    final parts = s.split('_');
    if (parts.isEmpty) return s;
    return parts.first.toLowerCase() +
        parts.skip(1).map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1).toLowerCase()).join();
  }

  static DateTime? _parseDateTime(String? s) {
    if (s == null) return null;
    return DateTime.tryParse(s);
  }
}
