import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../../../auth/presentation/widgets/auth_bottom_sheets.dart';
import 'onboarding_pages/onboarding_page1.dart';
import 'onboarding_pages/onboarding_page2.dart';
import 'onboarding_pages/onboarding_page3.dart';

class OnboardingScreen extends StatefulWidget {
  final int? initialPage;
  final bool showBottomSheetOnInit;

  const OnboardingScreen({
    super.key,
    this.initialPage,
    this.showBottomSheetOnInit = false,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _skipButtonController;
  late AnimationController _nextButtonController;
  late Animation<Offset> _skipSlideAnimation;
  late Animation<Offset> _nextSlideAnimation;
  bool _isOnLastPage = false;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with initialPage if provided
    _pageController = PageController(
      initialPage: widget.initialPage ?? 0,
    );
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
    
    // Initialize page state after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _pageController.hasClients) {
        final initialPage = _pageController.page?.round() ?? widget.initialPage ?? 0;
        _isOnLastPage = initialPage == 2;
      }
      
      // Show bottom sheet on init if requested
      if (widget.showBottomSheetOnInit && mounted) {
        _showLoginBottomSheet();
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

  void _onPageChanged(int page, OnboardingBloc bloc) {
    setState(() {
      _isOnLastPage = page == 2; // Page 3 is index 2
    });
    bloc.add(OnboardingEvent.pageChanged(page));
  }

  void _showLoginBottomSheet() {
    AuthBottomSheets.showLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider(
      create: (context) {
        final bloc = getIt<OnboardingBloc>();
        // Set initial page if provided
        if (widget.initialPage != null) {
          bloc.add(OnboardingEvent.pageChanged(widget.initialPage!));
        }
        return bloc;
      },
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          state.maybeWhen(
            pageChanged: (currentPage) {
              _pageController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            final bloc = context.read<OnboardingBloc>();
            final currentPage = state.maybeWhen(
              pageChanged: (page) => page,
              orElse: () => 0,
            );
            final totalPages = 3;
            final isOnboardingCompleted = state.maybeWhen(
              completed: () => true,
              orElse: () => false,
            );
            // Show Get Started only on last page and only until user has tapped it once
            final shouldShowGetStarted = !isOnboardingCompleted &&
                (_isOnLastPage || currentPage == totalPages - 1);

            return Scaffold(
              body: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (page) => _onPageChanged(page, bloc),
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
                    child: isOnboardingCompleted
                        // After Get Started: hide buttons so they don't reappear
                        ? const SizedBox.shrink()
                        : shouldShowGetStarted
                            // Last page: Show "Get Started" button
                            ? SlideTransition(
                                position: _nextSlideAnimation,
                                child: GestureDetector(
                                  onTap: _showLoginBottomSheet,
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
                                    child: Center(
                                      child: Text(
                                        l10n.getStarted,
                                        style: const TextStyle(
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
                                  onPressed: _showLoginBottomSheet,
                                  child: Text(
                                    l10n.skip,
                                    style: const TextStyle(
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
                                  onTap: () {
                                    bloc.add(
                                      const OnboardingEvent.nextPage(),
                                    );
                                  },
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
          },
        ),
      ),
    );
  }
}
