import 'package:flutter/material.dart';

/// Modal that shows an explanation of the auction feature.
class AuctionInfoModal {
  static const String _defaultExplanation = '''
Auctions let you bid on selected products in curated, scheduled live events.

• Vote for products during the voting phase.
• Request participation to join live bidding (approval required).
• Watch live auctions and see current price, countdown, and results.
• Only approved participants can place bids during the live auction.

One auction is active at a time. Check back for upcoming auctions.''';

  /// Shows a bottom sheet or dialog with auction explanation.
  static Future<void> show(
    BuildContext context, {
    String? explanationText,
  }) {
    final text = explanationText ?? _defaultExplanation;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Text(
                  'About Auctions',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
