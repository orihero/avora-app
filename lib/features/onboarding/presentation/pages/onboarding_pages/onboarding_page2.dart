import 'package:flutter/material.dart';
import '../../../../../../l10n/l10n.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2>
    with TickerProviderStateMixin {
  late final AnimationController _imageAnimationController;
  late final AnimationController _textAnimationController;
  late final Animation<Alignment> _panAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _textScaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Image animation - camera pan from left to right
    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2800), // Very slow pan animation
      vsync: this,
    );

    // Pan animation: camera moves from left (0,0) to right (end of image)
    _panAnimation = AlignmentTween(
      begin: const Alignment(-1.0, 0.0), // Start at left side of image (0,0)
      end: const Alignment(0.7, 0.0),    // End at right side of image
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut, // Smooth pan animation
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
            // Top section: Animated image with camera pan
            Expanded(
              flex: 5,
              child: AnimatedBuilder(
                animation: _imageAnimationController,
                builder: (context, child) {
                  return ClipRect(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        'lib/assets/images/onboarding.png',
                        fit: BoxFit.cover,
                        alignment: _panAnimation.value, // Pan from left to right
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
                        final l10n = AppLocalizations.of(context);
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: Text(
                              l10n.onboardingPage2Text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
