import 'package:equatable/equatable.dart';

/// Events for AuctionHubBloc.
abstract class AuctionEvent extends Equatable {
  const AuctionEvent();
  @override
  List<Object?> get props => [];
}

class AuctionEventLoadAuction extends AuctionEvent {
  const AuctionEventLoadAuction();
}

class AuctionEventRefresh extends AuctionEvent {
  const AuctionEventRefresh();
}

class AuctionEventVote extends AuctionEvent {
  final String auctionId;
  final String productId;
  final String userId;
  const AuctionEventVote({
    required this.auctionId,
    required this.productId,
    required this.userId,
  });
  @override
  List<Object?> get props => [auctionId, productId, userId];
}

class AuctionEventRequestParticipation extends AuctionEvent {
  final String auctionId;
  final String productId;
  final String userId;
  final String phoneNumber;
  final bool termsAccepted;
  const AuctionEventRequestParticipation({
    required this.auctionId,
    required this.productId,
    required this.userId,
    required this.phoneNumber,
    required this.termsAccepted,
  });
  @override
  List<Object?> get props => [auctionId, productId, userId, phoneNumber, termsAccepted];
}

class AuctionEventLoadBidsForProduct extends AuctionEvent {
  final String auctionId;
  final String productId;
  const AuctionEventLoadBidsForProduct({
    required this.auctionId,
    required this.productId,
  });
  @override
  List<Object?> get props => [auctionId, productId];
}

class AuctionEventPlaceBid extends AuctionEvent {
  final String auctionId;
  final String productId;
  final String userId;
  final String? phoneNumber;
  final double amount;
  const AuctionEventPlaceBid({
    required this.auctionId,
    required this.productId,
    required this.userId,
    this.phoneNumber,
    required this.amount,
  });
  @override
  List<Object?> get props => [auctionId, productId, userId, phoneNumber, amount];
}

class AuctionEventLoadWinnerConfirmations extends AuctionEvent {
  final String auctionId;
  final String productId;
  const AuctionEventLoadWinnerConfirmations({
    required this.auctionId,
    required this.productId,
  });
  @override
  List<Object?> get props => [auctionId, productId];
}
