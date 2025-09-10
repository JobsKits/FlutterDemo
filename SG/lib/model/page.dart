
class PageModel<T> {
  ///当前第几页，页码
  int curPage = 0;

  ///数据
  List<T> content;

  ///第一页
  bool first = true;

  ///当前页大小, 也就是 apiContent.length 的大小
  int curPageSize = 0;

  ///总条数
  int total = 0;

  ///当前分页需求量， 请求数据要要求每一页的大小
  int curPageNeedSize = 0;

  ///总条数
  String? totalAmount = "0";

  ///当前偏移
  int offset = 0;

  ///当前是否是最后一页
  bool get over {
    return offset == total;
  }

  void addModels(List<T> models) {
    first = false;
    offset = offset + models.length;
    curPage++;
    content.addAll(models);
  }

  PageModel({
    required this.curPage,
    required this.content,
    required this.curPageSize,
    required this.total,
    required this.curPageNeedSize,
    required this.first,
    required this.offset,
    this.totalAmount,
  });

  ///初始化
  PageModel.init({
    required this.curPage,
    required this.first,
    required this.content,
  });

  factory PageModel.fromJson(Map<String, dynamic>? json, T Function(dynamic json) fromJsonT) {
    return json == null ? $ApiResultZero() : _$ApiResultFromJson(json!, fromJsonT);
  }

  @override
  String toString() {
    return 'PageModel{curPage: $curPage, content: $content, first: $first, size: $curPageSize, total: $total, curPageNeedSize: $curPageNeedSize, totalAmount: $totalAmount, offset: $offset}';
  }
}

/// data:
/// d: any 数据列表
/// s: 当前条数
/// t: 总条数（只有page = 1才会有值）
PageModel<T> _$ApiResultFromJson<T>(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
  List<T> apiContent = <T>[];
  final list = json["d"];
  if (list != null && (list is List) && list.isNotEmpty) {
    for (var obj in list) {
      final model = _$nullableGenericFromJson(obj, fromJsonT);
      if (model != null) {
        apiContent.add(model!);
      }
    }
  }

  int totalPage = json['t'] ?? -1;
  int needSize = json['s'] ?? 1; //api接口中's' 是指size, 每页多少条数据。
  String totalAmount = json['total_amount'] ?? "0";
  return PageModel<T>(
    curPage: totalPage > 0 ? 1 : -1,
    content: apiContent,
    curPageSize: apiContent.length,
    total: totalPage,
    curPageNeedSize: needSize,
    totalAmount: totalAmount,
    offset: totalPage > 0 ? needSize : -1,
    first: totalPage > 0 ? true : false,
  );
}

PageModel<T> $ApiResultZero<T>() {
  return PageModel<T>(
      curPage: 1, content: [], curPageSize: 0, total: 0, curPageNeedSize: 0, offset: -1, first: true);
}

T? _$nullableGenericFromJson<T>(Object? input, T Function(Object? json) fromJson) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(T? input, Object? Function(T value) toJson) =>
    input == null ? null : toJson(input);
