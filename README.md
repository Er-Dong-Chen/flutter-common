<a name="HJUr4"></a>
## 简介
Flutter common package内涵一些开发常用的组件跟工具类以及功能模块等等，代码简洁优雅且可高度定制
[文档链接🔗](#%20%E3%80%8AFlutter_Chen_Common%E3%80%8B)
```dart
dependencies:
  flutter_chen_common: 最新版本
```
<a name="rwY8X"></a>
## Utils

1. SpUtil：SharedPreferences工具类，温馨提示需要init.
2. FunctionUtil：为所以方法扩展实现节流防抖.
3. LogUtil : 优雅日志打印.
4. DateUtil : 日期转换格式化输出.
5. TextUtil : 银行卡号每隔4位加空格，每隔3三位加逗号，隐藏手机号等等.
6. EncryptUtil : 异或对称加/解密，md5加密，Base64加/解密.
7. JsonUtil : json转换工具类.
<a name="Mbu4V"></a>
## Helper

1. CommonHelper：通用的各类弹窗、提示.
2. ImageHelper：图片选择、裁剪、上传.
3. OssHelper : oss上传，需传一个请求oss配置方法.
4. UpdateHelper : 自定义版本更新.
5. PermissionHelper : 权限判断申请.
6. CacheHelper : 应用缓存.
<a name="H7AaX"></a>
## Widgets

1. RefreshWidget：包含上拉加载、下拉刷新、回至顶部、页面数据状态视图（加载、空数据、列表、瀑布流）等功能的列表刷新组件.
2. ComUpload：图片上传选择器.
3. ComAlbum：仿微信朋友圈图片展示.
4. ComGallery：滑动切换放缩旋转的图片预览.
5. ComSwiper：支持多形式轮播图.
6. ComImage：网络缓存预加载淡入淡出图片
7. ComTab：可实现所有场景Tab.
8. ComButton：通用可渐变按钮、统一节流.
9. ComSearch：通用搜索框.
10. ComTextField：通用文本框.
11. ComRadio：勾选样式Radio.
12. BaseWidget：多状态布局，无网络自动切换该状态布局.
<a name="fik56"></a>
## 网络请求
```dart
/// 初始化RequestClient，传请求url以及请求拦截器
await RequestClient.init(
  baseUrl: Env.getEnvConfig().baseUrl,
  interceptors: [RequestInterceptor()]);

/// 使用
RequestClient.instance.request(
  "/xxxx",
  method: HttpType.post.name,
)
```
<a name="rL6Tq"></a>
## 配置主题以及OSS
```dart
/// 初始化SharedPreferences
await SpUtil.init();
ComConfig.config(theme: AppColors.theme);
ComConfig.setOssConfig(Global.ossConfig);

static Future<Map<String, dynamic>> ossConfig() async {
  var res = await AppApi.ossToken();
  var params = {
    "accessKeyId": res["accessKeyId"],
    "policy": res["policy"],
    "signature": res["signature"],
    "url": "https://${res["bucket"]}.oss-ap-southeast-1.aliyuncs.com",
    "dir": "appName"
    };
  return params;
}
```
<a name="Iwfny"></a>
## RefreshWidget
```dart
class DemoLogic extends PagingController {
  @override
  Future<PagingResponse> loadData() async {
    // TODO: implement loadData
    dynamic result = {"current": 1, "total": 3, "records": []};
    await Future.delayed(2000.milliseconds, () {
      for (var i = 0; i < 20; ++i) {
        result["records"]?.add(i);
      }
    });

    return PagingResponse.fromMapJson(result);
  }
}

class DemoPage extends StatelessWidget {
  DemoPage({Key? key}) : super(key: key);

  final logic = Get.find<DemoLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DemoLogic>(
      builder: (controller) {
        return Scaffold(
            body: RefreshWidget(
              controller: logic,
              slivers: [
                RefreshListWidget(
                    itemBuilder: (item, index) => _buildItem(index),
                    controller: logic,
                    showList: false),
              ],
            ));
      },
      id: logic.pagingState.refreshId,
    );
  }

  Widget _buildItem(index) {
    if (index % 3 == 0) {
      return Container(
        color: Colors.deepOrange,
        width: double.infinity,
        height: 300.h,
      );
    }
    return Container(
      color: Colors.green,
      width: double.infinity,
      height: 200.h,
    );
  }
}
```
