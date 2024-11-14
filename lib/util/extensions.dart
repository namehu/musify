/// 安全获取列表元素
extension SafeGetList<T> on List<T> {
  /// 安全获取列表元素简化数组越界的问题
  T? tryGet(int index) =>
      index < 0 || index >= this.length ? null : this[index];
}
