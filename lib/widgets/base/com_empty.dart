import 'package:flutter/material.dart';
import 'package:flutter_chen_common/common/style.dart';
import 'package:get/get.dart';

class ComEmpty extends StatelessWidget {
  final Widget? image;
  final Widget? message;

  const ComEmpty({super.key, this.message, this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image ??
              Image.asset("assets/images/empty.png",
                  width: 120.0, height: 120.0),
          message ??
              Text(
                "暂无数据".tr,
                style: CommonStyle.secondaryStyle,
              ),
        ],
      ),
    );
  }
}
