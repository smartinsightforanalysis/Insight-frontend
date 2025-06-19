import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AwayTimeWidget extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String additionalInfo;

  const AwayTimeWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.duration,
    required this.additionalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 16),
          
          // Zone Absence Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: const Border(
                left: BorderSide(
                  color: Color(0xFF16A3AC),
                  width: 4,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBEAFE),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/away.svg',
                                  color: Color(0xFF16A3AC),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Zone Absence',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C3557),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Yesterday',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 52), // 40 (icon width) + 12 (spacing)
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/location.svg',
                                color: Color(0xFF6B7280),
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Zone: Service Area',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
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
          ),
          const SizedBox(height: 8),
          
          // Additional info
          // Text(
          //   additionalInfo,
          //   style: const TextStyle(
          //     fontSize: 12,
          //     color: Color(0xFF6B7280),
          //   ),
          // ),
          // const SizedBox(height: 8),
        ],
      ),
    );
  }
}
