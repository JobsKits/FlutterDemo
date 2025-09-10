// ignore_for_file: constant_identifier_names

/// 活动常量
class ActivityConstants {
  /// 充值大礼包
  static const int ACTIVITY_TYPE_101 = 101;

  ///  天天得意金
  static const int ACTIVITY_TYPE_102 = 102;

  /// 亏损救援金
  static const int ACTIVITY_TYPE_103 = 103;

  /// 新增的 救援金活动
  static const int ACTIVITY_TYPE_203 = 203;

  /// 分享领工资
  static const int ACTIVITY_TYPE_106 = 106;

  /// 游戏任务
  static const int ACTIVITY_TYPE_110 = 110;

  /// 虚拟币充值
  static const int ACTIVITY_TYPE_111 = 111;

  /// 会员任务
  static const int ACTIVITY_TYPE_112 = 112;

  /// 活动奖金
  static const int ACTIVITY_TYPE_113 = 113;

  /// 日常任务
  static const int ACTIVITY_TYPE_204 = 204;
}

/// 内容类型 文字1  图片2  网址3   内部链接4
class ActivityContentType {
  /// 文字
  static const int Text = 1;

  /// 图片
  static const int Image = 2;

  /// 网址
  static const int Website = 3;

  /// 内部链接
  static const int Link = 4;
}

/// 内部链接类型：游戏1   任务2
class ActivityLinkType {
  /// 游戏
  static const int Game = 1;

  /// 任务
  static const int Task = 2;
}

/// 游戏类型：1彩票  2棋牌  3电子 4真人  5捕鱼   6体育  7红包
class ActivityGameType {
  /// 彩票
  static const int Lottery = 1;

  /// 棋牌
  static const int Chess = 2;

  /// 电子
  static const int Electronic = 3;

  /// 真人
  static const int Live = 4;

  /// 捕鱼
  static const int Fishing = 5;

  /// 体育
  static const int Sports = 6;

  /// 红包
  static const int RedPacket = 7;
}

/// 任务类型：1充值大礼包  2有玩就有礼 3分享领工资  4亏损救援金  5游戏任务 7 幸运大转盘
class ActivityTaskType {
  /// 充值大礼包
  static const int Recharge = 1;

  ///  有玩就有礼
  static const int PlayGift = 2;

  /// 分享领工资
  static const int Share = 3;

  /// 亏损救援金
  static const int ReliefFund = 4;

  /// 游戏任务
  static const int GameTask = 5;

  /// 自定义任务
  static const int CustomTask = 6;

  /// 幸运大转盘
  static const int LuckyWheel = 7;
}
