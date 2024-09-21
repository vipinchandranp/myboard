// MediaFileWidget implementation with loading indicator for images
import 'package:flutter/material.dart';
import '../../models/common/media_file.dart';
import '../../models/common/media_type.dart';

class MediaFileWidget extends StatelessWidget {
  final MediaFile mediaFile;

  const MediaFileWidget({required this.mediaFile});

  @override
  Widget build(BuildContext context) {
    if (mediaFile.mediaType == MediaType.image) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          mediaFile.filename,
          // Assuming filename contains the URL for the image
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Center(child: Text('Failed to load image'));
          },
        ),
      );
    } else if (mediaFile.mediaType == MediaType.video) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Placeholder for video, replace with actual video player widget later
            Image.asset('assets/video_placeholder.jpg',
                fit: BoxFit.cover, width: double.infinity),
            const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 64,
            ),
          ],
        ),
      );
    }
    return Container(); // Return empty container if media type is unsupported
  }
}
