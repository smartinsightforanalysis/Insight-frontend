import 'package:flutter/material.dart';

class FrameSnapshotsWidget extends StatelessWidget {
  final String title;
  final String description;
  final List<String> snapshotImages;
  final bool isLoading;
  final String? error;

  const FrameSnapshotsWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.snapshotImages,
    this.isLoading = false,
    this.error,
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
            child: _buildSnapshotsContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotsContent() {
    print('🔧 FrameSnapshotsWidget: isLoading=$isLoading, error=$error, snapshotImages.length=${snapshotImages.length}');

    if (isLoading) {
      return _buildLoadingState();
    }

    if (error != null) {
      return _buildErrorState();
    }

    if (snapshotImages.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSnapshotsList();
  }

  Widget _buildLoadingState() {
    return ListView(
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
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1C3557),
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFF9CA3AF),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load snapshots',
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            color: Color(0xFF9CA3AF),
            size: 32,
          ),
          const SizedBox(height: 8),
          const Text(
            'No snapshots available',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotsList() {
    // Safety check to prevent RangeError
    if (snapshotImages.isEmpty) {
      return _buildEmptyState();
    }

    final itemCount = snapshotImages.length > 3 ? 3 : snapshotImages.length;

    // Additional safety check
    if (itemCount <= 0) {
      return _buildEmptyState();
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: itemCount > 0 ? List.generate(
        itemCount,
        (index) {
          // Additional safety check
          if (index >= snapshotImages.length || snapshotImages.isEmpty) {
            return const SizedBox.shrink();
          }

          final imageUrl = snapshotImages[index];
          if (imageUrl.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(right: index < (itemCount - 1) ? 12 : 0),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: [
                    // Network image
                    Image.network(
                      imageUrl,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: const Color(0xFF1C3557),
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                color: Color(0xFF9CA3AF),
                                size: 24,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Failed to load',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
            ),
          );
        },
      ) : [],
    );
  }
}
