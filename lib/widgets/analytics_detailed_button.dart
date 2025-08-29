import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';

class AnalyticsDetailedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AnalyticsDetailedButton({this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed ?? () {},
          icon: SvgPicture.asset(
            'assets/onb2.svg',
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(Color(0xFF434343), BlendMode.srcIn),
          ),
          label: Text(
            AppLocalizations.of(context)!.viewDetailedAnalysis,
            style: const TextStyle(fontSize: 16, color: Color(0xFF434343), fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE6E6E6),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
} 