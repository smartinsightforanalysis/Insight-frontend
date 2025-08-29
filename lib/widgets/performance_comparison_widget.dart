import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class PerformanceComparisonWidget extends StatelessWidget {
  final int avgDailyScore;
  final int workTimePercentage;
  final double? averageBreakDuration; // in minutes
  final bool isLoadingBreakTime;
  final String? breakTimeError;
  final double? totalWorkHours;
  final double? averageWorkHours; // from API summary
  final double? attendanceRate;
  final bool isLoadingWorkHours;
  final String? workHoursError;

  const PerformanceComparisonWidget({
    Key? key,
    required this.avgDailyScore,
    required this.workTimePercentage,
    this.averageBreakDuration,
    this.isLoadingBreakTime = false,
    this.breakTimeError,
    this.totalWorkHours,
    this.averageWorkHours,
    this.attendanceRate,
    this.isLoadingWorkHours = false,
    this.workHoursError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.performanceComparison,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 16),
          
          // Work Hours Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.workHours,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              _buildWorkHoursPercentage(),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress Bar for Work Hours
          _buildWorkHoursProgressBar(),
          const SizedBox(height: 16),
          
          // Break Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.breakTime,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              _buildBreakTimePercentage(),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress Bar for Break Time
          _buildBreakTimeProgressBar(),
        ],
      ),
    );
  }

  Widget _buildWorkHoursPercentage() {
    if (isLoadingWorkHours) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF209A9F),
        ),
      );
    }

    if (workHoursError != null || totalWorkHours == null) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
        ),
      );
    }

    // Show total hours as percentage out of 100
    return Text(
      '${totalWorkHours!.toStringAsFixed(1)}%',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF209A9F),
      ),
    );
  }

  Widget _buildWorkHoursProgressBar() {
    if (isLoadingWorkHours) {
      return Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const LinearProgressIndicator(
          backgroundColor: Color(0xFFE5E7EB),
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF209A9F)),
        ),
      );
    }

    if (workHoursError != null || totalWorkHours == null) {
      return Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    // Use total hours directly as percentage out of 100
    final progressValue = (totalWorkHours! / 100).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Background bar
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Filled bar
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progressValue,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF16A3AC),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakTimePercentage() {
    if (isLoadingBreakTime) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF209A9F),
        ),
      );
    }

    if (breakTimeError != null || averageBreakDuration == null) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
        ),
      );
    }

    // Show average break duration directly as percentage out of 100
    return Text(
      '${averageBreakDuration!.toStringAsFixed(1)}%',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF209A9F),
      ),
    );
  }

  Widget _buildBreakTimeProgressBar() {
    if (isLoadingBreakTime) {
      return Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const LinearProgressIndicator(
          backgroundColor: Color(0xFFE5E7EB),
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF209A9F)),
        ),
      );
    }

    if (breakTimeError != null || averageBreakDuration == null) {
      return Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    // Use average break duration directly as percentage out of 100
    final breakPercentage = (averageBreakDuration! / 100).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Background bar
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Filled bar
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: breakPercentage,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF16A3AC),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
