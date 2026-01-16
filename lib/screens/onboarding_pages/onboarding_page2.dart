import 'package:flutter/material.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2>
    with TickerProviderStateMixin {
  late final AnimationController _imageAnimationController;
  late final AnimationController _textAnimationController;
  late final Animation<double> _zoomAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _textScaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Image animation - zoom out and slide right
    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000), // 2 seconds for smooth animation
      vsync: this,
    );

    // Zoom animation: start zoomed in on left side, zoom out to show full image
    _zoomAnimation = Tween<double>(
      begin: 2.5, // Start zoomed in (focusing on left side)
      end: 1.0,   // End at normal scale (full image visible)
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut), // Zoom happens in first 60%
    ));

    // Slide animation: start from left, slide to right to show the chair
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0.0), // Start with left side visible (offset to left)
      end: Offset.zero,                // End at center (chair visible)
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut), // Slide happens after zoom starts
    ));

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
        _imageAnimationController.forward();
        // Start text animation after image animation is halfway
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _textAnimationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFE5D9), // Light peach/pink from top
            const Color(0xFFFFF8F0), // Very light cream at bottom
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top section: Animated image
            Expanded(
              flex: 5,
              child: AnimatedBuilder(
                animation: _imageAnimationController,
                builder: (context, child) {
                  return ClipRect(
                    child: Transform.scale(
                      scale: _zoomAnimation.value,
                      child: Transform.translate(
                        offset: Offset(
                          _slideAnimation.value.dx * screenWidth,
                          _slideAnimation.value.dy * screenHeight,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            'lib/assets/images/onboarding.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.centerLeft, // Start focused on left
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text with animation
                    AnimatedBuilder(
                      animation: _textAnimationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: const Text(
                              'Design Your Space\nwith Augmented Reality\nby Creating Room',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 1 ? 10 : 8,
                          height: index == 1 ? 10 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 1
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
}
