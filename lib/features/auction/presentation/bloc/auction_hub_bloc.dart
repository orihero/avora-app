import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/story_item_model.dart';
import '../../domain/usecases/get_auction_products.dart';
import '../../domain/usecases/get_auction_variable.dart';
import '../../domain/usecases/get_bids_for_product.dart';
import '../../domain/usecases/get_featured_auction.dart' show GetFeaturedAuction, NoParams;
import '../../domain/usecases/get_my_participation_requests.dart';
import '../../domain/usecases/get_my_votes.dart';
import '../../domain/usecases/get_winner_confirmations_for_product.dart';
import '../../domain/usecases/request_participation.dart';
import '../../domain/usecases/place_bid.dart';
import '../../domain/usecases/submit_vote.dart';
import 'auction_event.dart';
import 'auction_state.dart';

/// Bloc for the auction tab: featured auction, products, variables (e.g. promo video).
class AuctionHubBloc extends Bloc<AuctionEvent, AuctionState> {
  final GetFeaturedAuction getFeaturedAuction;
  final GetAuctionProducts getAuctionProducts;
  final GetAuctionVariable getAuctionVariable;
  final GetMyVotes getMyVotes;
  final GetMyParticipationRequests getMyParticipationRequests;
  final GetBidsForProduct getBidsForProduct;
  final GetWinnerConfirmationsForProduct getWinnerConfirmationsForProduct;
  final SubmitVote submitVote;
  final RequestParticipation requestParticipation;
  final PlaceBid placeBid;

  AuctionHubBloc({
    required this.getFeaturedAuction,
    required this.getAuctionProducts,
    required this.getAuctionVariable,
    required this.getMyVotes,
    required this.getMyParticipationRequests,
    required this.getWinnerConfirmationsForProduct,
    required this.submitVote,
    required this.requestParticipation,
    required this.placeBid,
    required this.getBidsForProduct,
  }) : super(const AuctionStateInitial()) {
    on<AuctionEventLoadAuction>(_onLoadAuction);
    on<AuctionEventRefresh>(_onRefresh);
    on<AuctionEventVote>(_onVote);
    on<AuctionEventRequestParticipation>(_onRequestParticipation);
    on<AuctionEventLoadBidsForProduct>(_onLoadBidsForProduct);
    on<AuctionEventPlaceBid>(_onPlaceBid);
    on<AuctionEventLoadWinnerConfirmations>(_onLoadWinnerConfirmations);
  }

  Future<void> _onLoadAuction(
    AuctionEventLoadAuction event,
    Emitter<AuctionState> emit,
  ) => _loadAuction(emit);

  Future<void> _onRefresh(
    AuctionEventRefresh event,
    Emitter<AuctionState> emit,
  ) => _loadAuction(emit);

  Future<void> _onVote(
    AuctionEventVote event,
    Emitter<AuctionState> emit,
  ) async {
    final result = await submitVote(SubmitVoteParams(
      auctionId: event.auctionId,
      productId: event.productId,
      userId: event.userId,
    ));
    result.fold(
      (failure) => emit(AuctionStateError(failure)),
      (_) {
        // Reload auction to reflect vote
        _loadAuction(emit);
      },
    );
  }

  Future<void> _onRequestParticipation(
    AuctionEventRequestParticipation event,
    Emitter<AuctionState> emit,
  ) async {
    final result = await requestParticipation(RequestParticipationParams(
      auctionId: event.auctionId,
      productId: event.productId,
      userId: event.userId,
      phoneNumber: event.phoneNumber,
      termsAccepted: event.termsAccepted,
    ));
    result.fold(
      (failure) => emit(AuctionStateError(failure)),
      (_) {
        _loadAuction(emit);
      },
    );
  }

