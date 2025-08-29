import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String userRole;

  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SafeArea(
      bottom: true,
      left: false,
      right: false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 16, left: 16), // Reduced bottom padding
        decoration: BoxDecoration(
          color: Colors.white, // Set background color here
          borderRadius: const BorderRadius.all(Radius.circular(12.0)), // Set radius to 12
          boxShadow: [ // Add shadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0), // Increased vertical padding for white container height
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB).withOpacity(0.4), // Reduced opacity
              borderRadius: BorderRadius.circular(46.0), // Make it completely round
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding for gap
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, 'assets/home.svg', localizations?.dashboard ?? 'Dashboard', 0),
                  _buildNavItem(context, 'assets/report.svg', localizations?.reports ?? 'Reports', 1),
                  _buildNavItem(context, 'assets/staff.svg', localizations?.staff ?? 'Staff', 2),
                  _buildNavItem(
                    context,
                    'assets/users.svg',
                    userRole.toLowerCase() == 'admin' 
                        ? (localizations?.users ?? 'Users') 
                        : (localizations?.settings ?? 'Settings'),
                    3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, String label, int index) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = isSelected ? const Color(0xFF00A39E) : const Color(0xFF9CA3AF);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Added bottom padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn), // Apply color filter
                height: 24, // Adjust size as needed
              ),
              const SizedBox(height: 4), // Space between icon and text
              Text(
                label,
                style: TextStyle(fontSize: 12, color: itemColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 