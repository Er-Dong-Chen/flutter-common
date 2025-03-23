extension BoolExtension on dynamic {
  bool get isNotBlank {
    if (this == null) return false;

    if (this is bool) return this;

    if (this is String) {
      return this.isNotEmpty;
    }

    if (this is List) {
      return this.isNotEmpty;
    }

    if (this is Map) {
      return this.isNotEmpty;
    }

    if (this is num) {
      return this != 0;
    }

    return true;
  }
}
