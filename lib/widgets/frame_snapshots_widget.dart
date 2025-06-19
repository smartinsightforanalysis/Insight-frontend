import 'package:flutter/material.dart';

class FrameSnapshotsWidget extends StatelessWidget {
  final String title;
  final String description;
  final List<String> snapshotImages;

  const FrameSnapshotsWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.snapshotImages,
  }) : super(key: key);

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
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          
          // Horizontally scrollable snapshots
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8.0),
                      image: snapshotImages.length > index
                          ? DecorationImage(
                              image: AssetImage(snapshotImages[index]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Stack(
                            children: [
                              if (snapshotImages.length <= index)
                                const Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              // Timestamp overlay
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF727376),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${index + 1}:00 PM',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
