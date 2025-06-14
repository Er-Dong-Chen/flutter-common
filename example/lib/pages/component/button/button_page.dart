import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:get/get.dart';
import 'package:module_base/module_base.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ComBack(),
        title: const Text('按钮组件'),
      ),
      body: BaseWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.comTheme.spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('按钮类型', style: Theme.of(context).textTheme.titleMedium),
              buildType(),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('镂空按钮', style: Theme.of(context).textTheme.titleMedium),
              buildPlain(),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('禁用按钮', style: Theme.of(context).textTheme.titleMedium),
              buildDisable(),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('加载按钮', style: Theme.of(context).textTheme.titleMedium),
              buildLoading(),
              SizedBox(height: AppTheme.comTheme.spacing.medium),
              Text('自定义按钮', style: Theme.of(context).textTheme.titleMedium),
              buildSize(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSize() {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ComButton(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
          color: AppTheme.comTheme.success,
          child: const Text('小尺寸'),
          onPressed: () {},
        ),
        ComButton(
          color: AppTheme.comTheme.warning,
          child: const Text('正常尺寸'),
          onPressed: () {},
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: const EdgeInsets.only(bottom: 4),
          child: ComButton(
            width: Get.width / 2,
            gradient: LinearGradient(colors: [
              AppTheme.comTheme.success!,
              AppTheme.comTheme.warning!
            ]),
            radius: AppTheme.comTheme.shapes.smallRadius,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.adb_sharp, size: 14),
                SizedBox(width: AppTheme.comTheme.spacing.extraSmall),
                const Text('图标按钮'),
              ],
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: AppStyle.buttonHeight,
          child: ComButton(
            gradient: LinearGradient(
                colors: [AppTheme.comTheme.error!, AppTheme.comTheme.warning!]),
            child: const Text('渐变按钮'),
            onPressed: () {
              // Toast.show("111", context: Get.context!);
              showModalBottomSheet(
                  context: ComContext.context,
                  builder: (_) {
                    return const Text('text');
                  });
            },
          ),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Wrap(
      spacing: 8,
      children: [
        ComButton(
          loading: true,
          color: AppTheme.comTheme.success,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(),
              SizedBox(width: AppTheme.comTheme.spacing.extraSmall),
              const Text('加载中...'),
            ],
          ),
          onPressed: () {},
        ),
        ComButton(
          disabled: true,
          color: AppTheme.comTheme.error,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
              SizedBox(width: AppTheme.comTheme.spacing.extraSmall),
              const Text('加载中...'),
            ],
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildDisable() {
    return Wrap(
      spacing: 8,
      children: [
        ComButton(
          disabled: true,
          child: const Text('主要按钮'),
          onPressed: () {},
        ),
        ComButton(
          disabled: true,
          color: AppTheme.comTheme.success,
          child: const Text('成功按钮'),
          onPressed: () {},
        ),
        ComButton(
          disabled: true,
          color: AppTheme.comTheme.warning,
          child: const Text('警告按钮'),
          onPressed: () {},
        ),
        ComButton(
          disabled: true,
          color: AppTheme.comTheme.error,
          child: const Text('危险按钮'),
          onPressed: () {},
        ),
        ComButton(
          disabled: true,
          color: AppTheme.colorScheme.surfaceContainerHighest,
          child: const Text(
            '其他按钮',
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildPlain() {
    return Wrap(
      spacing: 8,
      children: [
        ComButton(
          plain: true,
          child: const Text('主要按钮'),
          onPressed: () {},
        ),
        ComButton(
          plain: true,
          color: AppTheme.comTheme.success,
          child: const Text('成功按钮'),
          onPressed: () {},
        ),
        ComButton(
          plain: true,
          color: AppTheme.comTheme.warning,
          child: const Text('警告按钮'),
          onPressed: () {},
        ),
        ComButton(
          plain: true,
          color: AppTheme.comTheme.error,
          child: const Text('危险按钮'),
          onPressed: () {},
        ),
        ComButton(
          plain: true,
          color: Colors.grey,
          child: const Text(
            '其他按钮',
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildType() {
    return Wrap(
      spacing: 8,
      children: [
        ComButton(
          child: const Text('主要按钮'),
          onPressed: () {},
        ),
        ComButton(
          color: AppTheme.comTheme.success,
          child: const Text('成功按钮'),
          onPressed: () {},
        ),
        ComButton(
          color: AppTheme.comTheme.warning,
          child: const Text('警告按钮'),
          onPressed: () {},
        ),
        ComButton(
          color: AppTheme.comTheme.error,
          child: const Text('危险按钮'),
          onPressed: () {},
        ),
        ComButton(
          color: AppTheme.colorScheme.surfaceContainerHighest,
          child: const Text(
            '其他按钮',
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
