import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';

class FilteredReportScreen extends StatelessWidget {
  final String reportTitle; // e.g., "Incident Report"

  const FilteredReportScreen({super.key, required this.reportTitle});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
        titleSpacing: 0,
        title: Text(
          reportTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FA),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/folder.svg', // Assuming 'folder.svg' is the icon for no data
                  width: 32,
                  height: 32,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF209A9F),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.noDataAvailable,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting filters',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement reset filters logic or pop to previous screen
                Navigator.pop(context); // Go back to the screen with filters
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2F4F7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                localizations.reset,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF209A9F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