  Future<void> _loadAuction(Emitter<AuctionState> emit) async {
    emit(const AuctionStateLoading());

    final videoUrlResult = await getAuctionVariable(
      const GetAuctionVariableParams(key: 'auction_promo_video_url'),
    );
    final String? promoVideoUrl = videoUrlResult.fold(
      (_) => null,
      (v) => v.isEmpty ? null : v,
    );

    final thumbnailResult = await getAuctionVariable(
      const GetAuctionVariableParams(key: 'auction_promo_video_thumbnail_url'),
    );
    final String? promoVideoThumbnailUrl = thumbnailResult.fold(
      (_) => null,
      (v) => v.isEmpty ? null : v,
    );

    final storyThumbnailResult = await getAuctionVariable(
      const GetAuctionVariableParams(key: 'auction_story_thumbnail_url'),
    );
    final String? storyThumbnail = storyThumbnailResult.fold(
      (_) => null,
      (v) => v.isEmpty ? null : v,
    );

    final storiesResult = await getAuctionVariable(
      const GetAuctionVariableParams(key: 'auction_stories'),
    );
    final String storiesJson = storiesResult.fold(
      (_) => '',
      (v) => v,
    );
    final stories = StoryItemModel.parseStoriesJson(storiesJson);

    final auctionResult = await getFeaturedAuction(NoParams());
    await auctionResult.fold(
      (failure) async => emit(AuctionStateError(failure)),
      (auction) async {
        if (auction == null) {
          emit(AuctionStateNoAuction(
            promoVideoUrl: promoVideoUrl,
            promoVideoThumbnailUrl: promoVideoThumbnailUrl,
            storyThumbnail: storyThumbnail,
            stories: stories.isNotEmpty ? stories : null,
          ));
          return;
        }
        final productsResult = await getAuctionProducts(
          GetAuctionProductsParams(auctionId: auction.id),
        );
        productsResult.fold(
          (failure) => emit(AuctionStateError(failure)),
          (products) => emit(AuctionStateHasAuction(
                auction: auction,
                products: products,
                promoVideoUrl: promoVideoUrl,
                promoVideoThumbnailUrl: promoVideoThumbnailUrl,
                liveBids: null,
                liveProductId: null,
                winnerConfirmations: null,
                winnerProductId: null,
              )),
        );
      },
    );
  }

  Future<void> _onLoadBidsForProduct(
    AuctionEventLoadBidsForProduct event,
    Emitter<AuctionState> emit,
  ) async {
    final state = this.state;
    if (state is! AuctionStateHasAuction) return;
    final result = await getBidsForProduct(GetBidsForProductParams(
      auctionId: event.auctionId,
      productId: event.productId,
    ));
    result.fold(
      (failure) => emit(AuctionStateError(failure)),
      (bids) => emit(AuctionStateHasAuction(
            auction: state.auction,
            products: state.products,
            promoVideoUrl: state.promoVideoUrl,
            promoVideoThumbnailUrl: state.promoVideoThumbnailUrl,
            liveBids: bids,
            liveProductId: event.productId,
            winnerConfirmations: state.winnerConfirmations,
            winnerProductId: state.winnerProductId,
          )),
    );
  }

  Future<void> _onLoadWinnerConfirmations(
    AuctionEventLoadWinnerConfirmations event,
    Emitter<AuctionState> emit,
  ) async {
    final state = this.state;
    if (state is! AuctionStateHasAuction) return;
    final result = await getWinnerConfirmationsForProduct(
      GetWinnerConfirmationsForProductParams(
        auctionId: event.auctionId,
        productId: event.productId,
      ),
    );
    result.fold(
      (failure) => emit(AuctionStateError(failure)),
      (confirmations) => emit(AuctionStateHasAuction(
            auction: state.auction,
            products: state.products,
            promoVideoUrl: state.promoVideoUrl,
            promoVideoThumbnailUrl: state.promoVideoThumbnailUrl,
            liveBids: state.liveBids,
            liveProductId: state.liveProductId,
            winnerConfirmations: confirmations,
            winnerProductId: event.productId,
          )),
    );
  }

  Future<void> _onPlaceBid(
    AuctionEventPlaceBid event,
    Emitter<AuctionState> emit,
  ) async {
    final result = await placeBid(PlaceBidParams(
      auctionId: event.auctionId,
      productId: event.productId,
      userId: event.userId,
      phoneNumber: event.phoneNumber,
      amount: event.amount,
    ));
    result.fold(
      (failure) => emit(AuctionStateError(failure)),
      (_) {
        add(AuctionEventLoadBidsForProduct(
          auctionId: event.auctionId,
          productId: event.productId,
        ));
      },
    );
  }
}
