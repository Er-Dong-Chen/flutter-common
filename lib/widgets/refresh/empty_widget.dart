import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final dynamic tips;
  final String? image;
  final double? width, height;

  const EmptyWidget(
      {super.key, this.tips, this.image, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Image(
            image: AssetImage(image ?? "assets/images/empty.png"),
            width: width ?? 120.0,
            height: height ?? 120.0),
        tips != null && tips is Widget
            ? tips
            : Text(
                tips ?? "暂无数据",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
      ],
    );
  }
}
