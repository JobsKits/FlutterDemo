class UrlUtils {
  static bool isHtmlText(String input) {
    // 定义一个正则表达式，匹配 HTML 标签
    final RegExp htmlTagPattern = RegExp(r"<[^>]+>", caseSensitive: false);

    // 使用正则表达式匹配输入字符串，如果匹配到HTML标签，返回true
    return htmlTagPattern.hasMatch(input);
  }
}
