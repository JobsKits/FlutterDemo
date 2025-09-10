extension StringExtension on String {
  bool isImageUrl() {
    final RegExp imagePattern =
        RegExp(r'\.(jpg|jpeg|png|gif|bmp|webp|svg)$', caseSensitive: false);
    return imagePattern.hasMatch(this);
  }
}
