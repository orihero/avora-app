import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../../l10n/l10n.dart';

class OnboardingPage3 extends StatefulWidget {
  const OnboardingPage3({super.key});

  @override
  State<OnboardingPage3> createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3>
    with TickerProviderStateMixin {
  late final AnimationController _scrollAnimationController;
  late final AnimationController _textAnimationController;
  late final Animation<double> _scrollAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _textScaleAnimation;

  // Furniture image URLs for the grid - each column gets different furniture images
  final List<List<String>> _columnImages = [
    // Column 1 (scrolls down) - chairs and seating
    [
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=400&fit=crop', // Pink chair
      'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=300&h=400&fit=crop', // Modern chair
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=400&fit=crop', // Green sofa
      'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=300&h=400&fit=crop', // Wooden chair
      'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=300&h=400&fit=crop', // Cozy sofa
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=400&fit=crop', // Pink chair repeat
    ],
    // Column 2 (scrolls up) - living room & decor
    [
      'https://images.unsplash.com/photo-1618220179428-22790b461013?w=300&h=400&fit=crop', // Modern interior
      'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=300&h=400&fit=crop', // Orange chair
      'https://images.unsplash.com/photo-1540574163026-643ea20ade25?w=300&h=400&fit=crop', // Dining setup
      'https://images.unsplash.com/photo-1592078615290-033ee584e267?w=300&h=400&fit=crop', // Pendant lamp
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=400&fit=crop', // Green sofa
      'https://images.unsplash.com/photo-1618220179428-22790b461013?w=300&h=400&fit=crop', // Modern interior repeat
    ],
    // Column 3 (scrolls down) - tables and bedroom
    [
      'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=300&h=400&fit=crop', // Desk setup
      'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=300&h=400&fit=crop', // Bedroom
      'https://images.unsplash.com/photo-1503602642458-232111445657?w=300&h=400&fit=crop', // Minimalist desk
      'https://images.unsplash.com/photo-1449247709967-d4461a6a6103?w=300&h=400&fit=crop', // Table
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=400&fit=crop', // Green sofa
      'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=300&h=400&fit=crop', // Desk repeat
    ],
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Scroll animation with deceleration effect
    // Using a longer duration and custom curve for natural deceleration
    _scrollAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3500), // 3.5 seconds for smooth deceleration
      vsync: this,
    );

    // Animation goes from 0 to 1, we'll use this to calculate scroll offset
    // Using Curves.easeOutCubic for a nice deceleration feel that slows down naturally
    _scrollAnimation = CurvedAnimation(
      parent: _scrollAnimationController,
      curve: Curves.easeOutCubic, // Strong deceleration at the end
    );

    // Text animation - fade and scale
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ));

    _textScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ));

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scrollAnimationController.forward();
        // Start text animation after scroll has started
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            _textAnimationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F4F8), // Light cyan/teal tint
            Color(0xFFFCE4EC), // Light pink
            Color(0xFFFFF8E1), // Light amber
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top section: Animated scrolling image grid (rotated -30 degrees)
            Expanded(
              flex: 55,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ClipRect(
                    child: Transform.rotate(
                      angle: -30 * math.pi / 180, // -30 degrees in radians
                      child: Transform.scale(
                        scale: 1.5, // Scale up to fill corners after rotation
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
                            child: AnimatedBuilder(
                              animation: _scrollAnimation,
                              builder: (context, child) {
                                return _buildImageGrid();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom section: Text and progress dots
            Expanded(
              flex: 35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    // Text with animation
                    AnimatedBuilder(
                      animation: _textAnimationController,
                      builder: (context, child) {
                        final l10n = AppLocalizations.of(context);
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: Text(
                              l10n.onboardingPage3Text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 2 ? 10 : 8,
                          height: index == 2 ? 10 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 2
                                ? const Color(0xFF424242)
                                : const Color(0xFF424242).withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    // Total scroll distance (how much the columns move)
    const double maxScrollDistance = 120.0;
    final scrollOffset = _scrollAnimation.value * maxScrollDistance;

    return Stack(
      children: [
        // The actual image columns
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1 - scrolls DOWN
              Expanded(
                child: _buildScrollingColumn(
                  images: _columnImages[0],
                  scrollOffset: scrollOffset,
                  scrollDown: true,
                  initialOffset: 0,
                ),
              ),
              const SizedBox(width: 10),
              // Column 2 - scrolls UP (starts lower)
              Expanded(
                child: _buildScrollingColumn(
                  images: _columnImages[1],
                  scrollOffset: scrollOffset,
                  scrollDown: false,
                  initialOffset: -60, // Start higher to scroll down into view
                ),
              ),
              const SizedBox(width: 10),
              // Column 3 - scrolls DOWN
              Expanded(
                child: _buildScrollingColumn(
                  images: _columnImages[2],
                  scrollOffset: scrollOffset,
                  scrollDown: true,
                  initialOffset: -30, // Slight offset for visual variety
                ),
              ),
            ],
          ),
        ),
        // Top fade gradient overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE8F4F8).withOpacity(0.95),
                  const Color(0xFFE8F4F8).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        // Bottom fade gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFFFCE4EC).withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollingColumn({
    required List<String> images,
    required double scrollOffset,
    required bool scrollDown,
    required double initialOffset,
  }) {
    // Calculate the transform offset based on scroll direction
    final offset = scrollDown 
        ? initialOffset + scrollOffset 
        : initialOffset - scrollOffset;

    return ClipRect(
      child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: Offset(0, offset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: images.map((imageUrl) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _buildImageCard(imageUrl),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7BB5C9),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFCE4EC),
                    const Color(0xFFE8F4F8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.chair_outlined,
                color: Color(0xFFBDBDBD),
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
