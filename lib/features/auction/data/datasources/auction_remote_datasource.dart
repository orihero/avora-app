import '../../../../core/error/exceptions.dart';
import '../models/auction_model.dart';
import '../models/auction_product_model.dart';
import '../models/bid_model.dart';
import '../models/participation_request_model.dart';
import '../models/vote_model.dart';
import '../models/winner_confirmation_model.dart';

/// Remote data source for auction-related data (Appwrite).
abstract class AuctionRemoteDataSource {
  Future<AuctionModel?> getFeaturedAuction();
  Future<AuctionModel?> getAuctionById(String id);
  Future<List<AuctionProductModel>> getAuctionProducts(String auctionId);
  Future<String> getVariable(String key);
  Future<List<VoteModel>> getMyVotes(String auctionId, String userId);
  Future<VoteModel> submitVote({
    required String auctionId,
    required String productId,
    required String userId,
  });
  Future<List<ParticipationRequestModel>> getMyParticipationRequests(
    String auctionId,
    String userId,
  );
  Future<ParticipationRequestModel> createParticipationRequest({
    required String auctionId,
    required String productId,
    required String userId,
    required String phoneNumber,
    required bool termsAccepted,
  });
  Future<List<BidModel>> getBidsForProduct({
    required String auctionId,
    required String productId,
  });
  Future<BidModel> createBid({
    required String auctionId,
    required String productId,
    required String userId,
    required String? phoneNumber,
    required double amount,
  });
  Future<List<WinnerConfirmationModel>> getWinnerConfirmationsForProduct({
    required String auctionId,
    required String productId,
  });
}
