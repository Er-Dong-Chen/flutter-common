/// 一个包含了克隆相关操作的通用类。
class CloneUtils {
  /// 克隆一个List。
  ///
  /// 参数 [original] 是原始的List。
  /// 返回克隆后的List。
  static List<T> cloneList<T>(List<T> original) {
    return List<T>.from(original);
  }

  /// 克隆一个Map。
  ///
  /// 参数 [original] 是原始的Map。
  /// 返回克隆后的Map。
  static Map<K, V> cloneMap<K, V>(Map<K, V> original) {
    return Map<K, V>.from(original);
  }

  /// 深拷贝一个对象（需要对象实现clone方法）。
  ///
  /// 参数 [original] 是原始对象。
  /// 返回深拷贝后的对象。
  ///
  /// 如果原始对象没有实现 [Cloneable] 接口，则抛出异常。
  static T deepClone<T>(T original) {
    if (original is Cloneable) {
      return original.clone();
    } else {
      throw Exception("Object does not implement cloneable interface");
    }
  }
}

/// 实现这个接口以允许对象进行深拷贝。
abstract class Cloneable<T> {
  /// 克隆对象。
  T clone();
}
