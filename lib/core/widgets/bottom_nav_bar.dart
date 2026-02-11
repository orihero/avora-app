import 'package:flutter/material.dart';
import 'package:liquid_tabbar_minimize/liquid_tabbar_minimize.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAuthenticated;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isAuthenticated = true,
  });

  List<LiquidTabItem> _buildItems() {
    return [
      const LiquidTabItem(
        widget: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(Icons.home),
        ),
        sfSymbol: 'house.fill',
        label: 'Home',
      ),
      const LiquidTabItem(
        widget: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(Icons.gavel),
        ),
        sfSymbol: 'hammer.fill',
        label: 'Auction',
      ),
      const LiquidTabItem(
        widget: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(Icons.favorite),
        ),
        sfSymbol: 'heart.fill',
        label: 'Favorites',
      ),
      LiquidTabItem(
        widget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Icon(isAuthenticated ? Icons.person : Icons.login),
        ),
        sfSymbol: isAuthenticated ? 'person.fill' : 'person.circle',
        label: isAuthenticated ? 'Profile' : 'Sign In',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: LiquidBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: _buildItems(),
        selectedItemColor: const Color(0xFF2D2D2D),
        unselectedItemColor: const Color(0xFFB0B0B0),
        labelVisibility: LabelVisibility.never,
        showActionButton: false,
        height: 72,
      ),
    );
  }
}
