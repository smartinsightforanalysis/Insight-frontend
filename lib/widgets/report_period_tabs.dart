import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class ReportPeriodTabs extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const ReportPeriodTabs({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildPeriodTab(localizations.daily, context),
          _buildPeriodTab(localizations.weekly, context),
          _buildPeriodTab(localizations.monthly, context),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String period, BuildContext context) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPeriodChanged(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF209A9F) : const Color(0xFFE5E7EB),
                width: 2,
              ),
            ),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF209A9F) : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}
