import 'package:flutter/material.dart';
import 'package:myboard/screens/display/nearby_display_map.dart';
import 'package:myboard/screens/qrcode/qr_scanner.dart';

import '../../display/create_display.dart';
import 'package:flutter/material.dart';
import 'package:myboard/screens/display/nearby_display_map.dart';
import 'package:myboard/screens/qrcode/qr_scanner.dart';

import '../../display/create_display.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Quick Actions" label aligned to the left
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Quick Actions",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        // Quick action icons aligned to the left
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildQuickActionIcon(
                assetPath: 'assets/qr-scan-icon.png',
                label: "Upload",
                onTap: () => _navigateTo(context, QRScannerWidget()),
              ),
              const SizedBox(width: 12),
              _buildQuickActionIcon(
                assetPath: 'assets/pin-location.png', // Replace with another asset if needed
                label: "Explore",
                onTap: () => _navigateTo(context, NearbyDisplaysMap()),
              ),
            ],
          ),
        ),
        // Drag handle indicator as a full-width line
        const Padding(
          padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0), // Optional margins
          child: SizedBox(
            width: double.infinity,
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Navigate to a specific page.
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Builds a quick action icon with its label.
  Widget _buildQuickActionIcon({
    required String assetPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
