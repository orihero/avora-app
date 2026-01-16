import 'package:flutter/material.dart';
import 'onboarding_pages/onboarding_page1.dart';
import 'onboarding_pages/onboarding_page2.dart';
import 'onboarding_pages/onboarding_page3.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;
  late AnimationController _skipButtonController;
  late AnimationController _nextButtonController;
  late Animation<Offset> _skipSlideAnimation;
  late Animation<Offset> _nextSlideAnimation;

  @override
  void initState() {
    super.initState();
    // Skip button animation (from left)
    _skipButtonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _skipSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Off-screen left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _skipButtonController,
      curve: Curves.easeOut,
    ));

    // Next button animation (from right)
    _nextButtonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _nextSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Off-screen right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _nextButtonController,
      curve: Curves.easeOut,
    ));

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _skipButtonController.forward();
        _nextButtonController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _skipButtonController.dispose();
    _nextButtonController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _skipOnboarding() {
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: const [
              OnboardingPage1(),
              OnboardingPage2(),
              OnboardingPage3(),
            ],
          ),
          // Navigation buttons with slide animations
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _currentPage == _totalPages - 1
                // Last page: Show "Get Started" button
                ? SlideTransition(
                    position: _nextSlideAnimation,
                    child: GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7BB5C9), // Teal button color
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7BB5C9).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                // Other pages: Show Skip and Next buttons
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip button (slides from left)
                      SlideTransition(
                        position: _skipSlideAnimation,
                        child: TextButton(
                          onPressed: _skipOnboarding,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // Next button (slides from right)
                      SlideTransition(
                        position: _nextSlideAnimation,
                        child: GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

