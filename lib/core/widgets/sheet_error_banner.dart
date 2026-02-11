import 'dart:async';
import 'package:flutter/material.dart';

/// Error banner that slides in from the top. Use inside bottom sheets so errors
/// appear above the sheet content instead of as SnackBars.
class SheetErrorBanner extends StatefulWidget {
  const SheetErrorBanner({
    super.key,
    this.message,
    this.onDismiss,
  });

  final String? message;
  final VoidCallback? onDismiss;

  @override
  State<SheetErrorBanner> createState() => _SheetErrorBannerState();
}

class _SheetErrorBannerState extends State<SheetErrorBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  /// Keeps the last non-null message so we can show it during slide-out.
  String? _displayedMessage;

  Timer? _autoDismissTimer;
  static const _autoDismissDuration = Duration(milliseconds: 2500);

  void _startAutoDismissTimer() {
    _autoDismissTimer?.cancel();
    if (widget.onDismiss == null) return;
    _autoDismissTimer = Timer(_autoDismissDuration, () {
      if (!mounted) return;
      widget.onDismiss?.call();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.addStatusListener(_onStatusChanged);
    if (widget.message != null) {
      _displayedMessage = widget.message;
      _controller.forward();
      _startAutoDismissTimer();
    }
  }

  @override
  void didUpdateWidget(SheetErrorBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != null) {
      _displayedMessage = widget.message;
      _controller.forward();
      _startAutoDismissTimer();
    } else {
      _autoDismissTimer?.cancel();
      _autoDismissTimer = null;
      if (oldWidget.message != null) {
        _controller.reverse();
      }
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && mounted) {
      setState(() => _displayedMessage = null);
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedMessage == null || _displayedMessage!.isEmpty) {
      return const SizedBox.shrink();
    }
    final topPadding = MediaQuery.of(context).padding.top;
    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, 12 + topPadding, 16, 12),
          decoration: BoxDecoration(
            color: Colors.red.shade700,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            right: false,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _displayedMessage!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.onDismiss != null)
                  IconButton(
                    onPressed: widget.onDismiss,
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
