import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'com_gallery.dart';
import 'com_image.dart';

class ComAlbum extends StatelessWidget {
  final List<String> urls;
  final EdgeInsetsGeometry? padding;
  final double? itemSize;
  final double? spacing;

  const ComAlbum({
    super.key,
    required this.urls,
    this.padding,
    this.itemSize,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return const SizedBox.shrink();
    }

    if (urls.length == 1) {
      return _buildSingleImage(urls[0]);
    } else {
      return _buildGridView();
    }
  }

  Widget _buildSingleImage(String url) {
    return GestureDetector(
      onTap: () => _openGallery(urls),
      child: ComImage(
        url,
        width: double.infinity,
      ),
    );
  }

  Widget _buildGridView() {
    final crossAxisCount = _getCrossAxisCount();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing!,
        crossAxisSpacing: spacing!,
        childAspectRatio: 1,
      ),
      padding: padding,
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openGallery(urls, index: index),
          child: ComImage(
            urls[index],
            width: itemSize,
            height: itemSize,
          ),
        );
      },
    );
  }

  int _getCrossAxisCount() {
    switch (urls.length) {
      case 2:
      case 4:
        return 2;
      default:
        return 3;
    }
  }

  void _openGallery(List<String> images, {int index = 0}) {
    Get.to(ComGallery(
      urls: images,
      initialIndex: index,
    ));
  }
}
