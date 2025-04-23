import 'env_config.dart';
import 'env_dev.dart';
import 'env_prod.dart';
import 'env_stage.dart';

enum EnvEnum { dev, stage, prod }

class Env {
  /// 默认环境
  static EnvEnum mEnv = EnvEnum.prod;

  /// 获取当前环境
  static EnvEnum getEnv() {
    return mEnv;
  }

  /// 获取环境配置
  static EnvConfig getEnvConfig() {
    switch (getEnv()) {
      case EnvEnum.stage:
        return StageConfig();
      case EnvEnum.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
