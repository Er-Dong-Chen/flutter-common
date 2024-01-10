import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ComGallery extends StatefulWidget {
  final List<dynamic> urls;
  final int index;
  const ComGallery({super.key, required this.urls, this.index = 0});

  @override
  ComGalleryState createState() => ComGalleryState();
}

class ComGalleryState extends State<ComGallery> {
  int currentIndex = 0;
  late int initialIndex; //初始index
  late int title;

  @override
  void initState() {
    currentIndex = widget.index;
    initialIndex = widget.index;
    title = initialIndex + 1;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      title = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.urls[index]),
                    initialScale: PhotoViewComputedScale.contained * 1,
//                    heroAttributes: widget.urls[index],
                  );
                },
                itemCount: widget.urls.length,
                // loadingChild: widget.loadingChild,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                pageController:
                    PageController(initialPage: initialIndex), //点进去哪页默认就显示哪一页
                onPageChanged: onPageChanged,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "$title / ${widget.urls.length}",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 17.0, decoration: null),
                ),
              )
            ],
          )),
    );
  }
}
