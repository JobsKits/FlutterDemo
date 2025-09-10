import 'dart:async';

class DebounceThrottle {
  // 存储定时器
  static final Map<String, Timer?> _timers = {};
  // 存储每个方法的节流状态
  static final Map<String, bool> _isThrottled = {};

  // 防抖函数实现
  static Function debounce(Function callback, [int milliseconds = 150]) {
    return () {
      // String key = callback.hashCode.toString();
      String key = callback.toString();
      // 如果存在定时器，则取消它
      _timers[key]?.cancel();

      // 新建一个定时器，延迟执行回调
      _timers[key] = Timer(Duration(milliseconds: milliseconds), () {
        callback.call(); // 延迟调用 _callback
        _timers.remove(key); // 定时器完成后从 Map 中移除
      });
    };
  }

  // 节流函数实现
  static Function throttle(Function callback, [int milliseconds = 150]) {
    // String key = callback.hashCode.toString(); // 如果没有提供 key，使用 hashCode
    String key = callback.toString();

    // 初始化节流状态
    _isThrottled.putIfAbsent(key, () => false);

    return () {
      // 检查是否已在节流状态中
      if (_isThrottled[key]!) return;

      _isThrottled[key] = true; // 禁止后续调用
      callback.call(); // 调用回调函数

      // 设置一个定时器，在指定延迟后恢复可调用状态
      Timer(Duration(milliseconds: milliseconds), () {
        _isThrottled[key] = false; // 恢复可调用状态
      });
    };
  }
}
