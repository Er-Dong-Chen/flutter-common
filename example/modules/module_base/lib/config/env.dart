import 'env_config.dart';
import 'env_dev.dart';
import 'env_prod.dart';
import 'env_stage.dart';

enum EnvEnum { dev, stage, prod }

class Env {
  /// 当前环境，默认生产环境
  static EnvEnum _currentEnv = EnvEnum.prod;

  /// 设置环境
  static void setEnv(EnvEnum env) {
    _currentEnv = env;
  }

  /// 获取环境配置信息
  static EnvConfig get config => _getEnvConfig();

  /// 获取当前环境
  static EnvEnum get env => _currentEnv;

  static EnvConfig _getEnvConfig() {
    final envMap = {
      EnvEnum.dev: DevConfig(),
      EnvEnum.stage: StageConfig(),
      EnvEnum.prod: ProdConfig(),
    };

    return envMap[_currentEnv] ?? DevConfig();
  }
}
