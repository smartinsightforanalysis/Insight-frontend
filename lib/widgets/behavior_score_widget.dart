import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class BehaviorScoreWidget extends StatelessWidget {
  final int productivityScore;
  final int attendanceScore;
  final int? realProductivityScore;
  final bool isLoadingProductivity;

  const BehaviorScoreWidget({
    Key? key,
    required this.productivityScore,
    required this.attendanceScore,
    this.realProductivityScore,
    this.isLoadingProductivity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    print('🎯 BehaviorScoreWidget - realProductivityScore: $realProductivityScore, isLoading: $isLoadingProductivity');
    
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
            localizations.behaviorScore,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 20),

          // Main Layout: Large Circle + Productivity/Attendance List
          Row(
            children: [
              // Large Main Score Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF16A3AC),
                    width: 4,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$productivityScore%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A3AC),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Productivity and Attendance List
              Expanded(
                child: Column(
                  children: [
                    // Productivity Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.productivity,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        isLoadingProductivity
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF16A3AC),
                                  ),
                                ),
                              )
                            : Text(
                                realProductivityScore != null
                                    ? '$realProductivityScore%'
                                    : '0%', // Fallback to 0% instead of hardcoded 95%
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF16A3AC),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Attendance Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.attendance,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        Text(
                          '$attendanceScore%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A3AC),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
