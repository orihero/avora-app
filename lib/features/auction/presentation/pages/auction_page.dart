import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/auction.dart';
import '../../domain/entities/auction_product.dart';
import '../../domain/entities/bid.dart';
import '../../domain/entities/enums/auction_progress.dart';
import '../../domain/entities/winner_confirmation.dart';
import '../bloc/auction_event.dart';
import '../bloc/auction_hub_bloc.dart';
import '../bloc/auction_state.dart';
import '../widgets/auction_info_modal.dart';
import '../widgets/auction_stories_view.dart';
import '../widgets/full_screen_video_page.dart';
import '../widgets/participation_request_modal.dart';

/// Auction tab root: no auction (promo video) or has auction (progress-based UI).
class AuctionPage extends StatelessWidget {
  const AuctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AuctionHubBloc>()..add(const AuctionEventLoadAuction()),
      child: const _AuctionPageBody(),
    );
  }
}

class _AuctionPageBody extends StatelessWidget {
  const _AuctionPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocBuilder<AuctionHubBloc, AuctionState>(
        builder: (context, state) {
          if (state is AuctionStateInitial || state is AuctionStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AuctionStateNoAuction) {
            return _NoAuctionContent(
              promoVideoUrl: state.promoVideoUrl,
              promoVideoThumbnailUrl: state.promoVideoThumbnailUrl,
              onRefresh: () =>
                  context.read<AuctionHubBloc>().add(const AuctionEventRefresh()),
            );
          }
          if (state is AuctionStateHasAuction) {
            return _HasAuctionContent(
              auction: state.auction,
              products: state.products,
              promoVideoUrl: state.promoVideoUrl,
              promoVideoThumbnailUrl: state.promoVideoThumbnailUrl,
              userId: '',
              userPhone: '',
              liveBids: state.liveBids,
              liveProductId: state.liveProductId,
              winnerConfirmations: state.winnerConfirmations,
              winnerProductId: state.winnerProductId,
              onRefresh: () =>
                  context.read<AuctionHubBloc>().add(const AuctionEventRefresh()),
            );
          }
          if (state is AuctionStateError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.failure.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AuctionHubBloc>()
                        .add(const AuctionEventRefresh()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NoAuctionContent extends StatelessWidget {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final VoidCallback onRefresh;

  const _NoAuctionContent({
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NoAuctionHeader(
          promoVideoUrl: promoVideoUrl,
          promoVideoThumbnailUrl: promoVideoThumbnailUrl,
          onStoriesTap: () => AuctionStoriesView.open(
            context,
            promoVideoUrl: promoVideoUrl,
            promoVideoThumbnailUrl: promoVideoThumbnailUrl,
          ),
          onInfoTap: () => AuctionInfoModal.show(context),
        ),
        Expanded(
          child: _NoAuctionPlayArea(
            promoVideoUrl: promoVideoUrl,
            promoVideoThumbnailUrl: promoVideoThumbnailUrl,
            onRefresh: onRefresh,
          ),
        ),
      ],
    );
  }
}

class _NoAuctionHeader extends StatelessWidget {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final VoidCallback onStoriesTap;
  final VoidCallback onInfoTap;

  const _NoAuctionHeader({
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    required this.onStoriesTap,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onStoriesTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: promoVideoThumbnailUrl != null &&
                        promoVideoThumbnailUrl!.isNotEmpty
                    ? Image.network(
                        promoVideoThumbnailUrl!,
                        fit: BoxFit.cover,
                        width: 56,
                        height: 56,
                        errorBuilder: (_, __, ___) => _placeholderAvatar(),
                      )
                    : _placeholderAvatar(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Auction',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF6B6B6B)),
            onPressed: onInfoTap,
          ),
        ],
      ),
    );
  }

  Widget _placeholderAvatar() {
    return const ColoredBox(
      color: Color(0xFFE8E8E8),
      child: Center(
        child: Icon(Icons.gavel, color: Color(0xFFB0B0B0), size: 28),
      ),
    );
  }
}

class _NoAuctionPlayArea extends StatelessWidget {
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final VoidCallback onRefresh;

  const _NoAuctionPlayArea({
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final hasVideo =
        promoVideoUrl != null && promoVideoUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: hasVideo
                    ? () => FullScreenVideoPage.open(context, promoVideoUrl!)
                    : null,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (promoVideoThumbnailUrl != null &&
                            promoVideoThumbnailUrl!.isNotEmpty)
                          Image.network(
                            promoVideoThumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _placeholderContent(hasVideo),
                          )
                        else
                          _placeholderContent(hasVideo),
                        Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 72,
                            color: hasVideo
                                ? Colors.white.withValues(alpha: 0.9)
                                : const Color(0xFFB0B0B0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _placeholderContent(bool hasVideo) {
    return const ColoredBox(
      color: Color(0xFFE8E8E8),
      child: Center(
        child: Icon(Icons.gavel, size: 48, color: Color(0xFFB0B0B0)),
      ),
    );
  }
}

class _HasAuctionContent extends StatelessWidget {
  final Auction auction;
  final List<AuctionProduct> products;
  final String? promoVideoUrl;
  final String? promoVideoThumbnailUrl;
  final String userId;
  final String userPhone;
  final List<Bid>? liveBids;
  final String? liveProductId;
  final List<WinnerConfirmation>? winnerConfirmations;
  final String? winnerProductId;
  final VoidCallback onRefresh;

  const _HasAuctionContent({
    required this.auction,
    required this.products,
    this.promoVideoUrl,
    this.promoVideoThumbnailUrl,
    required this.userId,
    required this.userPhone,
    this.liveBids,
    this.liveProductId,
    this.winnerConfirmations,
    this.winnerProductId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auction.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                if (auction.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      auction.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (products.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No products in this auction yet.',
                style: TextStyle(color: Color(0xFFB0B0B0)),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = products[index];
                  final canVote = auction.progress == AuctionProgress.votingOpen;
                  final canParticipate =
                      auction.progress == AuctionProgress.participationApproval;
                  final isLive =
                      auction.progress == AuctionProgress.liveAuction;
                  final isLiveProduct = p.selectedForLive;
                  final showLiveBids = isLive &&
                      liveProductId == p.productId &&
                      liveBids != null;
                  Widget? trailing;
                  if (canVote && userId.isNotEmpty) {
                    trailing = TextButton(
                      onPressed: () {
                        context.read<AuctionHubBloc>().add(
                              AuctionEventVote(
                                auctionId: auction.id,
                                productId: p.productId,
                                userId: userId,
                              ),
                            );
                      },
                      child: const Text('Vote'),
                    );
                  } else if (canParticipate && userId.isNotEmpty) {
                    trailing = TextButton(
                      onPressed: () {
                        ParticipationRequestModal.show(
                          context,
                          productId: p.productId,
                          initialPhoneNumber: userPhone,
                          onSubmit: (phone, terms) {
                            context.read<AuctionHubBloc>().add(
                                  AuctionEventRequestParticipation(
                                    auctionId: auction.id,
                                    productId: p.productId,
                                    userId: userId,
                                    phoneNumber: phone,
                                    termsAccepted: terms,
                                  ),
                                );
                          },
                        );
                      },
                      child: const Text('Participate'),
                    );
                  } else if (isLive && isLiveProduct) {
                    trailing = TextButton(
                      onPressed: () {
                        context.read<AuctionHubBloc>().add(
                              AuctionEventLoadBidsForProduct(
                                auctionId: auction.id,
                                productId: p.productId,
                              ),
                            );
                      },
                      child: Text(showLiveBids ? 'Refresh bids' : 'View bids'),
                    );
                  } else if ((auction.progress == AuctionProgress.winnerConfirmation ||
                          auction.progress == AuctionProgress.fallbackResolution) &&
                      isLiveProduct) {
                    trailing = TextButton(
                      onPressed: () {
                        context.read<AuctionHubBloc>().add(
                              AuctionEventLoadWinnerConfirmations(
                                auctionId: auction.id,
                                productId: p.productId,
                              ),
                            );
                      },
                      child: const Text('View result'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        'Product ${p.productId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      subtitle: Text(
                        'Min bid: ${p.minBidPrice}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                      trailing: trailing,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.white,
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        if (winnerConfirmations != null && winnerProductId != null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Auction result',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...winnerConfirmations!.map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${c.fallbackRank != null ? "Fallback ${c.fallbackRank}" : "Winner"}: ${c.status.name}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        if (liveBids != null && liveProductId != null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live bids',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current price: ${_currentPrice(liveBids!, products, liveProductId)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      if (liveBids!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...liveBids!.take(5).map(
                              (b) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'Bid: ${b.amount}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFB0B0B0),
                                  ),
                                ),
                              ),
                            ),
                      ],
                      if (userId.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final product = _productById(
                                  products, liveProductId!);
                              final minBid = product?.minBidPrice ?? 0;
                              final currentMax = liveBids!.isEmpty
                                  ? minBid
                                  : liveBids!
                                      .map((b) => b.amount)
                                      .reduce((a, b) => a > b ? a : b);
                              final nextBid = currentMax + 1;
                              context.read<AuctionHubBloc>().add(
                                    AuctionEventPlaceBid(
                                      auctionId: auction.id,
                                      productId: liveProductId!,
                                      userId: userId,
                                      phoneNumber: userPhone.isNotEmpty
                                          ? userPhone
                                          : null,
                                      amount: nextBid,
                                    ),
                                  );
                            },
                            child: const Text('Place bid'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Refresh'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static double _currentPrice(
    List<Bid> bids,
    List<AuctionProduct> products,
    String? productId,
  ) {
    if (bids.isNotEmpty) {
      return bids.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
    }
    final p = _productById(products, productId);
    return p?.minBidPrice ?? 0;
  }

  static AuctionProduct? _productById(
    List<AuctionProduct> products,
    String? productId,
  ) {
    if (productId == null) return null;
    for (final e in products) {
      if (e.productId == productId) return e;
    }
    return null;
  }
}
