import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/placeholder_tab_page.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/auction/presentation/pages/auction_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';

/// Tab indices: 0 Home, 1 Auction, 2 Favorites, 3 Profile
const int _homeTabIndex = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 1; // Chair selected by default
  int _bottomNavIndex = _homeTabIndex;

  List<String> _getCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.categoriesAll,
      l10n.categoriesChair,
      l10n.categoriesTable,
      l10n.categoriesSofa,
      l10n.categoriesLamp,
      l10n.categoriesBed,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductBloc>()..add(const ProductEvent.getProducts()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            body: SafeArea(
              child: IndexedStack(
                index: _bottomNavIndex,
                children: [
                  _HomeTabContent(
                    selectedCategoryIndex: _selectedCategoryIndex,
                    onCategorySelected: (index, category) {
                      setState(() => _selectedCategoryIndex = index);
                      context.read<ProductBloc>().add(
                            ProductEvent.getProductsByCategory(category),
                          );
                    },
                    getCategories: _getCategories,
                    isAuthenticated: authState.isAuthenticated,
                    onProfileTap: authState.isAuthenticated
                        ? () => setState(() => _bottomNavIndex = 3)
                        : null,
                  ),
                  const AuctionPage(),
                  const PlaceholderTabPage(
                      title: 'Favorites', icon: Icons.favorite),
                  const ProfilePage(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _bottomNavIndex,
              onTap: (index) => setState(() => _bottomNavIndex = index),
              isAuthenticated: authState.isAuthenticated,
            ),
          );
        },
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  final int selectedCategoryIndex;
  final void Function(int index, String category) onCategorySelected;
  final List<String> Function(BuildContext context) getCategories;
  final bool isAuthenticated;
  final VoidCallback? onProfileTap;

  const _HomeTabContent({
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
    required this.getCategories,
    required this.isAuthenticated,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = getCategories(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.findDreamFurniture,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (onProfileTap != null) {
                    onProfileTap!();
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(
                          initialPage: 2,
                          showBottomSheetOnInit: true,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF5F5F5),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isAuthenticated ? Icons.person : Icons.login,
                    color: const Color(0xFF6B6B6B),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE8E8E8),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Color(0xFFB0B0B0),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      hintStyle: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Color(0xFF6B6B6B),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Category Chips
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < categories.length - 1 ? 12 : 0,
                ),
                child: CategoryChip(
                  label: categories[index],
                  isSelected: selectedCategoryIndex == index,
                  onTap: () => onCategorySelected(index, categories[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Product Cards
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return state.maybeWhen(
                initial: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                loaded: (products) {
                  if (products.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(20, 0, 4, 20),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.tappedOn(products[index].name)),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.addedToCart(products[index].name)),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                error: (failure) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${failure.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductBloc>().add(
                                const ProductEvent.refreshProducts(),
                              );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                orElse: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
