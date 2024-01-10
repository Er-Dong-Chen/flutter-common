import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'com_gallery.dart';
import 'com_image.dart';

class ComAlbum extends StatelessWidget {
  final List<String> urls;
  final EdgeInsetsGeometry? padding;

  const ComAlbum({
    super.key,
    required this.urls,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (urls.length == 1) {
      return GestureDetector(
        onTap: () {
          Get.to(ComGallery(
            urls: urls,
          ));
        },
        child: ComImage(
          urls[0],
          width: double.infinity,
        ),
      );
    }
    int rowCount = 3;
    if (urls.length == 2 || urls.length == 4) {
      rowCount = 2;
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rowCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: urls.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: ComImage(urls[index]),
          onTap: () {
            Get.to(ComGallery(
              urls: urls,
              index: index,
            ));
          },
        );
      },
    );
  }
}
