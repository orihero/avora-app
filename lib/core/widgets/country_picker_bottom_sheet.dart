import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/phone_countries.dart';

/// Glassmorphism bottom sheet for selecting phone country
class CountryPickerBottomSheet extends StatelessWidget {
  final PhoneCountry selectedCountry;
  final ValueChanged<PhoneCountry> onCountrySelected;

  const CountryPickerBottomSheet({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  static Future<PhoneCountry?> show(
    BuildContext context, {
    required PhoneCountry selectedCountry,
  }) {
    return showModalBottomSheet<PhoneCountry>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CountryPickerBottomSheet(
        selectedCountry: selectedCountry,
        onCountrySelected: (country) {
          Navigator.of(context).pop(country);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Stack(
            children: [
              // Backdrop filter for blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                ),
              ),
              // Content with border
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Select Country',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.95),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Country list
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: PhoneCountries.all.length,
                        itemBuilder: (context, index) {
                          final country = PhoneCountries.all[index];
                          final isSelected = country.code == selectedCountry.code;

                          return _CountryItem(
                            country: country,
                            isSelected: isSelected,
                            onTap: () => onCountrySelected(country),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CountryItem extends StatelessWidget {
  final PhoneCountry country;
  final bool isSelected;
  final VoidCallback onTap;

  const _CountryItem({
    required this.country,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isSelected
                ? [
                    Colors.white.withOpacity(0.35),
                    Colors.white.withOpacity(0.25),
                  ]
                : [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                )
              : Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            // Flag
            Text(
              country.flag,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            // Country name
            Expanded(
              child: Text(
                country.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            // Dial code
            Text(
              country.dialCode,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                color: Colors.white.withOpacity(0.9),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
