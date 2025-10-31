import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGrid extends StatelessWidget {
  final List<String> imageUrls;
  final double spacing;
  final double borderRadius;

  const PhotoGrid({
    Key? key,
    required this.imageUrls,
    this.spacing = 8.0,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox();

    final count = imageUrls.length;
    final displayedImages = count > 4 ? imageUrls.take(4).toList() : imageUrls;

    // Adaptive layout
    int crossAxisCount;
    double aspectRatio;

    if (count == 1) {
      crossAxisCount = 1;
      aspectRatio = 16 / 9; // wide rectangle for single image
    } else if (count == 2) {
      crossAxisCount = 2;
      aspectRatio = 1.3;
    } else {
      crossAxisCount = 2;
      aspectRatio = 1.35; // slightly rectangular grid
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = constraints.maxWidth;
        final itemWidth =
            (gridWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
        final itemHeight = itemWidth / aspectRatio;

        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: displayedImages.length,
          itemBuilder: (context, index) {
            final imageUrl = displayedImages[index];
            final isLast = index == 3 && count > 4;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoViewerPage(
                      images: imageUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                    if (isLast)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Center(
                          child: Text(
                            '+${count - 4}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// class PhotoGrid extends StatelessWidget {
//   final List<String> imageUrls;
//   final double spacing;
//   final double borderRadius;

//   const PhotoGrid({
//     super.key,
//     required this.imageUrls,
//     this.spacing = 8.0,
//     this.borderRadius = 12.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final count = imageUrls.length;

//     if (count == 0) return const SizedBox();

//     int crossAxisCount;
//     if (count == 1) {
//       crossAxisCount = 1;
//     } else if (count == 2) {
//       crossAxisCount = 2;
//     } else {
//       crossAxisCount = 2;
//     }

//     final displayedImages = count > 4 ? imageUrls.take(4).toList() : imageUrls;

//     return GridView.builder(
//       padding: EdgeInsets.zero,
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         mainAxisSpacing: 6,
//         crossAxisSpacing: 8,
//       ),
//       itemCount: displayedImages.length,
//       itemBuilder: (context, index) {
//         final imageUrl = displayedImages[index];
//         final isLast = index == 3 && count > 4;

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => PhotoViewerPage(
//                   images: imageUrls,
//                   initialIndex: index,
//                 ),
//               ),
//             );
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(borderRadius),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               if (isLast)
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(borderRadius),
//                     color: Colors.black54,
//                   ),
//                   child: Center(
//                     child: Text(
//                       '+${count - 4}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


class PhotoViewerPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const PhotoViewerPage({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
          );
        },
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
