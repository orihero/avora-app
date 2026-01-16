import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
              showIndicator: true,
            ),
            _NavItem(
              icon: Icons.chair_outlined,
              activeIcon: Icons.chair,
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.shopping_bag_outlined,
              activeIcon: Icons.shopping_bag,
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.favorite_border,
              activeIcon: Icons.favorite,
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              isActive: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;
  final bool showIndicator;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isActive && showIndicator)
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE85A5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  activeIcon,
                  color: Colors.white,
                  size: 22,
                ),
              )
            else
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? const Color(0xFF2D2D2D) : const Color(0xFFB0B0B0),
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}
