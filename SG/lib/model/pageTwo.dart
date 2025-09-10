import 'dart:convert';


class PageModelTwo<T> {
  ///当前页数
  int curPage = 0;

  ///数据
  List<T> content;

  ///第一页
  bool first = true;

  ///当前页大小
  int size = 0;

  ///总条数
  int total = 0;

  ///当前偏移
  int offset = 0;

  ///当前是否是最后一页
  bool get over  {
   return offset == total;
  }

  void addModels(List<T> models) {
    first = false;
    offset = offset + models.length;
    curPage++;
    content.addAll(models);
  }

  PageModelTwo({
    required this.curPage,
    required this.content,
    required this.size,
    required this.total,
    required this.first,
    required this.offset,
  });

  factory PageModelTwo.fromJson(
    Map<String, dynamic>? json,
    T Function(dynamic json) fromJsonT,
  ) =>
      json == null ? $ApiResultZero() : _$ApiResultFromJson(json!, fromJsonT);
}

/// data:
/// d: any 数据列表
/// s: 当前条数
/// t: 总条数（只有page = 1才会有值）
PageModelTwo<T> _$ApiResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  List<T> content = [];
  final list = json["list"];
  if (list != null && (list is List) && list.isNotEmpty) {
    for (var obj in list) {
      final model = _$nullableGenericFromJson(obj, fromJsonT);
      if (model != null) {
        content.add(model!);
      }
    }
  }

  int totalPage =  json['total_count'] ?? -1;
  int nowOffset = json['s'] ?? 1;

  return PageModelTwo<T>(
    curPage: totalPage > 0 ? 1 : -1,
    content: content,
    size: content.length,
    total: totalPage,
    offset: totalPage > 0 ? nowOffset : -1,
    first: totalPage > 0 ? true : false,
  );
}

PageModelTwo<T> $ApiResultZero<T>() {
  return PageModelTwo<T>(
      curPage: 1,
      content: [],
      size: 0,
      total: 0,
      offset: -1,
      first: true);
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
