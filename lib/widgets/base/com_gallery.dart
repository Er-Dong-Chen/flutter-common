import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ComGallery extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const ComGallery({
    super.key,
    required this.urls,
    this.initialIndex = 0,
  });

  @override
  ComGalleryState createState() => ComGalleryState();
}

class ComGalleryState extends State<ComGallery> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.urls[index]),
                initialScale: PhotoViewComputedScale.contained,
              );
            },
            itemCount: widget.urls.length,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: widget.initialIndex),
            onPageChanged: _onPageChanged,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${currentIndex + 1} / ${widget.urls.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
