import 'package:appwrite/appwrite.dart';

import '../../../../core/network/appwrite_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auction_model.dart';
import '../models/auction_product_model.dart';
import '../models/bid_model.dart';
import '../models/participation_request_model.dart';
import '../models/vote_model.dart';
import '../models/winner_confirmation_model.dart';
import 'auction_remote_datasource.dart';

/// Appwrite implementation of auction remote data source.
/// Public reads (auctions, variables, bids list, etc.) use a guest client to avoid
/// the "users" role missing collections.read scope. User-specific operations
/// (votes, participation, place bid) use the shared [client] with session.
class AuctionRemoteDataSourceImpl implements AuctionRemoteDataSource {
  final AppwriteConfig config;
  final Client _client;
  late final Databases _databases;
  late final Databases _databasesGuest;

  AuctionRemoteDataSourceImpl({
    required this.config,
    required Client client,
  }) : _client = client {
    _databases = Databases(_client);
    // Guest client: same endpoint/project, no session. Used for public reads so
    // we don't require the "users" role to have collections.read scope.
    // Create a completely fresh client with no session cookies/storage.
    if (config.isConfigured) {
      final guestClient = Client()
        ..setEndpoint(config.endpoint)
        ..setProject(config.projectId)
        ..setSelfSigned(status: false); // Ensure no session is attached
      // Explicitly clear any session that might exist
      try {
        final guestAccount = Account(guestClient);
        guestAccount.deleteSessions().catchError((_) {}); // Ignore errors if no session
      } catch (_) {}
      _databasesGuest = Databases(guestClient);
    } else {
      _databasesGuest = Databases(Client());
    }
  }

  void _ensureConfigured() {
    if (!config.isConfigured) {
      throw ServerException('Appwrite is not configured');
    }
  }

  Map<String, dynamic> _documentToMap(dynamic doc) {
    if (doc == null) return {};
    if (doc is Map<String, dynamic>) return Map<String, dynamic>.from(doc);
    if (doc is Map) return Map<String, dynamic>.from(doc);
    final d = doc as dynamic;
    final map = <String, dynamic>{
      '\$id': d.$id ?? d.id,
      '\$createdAt': d.$createdAt ?? d.createdAt,
      '\$updatedAt': d.$updatedAt ?? d.updatedAt,
    };
    final data = d.data;
    if (data is Map<String, dynamic>) map.addAll(data);
    if (data is Map) map.addAll(Map<String, dynamic>.from(data));
    return map;
  }

