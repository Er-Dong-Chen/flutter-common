import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class ComUpload extends StatelessWidget {
  final MultiImagePickerController controller;
  final bool draggable;
  final bool shrinkWrap;
  final int? crossAxisCount;
  final double? spacing;

  const ComUpload({
    super.key,
    required this.controller,
    this.draggable = true,
    this.shrinkWrap = true,
    this.crossAxisCount = 3,
    this.spacing,
  });

  static MultiImagePickerController multiImagePickerController =
      MultiImagePickerController(
          maxImages: 9,
          images: <ImageFile>[],
          picker: (allowMultiple) async {
            return await pickImagesUsingImagePicker(allowMultiple);
          });

  @override
  Widget build(BuildContext context) {
    return MultiImagePickerView(
      controller: controller,
      builder: (BuildContext context, ImageFile imageFile) {
        return DefaultDraggableItemWidget(
          imageFile: imageFile,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CommonStyle.roundedMd)),
          fit: BoxFit.cover,
          closeButtonIcon: const Icon(Icons.cancel, color: Colors.black45),
          closeButtonBoxDecoration: null,
          showCloseButton: true,
        );
      },
      initialWidget: InkWell(
        onTap: () {
          controller.pickImages();
        },
        child: Container(
          width: (ScreenUtil.defaultSize.width -
                  (spacing ?? CommonStyle.spaceMd) * 2 -
                  24) /
              crossAxisCount!,
          height: (ScreenUtil.defaultSize.width -
                  (spacing ?? CommonStyle.spaceMd) * 2 -
                  24) /
              crossAxisCount!,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(CommonStyle.roundedMd)),
            border: Border.all(color: Colors.black26),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black26,
            size: 36,
          ),
        ),
      ), // Use any Widget or DefaultInitialWidget. Use null to hide initial widget
      addMoreButton: InkWell(
        onTap: () {
          controller.pickImages();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(CommonStyle.roundedMd)),
            border: Border.all(
              color: Colors.black26,
            ),
          ),
          child: const Icon(Icons.add, color: Colors.black26, size: 36),
        ),
      ),
      shrinkWrap: shrinkWrap,
      draggable: draggable,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        crossAxisCount: crossAxisCount!,
      ),
      // longPressDelayMilliseconds: /* time to press and hold to start dragging item */
      onDragBoxDecoration: const BoxDecoration(),
    );
  }

  static Future<List<ImageFile>> pickImagesUsingImagePicker(
      bool allowMultiple) async {
    final picker = ImagePicker();
    final List<XFile> xFiles;
    if (allowMultiple) {
      xFiles = await picker.pickMultiImage(maxWidth: 1080, imageQuality: 95);
    } else {
      xFiles = [];
      final xFile = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 1080, imageQuality: 95);
      if (xFile != null) {
        xFiles.add(xFile);
      }
    }
    if (xFiles.isNotEmpty) {
      return xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
    }
    return [];
  }
}
