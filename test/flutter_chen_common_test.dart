import 'package:flutter_chen_common/network/http_client.dart';
import 'package:flutter_chen_common/network/http_config.dart';

void main() {
  HttpClient.init(
    config: HttpConfig(
      baseUrl: 'http://47.94.197.133:48080',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      enableLog: true,
      maxRetries: 3,
    ),
  );

  HttpClient.instance.request(
    "/apis/app.uc.synsol.api/file-config/v1alpha1",
    method: HttpMethod.get.name,
  );
}