  @override
  Future<AuctionModel?> getFeaturedAuction() async {
    if (!config.isConfigured) return null;
    try {
      final list = await _databasesGuest.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.auctionsCollectionId,
        queries: [
          Query.orderDesc('\$createdAt'),
          Query.limit(10),
        ],
      );
      if (list.documents.isEmpty) return null;
      for (final doc in list.documents) {
        final map = _documentToMap(doc);
        final status = map['status'] as String? ?? 'draft';
        final progress = map['progress'] as String? ?? 'voting_open';
        if (status == 'active') return AuctionModel.fromJson(map);
        if (status == 'completed' && list.documents.indexOf(doc) == 0) {
          return AuctionModel.fromJson(map);
        }
      }
      final first = list.documents.first;
      return AuctionModel.fromJson(_documentToMap(first));
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch auction');
    }
  }

  @override
  Future<AuctionModel?> getAuctionById(String id) async {
    if (!config.isConfigured) return null;
    try {
      final doc = await _databasesGuest.getDocument(
        databaseId: config.databaseId,
        collectionId: config.auctionsCollectionId,
        documentId: id,
      );
      return AuctionModel.fromJson(_documentToMap(doc));
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      throw ServerException(e.message ?? 'Failed to fetch auction');
    }
  }

  @override
  Future<List<AuctionProductModel>> getAuctionProducts(String auctionId) async {
    if (!config.isConfigured) return [];
    try {
      final list = await _databasesGuest.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.auctionProductsCollectionId,
        queries: [
          Query.equal('auction', [auctionId]),
          Query.orderAsc('sortOrder'),
        ],
      );
      return list.documents
          .map((d) => AuctionProductModel.fromJson(_documentToMap(d)))
          .toList();
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch auction products');
    }
  }

  @override
  Future<String> getVariable(String key) async {
    if (!config.isConfigured) return '';
    try {
      final list = await _databasesGuest.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.variablesCollectionId,
        queries: [Query.equal('key', [key]), Query.limit(1)],
      );
      if (list.documents.isEmpty) return '';
      final map = _documentToMap(list.documents.first);
      return map['value'] as String? ?? '';
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch variable');
    }
  }

  @override
  Future<List<VoteModel>> getMyVotes(String auctionId, String userId) async {
    _ensureConfigured();
    try {
      final list = await _databases.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.votesCollectionId,
        queries: [
          Query.equal('auction', [auctionId]),
          Query.equal('userId', [userId]),
        ],
      );
      return list.documents
          .map((d) => VoteModel.fromJson(_documentToMap(d)))
          .toList();
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch votes');
    }
  }

  @override
  Future<VoteModel> submitVote({
    required String auctionId,
    required String productId,
    required String userId,
  }) async {
    _ensureConfigured();
    try {
      final existing = await _databases.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.votesCollectionId,
        queries: [
          Query.equal('auction', [auctionId]),
          Query.equal('userId', [userId]),
          Query.equal('product', [productId]),
        ],
      );
      final data = {
        'auction': auctionId,
        'product': productId,
        'userId': userId,
      };
      if (existing.documents.isNotEmpty) {
        final docId = (existing.documents.first as dynamic).$id ?? (existing.documents.first as dynamic).id;
        final doc = await _databases.updateDocument(
          databaseId: config.databaseId,
          collectionId: config.votesCollectionId,
          documentId: docId,
          data: data,
        );
        return VoteModel.fromJson(_documentToMap(doc));
      }
      final doc = await _databases.createDocument(
        databaseId: config.databaseId,
        collectionId: config.votesCollectionId,
        documentId: ID.unique(),
        data: data,
      );
      return VoteModel.fromJson(_documentToMap(doc));
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to submit vote');
    }
  }

  @override
  Future<List<ParticipationRequestModel>> getMyParticipationRequests(
    String auctionId,
    String userId,
  ) async {
    _ensureConfigured();
    try {
      final list = await _databases.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.participationRequestsCollectionId,
        queries: [
          Query.equal('auction', [auctionId]),
          Query.equal('userId', [userId]),
        ],
      );
      return list.documents
          .map((d) => ParticipationRequestModel.fromJson(_documentToMap(d)))
          .toList();
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch participation requests');
    }
  }

  @override
  Future<ParticipationRequestModel> createParticipationRequest({
    required String auctionId,
    required String productId,
    required String userId,
    required String phoneNumber,
    required bool termsAccepted,
  }) async {
    _ensureConfigured();
    try {
      final doc = await _databases.createDocument(
        databaseId: config.databaseId,
        collectionId: config.participationRequestsCollectionId,
        documentId: ID.unique(),
        data: {
          'auction': auctionId,
          'product': productId,
          'userId': userId,
          'phoneNumber': phoneNumber,
          'status': 'pending',
          'termsAccepted': termsAccepted,
        },
      );
      return ParticipationRequestModel.fromJson(_documentToMap(doc));
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to create participation request');
    }
  }

  @override
  Future<List<BidModel>> getBidsForProduct({
    required String auctionId,
    required String productId,
  }) async {
    _ensureConfigured();
    try {
      final list = await _databasesGuest.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.bidsCollectionId,
        queries: [
          Query.equal('auction', [auctionId]),
          Query.equal('product', [productId]),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return list.documents
          .map((d) => BidModel.fromJson(_documentToMap(d)))
          .toList();
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch bids');
    }
  }

  @override
  Future<BidModel> createBid({
    required String auctionId,
    required String productId,
    required String userId,
    required String? phoneNumber,
    required double amount,
  }) async {
    _ensureConfigured();
    try {
      final doc = await _databases.createDocument(
        databaseId: config.databaseId,
        collectionId: config.bidsCollectionId,
        documentId: ID.unique(),
        data: {
          'auction': auctionId,
          'product': productId,
          'userId': userId,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'amount': amount,
        },
      );
      return BidModel.fromJson(_documentToMap(doc));
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to place bid');
    }
  }

  @override
  Future<List<WinnerConfirmationModel>> getWinnerConfirmationsForProduct({
    required String auctionId,
    required String productId,
  }) async {
    _ensureConfigured();
    try {
      final list = await _databasesGuest.listDocuments(
        databaseId: config.databaseId,
        collectionId: config.winnerConfirmationCollectionId,
        queries: [
          Query.equal('auction', [auctionId]),
          Query.equal('product', [productId]),
        ],
      );
      return list.documents
          .map((d) => WinnerConfirmationModel.fromJson(_documentToMap(d)))
          .toList();
    } on AppwriteException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch winner confirmations');
    }
  }
}
