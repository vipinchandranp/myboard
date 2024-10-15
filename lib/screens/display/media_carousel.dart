import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/display/bdisplay.dart';

class MediaCarouselWidget extends StatelessWidget {
  final BDisplay display;

  const MediaCarouselWidget({Key? key, required this.display}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();

    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
            color: Colors.white,
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: display.mediaFiles.length,
            itemBuilder: (context, index) {
              final mediaFile = display.mediaFiles[index];
              return CachedNetworkImage(
                imageUrl: mediaFile.filename,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: display.mediaFiles.length,
          effect: const WormEffect(
            activeDotColor: Colors.blue,
            dotHeight: 8.0,
            dotWidth: 8.0,
            spacing: 4.0,
          ),
        ),
      ],
    );
  }
}
