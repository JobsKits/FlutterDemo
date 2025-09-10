import 'package:get/get.dart';

/// 根据业务需求，来替换旧的[PageModel]
/// 第二版的 分页model
/// 接口数据{"t":34,"s":20} t表示符合查询查询的数据总条数, s表示一页设定加载多少
class PageCommonModel<T> {
  static const int defaultPage = 1;
  static const int defaultPageSize = 20;
  static const int pageSize10 = 10;
  static const int pageSize15 = 15;

  ///当前第几页，页码
  int curPage = defaultPage; //默认请求第1页开始
  int curPageSize = defaultPageSize; //默认请求每页15条数据

  ///数据
  List<T> content;
  dynamic totalData; //联盟计划，所有数据用到的统计字段

  ///第一页
  bool first = true;

  ///当前页大小, 也就是 apiContent.length 的大小
  int resultPageSize = 0;

  ///当前分页需求量， 请求数据要要求每一页的大小，接口返回
  int resultPageNeedSize = 0;

  ///接口返回的，所有总条数
  int total = 0;

  PageCommonModel({
    required this.curPage,
    required this.content,
    required this.resultPageSize,
    required this.resultPageNeedSize,
    required this.total,
    required this.first,
  });

  ///初始化model
  PageCommonModel.init({
    required this.curPage,
    this.curPageSize = defaultPageSize,
    required this.first,
    required this.content,
  });

  ///不加载更多
  PageCommonModel.initContent({
    this.curPage = defaultPage,
    this.curPageSize = defaultPageSize,
    this.first = true,
    required this.content,
  });

  ///获取加载页
  ///curPage 页面指针预加载， 成功之后再确定，不成功回滚指针
  int pageIndex(bool isRefresh) {
    //使用curPage+1  而不是curPage++ 的目的是请求有可能是失败的；curPage表达的是当前显示的页码
    return isRefresh ? defaultPage : curPage + 1;
  }

  ///是否有更多,如果都是0 的情况，如何处理？
  bool hasMore() {
    return content.length < total;
  }

  // ///清理 并重新设置数据
  // void assignAllData(List<T> models) {
  //   first = true;
  //   curPage = defaultPage;
  //   content.assignAll(models);
  // }

  ///追加数据, assign 是否清理 所有数据
  void addAllData(List<T> models, bool? assign) {
    first = false;
    if (assign != null && assign) {
      curPage = defaultPage;
      content.assignAll(models);
    } else {
      //成功后，改变值
      curPage++;
      content.addAll(models);
    }
  }

  //拷贝数据，是否清除
  void copyWith(PageCommonModel<T> model, bool? assign) {
    //如果是第一页
    addAllData(model.content, assign);
    resultPageSize = model.resultPageSize;
    resultPageNeedSize = model.resultPageNeedSize;
    total = model.total;
  }

/*========================= 针对手动点击上下页 start=========================*/

  void copyWithPnData(PageCommonModel<T> model) {
    //成功后，改变值
    content.assignAll(model.content);
    resultPageSize = model.resultPageSize;
    resultPageNeedSize = model.resultPageNeedSize;
    total = model.total;
  }

  ///pn 表示prev  和 next 的缩写
  ///请求网络 时候 获取
  ///prevPage是否是上一页
  int getPnPageIndex(bool prevPage, {int? jumpPage}) {
    //使用curPage+1  而不是curPage++ 的目的是请求有可能是失败的；curPage表达的是当前显示的页码
    if (jumpPage != null) {
      //优先处理jumpPage
      return jumpPage;
    } else {
      if (prevPage) {
        if ((curPage - 1) < defaultPage) {
          return defaultPage;
        } else {
          return curPage - 1;
        }
      } else {
        return curPage + 1;
      }
    }
  }

  int getPnCurPage() {
    return curPage;
  }

  ///是否还有上一页
  bool hasPrevPage() {
    return curPage != defaultPage;
  }

  ///是否还有下一页
  bool hasNextPage() {
    return total > resultPageSize;
  }

  //todo：去兼容奇葩接口的t字段为0 ，但还有数据的情况
  bool hasNextPage2() {
    return resultPageSize == resultPageNeedSize;
  }

  ///手动更新行 curPage的值
  ///prevPage 是否是上一页
  void updatePnCurPage(bool prevPage, {int? jumpPage}) {
    if (jumpPage != null) {
      curPage = jumpPage;
    } else {
      if (prevPage) {
        curPage--;
        if (curPage < defaultPage) {
          curPage = defaultPage;
        }
      } else {
        //成功后，改变值
        curPage++;
      }
    }
  }

  /*========================= 针对手动点击上下页 end=========================*/

  factory PageCommonModel.fromJson(Map<String, dynamic>? json, T Function(dynamic json) fromJsonT) {
    return json == null ? _$ApiResultZero() : _$ApiResultFromJson(json, fromJsonT);
  }

  @override
  String toString() {
    // return 'PageCommonModel{curPage: $curPage, curPageSize: $curPageSize, content: $content, first: $first, resultPageSize: $resultPageSize, total: $total, resultPageNeedSize: $resultPageNeedSize}';
    return 'PageCommonModel{curPage: $curPage, curPageSize: $curPageSize, content: , first: $first, resultPageSize: $resultPageSize, total: $total, resultPageNeedSize: $resultPageNeedSize}';
  }
}

/// data:
/// d: any 数据列表
/// s: 当前条数
/// t: 总条数（只有page = 1才会有值）
PageCommonModel<T> _$ApiResultFromJson<T>(
    Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
  List<T> apiContent = <T>[];
  final list = json["d"];
  if (list != null && (list is List) && list.isNotEmpty) {
    for (var obj in list) {
      final model = _$nullableGenericFromJson(obj, fromJsonT);
      if (model != null) {
        apiContent.add(model);
      }
    }
  }

  int totalPage = json['t'] ?? -1;
  int needSize = json['s'] ?? 1; //api接口中's' 是指size, 每页多少条数据。

  // String totalAmount = json['total_amount'] ?? "0";
  return PageCommonModel<T>(
    curPage: totalPage > 0 ? 1 : -1,
    content: apiContent,
    resultPageSize: apiContent.length,
    total: totalPage,
    resultPageNeedSize: needSize,
    first: totalPage > 0 ? true : false,
  );
}

PageCommonModel<T> _$ApiResultZero<T>() {
  return PageCommonModel<T>(
      curPage: 1, content: [], resultPageSize: 0, total: 0, resultPageNeedSize: 0, first: true);
}

T? _$nullableGenericFromJson<T>(Object? input, T Function(Object? json) fromJson) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(T? input, Object? Function(T value) toJson) =>
    input == null ? null : toJson(input);
