extension ListExtension<T> on List<T> {
  /// 判断列表是否为空
  bool get isEmptyOrNull => isEmpty;

  /// 判断列表是否不为空
  bool get isNotEmptyOrNull => isNotEmpty;

  /// 获取列表的第一个元素，如果为空则返回null
  T? get firstOrNull => isEmpty ? null : first;

  /// 获取列表的最后一个元素，如果为空则返回null
  T? get lastOrNull => isEmpty ? null : last;

  /// 获取指定索引的元素，如果索引越界则返回null
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// 列表去重
  List<T> distinct() {
    return toSet().toList();
  }

  /// 对列表进行分组
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(element);
    }
    return map;
  }

  /// 获取列表中的唯一元素
  List<T> get unique {
    return toSet().toList();
  }

  /// 随机打乱列表
  List<T> get shuffled {
    final list = List<T>.from(this);
    list.shuffle();
    return list;
  }

  /// 获取列表中的随机元素
  T? get random {
    if (isEmpty) return null;
    return this[DateTime.now().millisecondsSinceEpoch % length];
  }

  /// 将列表分割成指定大小的子列表
  List<List<T>> chunk(int size) {
    if (size <= 0) return [this];
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, i + size > length ? length : i + size));
    }
    return result;
  }

  /// 对列表进行分页
  List<T> paginate(int pageNum, int pageSize) {
    final start = (pageNum - 1) * pageSize;
    if (start >= length) return [];
    final end = start + pageSize > length ? length : start + pageSize;
    return sublist(start, end);
  }
}
