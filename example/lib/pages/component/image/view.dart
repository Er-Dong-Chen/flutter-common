import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';
import 'package:module_base/theme/theme.dart';

import 'logic.dart';

class ImagePage extends StatelessWidget {
  ImagePage({super.key});

  final logic = Get.put(ImageLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text('Image'),
      ),
      body: BaseWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.comTheme.spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Radio 圆角', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: AppTheme.comTheme.spacing.small),
              Wrap(
                spacing: 12,
                children: [
                  ComImage("https://cdn.uviewui.com/uview/album/1.jpg",
                      width: 64,
                      height: 64,
                      radius: AppTheme.comTheme.shapes.circularRadius),
                  ComImage("https://cdn.uviewui.com/uview/album/1.jpg",
                      width: 64,
                      height: 64,
                      radius: AppTheme.comTheme.shapes.mediumRadius),
                  ComImage("https://cdn.uviewui.com/uview/album/1.jpg",
                      width: 64,
                      height: 64,
                      radius: AppTheme.comTheme.shapes.circularRadius),
                ],
              ),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('Image 占位及错误',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: AppTheme.comTheme.spacing.small),
              Wrap(
                spacing: 12,
                children: [
                  ComImage("https://cdn.uviewui.com/uview/album/1.jpg",
                      width: 64,
                      height: 64,
                      radius: AppTheme.comTheme.shapes.mediumRadius),
                  ComImage("https://cdn.uviewui.com/uview/album/1.jpg",
                      width: 64,
                      height: 64,
                      radius: AppTheme.comTheme.shapes.circularRadius),
                  ComImage("https://cdn.uviewui.com/uview/album/1.jpg",
                      width: 64,
                      height: 64,
                      radius: AppTheme.comTheme.shapes.circularRadius),
                ],
              ),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('Avatar 头像', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: AppTheme.comTheme.spacing.small),
              Wrap(
                spacing: 12,
                children: [
                  ComAvatar("",
                      size: 64,
                      radius: AppTheme.comTheme.shapes.circularRadius),
                  ComAvatar("",
                      size: 64, radius: AppTheme.comTheme.shapes.mediumRadius),
                  ComAvatar("",
                      size: 64,
                      radius: AppTheme.comTheme.shapes.circularRadius),
                ],
              ),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('Avatar 头像组',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: AppTheme.comTheme.spacing.small),
              SizedBox(
                height: 64,
                child: ComAvatarGroup(
                  const ["", "", "", "", "", "", "", ""],
                  spacing: 32,
                  maxCount: 5,
                  size: 64,
                  builder: Text(
                    '99+',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('Avatar 自定义',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: AppTheme.comTheme.spacing.small),
              Wrap(
                spacing: 12,
                children: [
                  ComAvatar(
                    "",
                    size: 64,
                    radius: AppTheme.comTheme.shapes.circularRadius,
                    child: Text(
                      '姓名',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 18),
                    ),
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    children: [
                      ComAvatar("",
                          size: 64,
                          radius: AppTheme.comTheme.shapes.mediumRadius),
                      const Positioned(
                          right: 0,
                          top: 0,
                          child: ComContainer(
                            padding: EdgeInsets.all(6),
                            color: Colors.red,
                          ))
                    ],
                  ),
                  Stack(
                    children: [
                      ComAvatar("",
                          size: 64,
                          radius: AppTheme.comTheme.shapes.circularRadius),
                      const Positioned(
                          right: 0,
                          bottom: 0,
                          child: ComContainer(
                            padding: EdgeInsets.all(6),
                            color: Colors.red,
                          ))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
