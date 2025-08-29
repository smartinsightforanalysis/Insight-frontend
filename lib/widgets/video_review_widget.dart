import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class VideoReviewWidget extends StatefulWidget {
  final String title;
  final String description;
  final String videoThumbnail;

  const VideoReviewWidget({
    Key? key,
    required this.title,
    required this.description,
    this.videoThumbnail = '',
  }) : super(key: key);

  @override
  State<VideoReviewWidget> createState() => _VideoReviewWidgetState();
}

class _VideoReviewWidgetState extends State<VideoReviewWidget> {
  int _selectedButtonIndex = 0; // 0: All, 1: Aggression, 2: Absent, 3: Idle

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          
          // Video Player Container
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
              image: widget.videoThumbnail.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(widget.videoThumbnail),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Colored timeline lines
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 16,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFACC15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 33,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                // Video controls at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Buttons for filtering video content
          Row(
            children: [
              _buildToggleButton(AppLocalizations.of(context)!.all, 0, const Color(0xFF1E293B)),
              const SizedBox(width: 8),
              _buildToggleButton(AppLocalizations.of(context)!.aggression, 1, const Color(0xFFEF4444)),
              const SizedBox(width: 8),
              _buildToggleButton(AppLocalizations.of(context)!.absent, 2, const Color(0xFFFACC15)),
              const SizedBox(width: 8),
              _buildToggleButton(AppLocalizations.of(context)!.idle, 3, const Color(0xFF3B82F6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, int index, Color color) {
    final bool isSelected = _selectedButtonIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedButtonIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C3557) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.transparent, // No border visible
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
