import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auction.dart';
import '../../domain/entities/auction_product.dart';
import '../../domain/entities/bid.dart';
import '../../domain/entities/story_item.dart';
import '../../domain/entities/winner_confirmation.dart';

/// States for AuctionHubBloc.
abstract class AuctionState extends Equatable {
  const AuctionState();
  @override
  List<Object?> get props => [];
}

class AuctionStateInitial extends AuctionState {
  const AuctionStateInitial();
}

class AuctionStateLoading extends AuctionState {
  const AuctionStateLoading();
}

class AuctionStateNoAuction extends AuctionState {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final String? storyThumbnail;
  final List<StoryItem>? stories;
  const AuctionStateNoAuction({
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    this.storyThumbnail,
    this.stories,
  });
  @override
  List<Object?> get props => [promoVideoUrl, promoVideoThumbnailUrl, storyThumbnail, stories];
}

class AuctionStateHasAuction extends AuctionState {
  final Auction auction;
  final List<AuctionProduct> products;
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final List<Bid>? liveBids;
  final String? liveProductId;
  final List<WinnerConfirmation>? winnerConfirmations;
  final String? winnerProductId;
  const AuctionStateHasAuction({
    required this.auction,
    required this.products,
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    this.liveBids,
    this.liveProductId,
    this.winnerConfirmations,
    this.winnerProductId,
  });
  @override
  List<Object?> get props => [
        auction,
        products,
        promoVideoUrl,
        promoVideoThumbnailUrl,
        liveBids,
        liveProductId,
        winnerConfirmations,
        winnerProductId,
      ];
}

class AuctionStateError extends AuctionState {
  final Failure failure;
  const AuctionStateError(this.failure);
  @override
  List<Object?> get props => [failure];
}
