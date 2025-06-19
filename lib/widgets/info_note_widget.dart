import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoNoteWidget extends StatelessWidget {
  final String message;

  const InfoNoteWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/onb2.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF16A3AC),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
