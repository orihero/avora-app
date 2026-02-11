import 'package:flutter/material.dart';

/// Minimal placeholder for a tab (e.g. Favorites, Profile) until the feature is built.
class PlaceholderTabPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderTabPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFFB0B0B0)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB0B0B0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
