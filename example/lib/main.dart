import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/network/network_interceptor.dart';
import 'package:example/pages/component/component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_common/flutter_chen_common.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:module_base/module_base.dart';
import 'package:module_base/widgets/base/com_container.dart';
import 'package:path_provider/path_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ComContext.init(navigatorKey);
  await SpUtil.init();
  Directory dir = await getApplicationDocumentsDirectory();
  await Log.init(
    LogConfig(
      retentionDays: 3,
      enableFileLog: true,
      logLevel: LogLevel.all,
      recordLevel: LogLevel.info,
      output: const [],
      printer: PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime),
      logDirectory: kIsWeb ? null : Directory('${dir.path}/logs'),
    ),
  );
  HttpClient.init(
    config: HttpConfig(
      baseUrl: Env.config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      commonHeaders: () => {"Authorization": SpUtil.getString('token')},
      interceptors: [NetworkInterceptor()],
      enableLog: true,
      enableToken: true,
      enableRetry: true,
      maxRetries: 3,
      retriesDelay: const Duration(seconds: 1),
      getToken: () => SpUtil.getString("token"),
      onRefreshToken: () async {
        return "new_token";
      },
      onRefreshTokenFailed: () async {
        Log.d("重新登录");
      },
    ),
  );

  ComToast.initTheme(
    theme: ComToastTheme(
      success: const ComToastConfig(
        iconWidget:
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
      ),
      error: const ComToastConfig(
        iconWidget: Icon(Icons.cancel, color: Color(0xFFEF4444), size: 20),
      ),
      warning: const ComToastConfig(
        iconWidget:
            Icon(Icons.priority_high, color: Color(0xFFF59E0B), size: 20),
      ),
      info: const ComToastConfig(
        iconWidget:
            Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
      ),
      loading: ComToastConfig(
        builder: (ctx) => const ComContainer(
          width: 120,
          child: ComLoading(),
        ),
        clickThrough: false,
        duration: -1,
      ),
    ),
  );

  Log.d("debug message");
  Log.i("info message");
  Log.w("warning message");
  Log.e("error message");
  Log.console("console message 可完整打印不被截断并且无前缀");
  HttpClient.instance.request("https://gutendex.com/books",
      data: {"xx": "xx"}, options: Options(extra: {'custom': true}));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ComConfiguration(
      config: ComConfig.defaults(),
      child: RefreshConfiguration(
        hideFooterWhenNotFull: false,
        headerBuilder: () => const ClassicHeader(),
        footerBuilder: () => const ClassicFooter(),
        child: GetMaterialApp(
          navigatorKey: navigatorKey,
          builder: ComToastBuilder(),
          navigatorObservers: [ComToastNavigatorObserver()],
          home: ComponentListPage(),
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppThemeMode.getLocalThemeModel(),
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('en', 'US'),
          ],
        ),
      ),
    );
  }
}
