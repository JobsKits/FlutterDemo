// 玩法的选号球信息
const Map ballAreaAll = {
  /* 广东11选5 */
  22000: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 300,
        'ballpanid': 601,
        'extid': '2'
      }
    ]
  },
  22001: {
    'areas': [
      {'show': '组选', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22002: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22003: {
    'areas': [
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 100,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 200,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 300,
        'ballpanid': 601,
        'extid': '2'
      }
    ]
  },
  22004: {
    'areas': [
      {'show': '组选', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22005: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22006: {
    'areas': [
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 100,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 200,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 300,
        'ballpanid': 601,
        'extid': '2'
      }
    ]
  },
  22007: {
    'areas': [
      {'show': '组选', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22008: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22009: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 601,
        'extid': '2'
      }
    ]
  },
  22010: {
    'areas': [
      {'show': '组选', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22011: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22012: {
    'areas': [
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 100,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 200,
        'ballpanid': 601,
        'extid': '2'
      }
    ]
  },
  22013: {
    'areas': [
      {'show': '组选', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22014: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22015: {
    'areas': [
      {'show': '前三', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22016: {
    'areas': [
      {'show': '中三', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22017: {
    'areas': [
      {'show': '后三', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22018: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 300,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 400,
        'ballpanid': 601,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 500,
        'ballpanid': 601,
        'extid': '2'
      }
    ]
  },
  22019: {
    'areas': [
      {'show': '一中一', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22020: {
    'areas': [
      {'show': '二中二', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22021: {
    'areas': [
      {'show': '三中三', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22022: {
    'areas': [
      {'show': '四中四', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22023: {
    'areas': [
      {'show': '五中五', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22024: {
    'areas': [
      {'show': '六中五', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22025: {
    'areas': [
      {'show': '七中五', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22026: {
    'areas': [
      {'show': '八中五', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22027: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22028: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22029: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22030: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22031: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22032: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },
  22033: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 601, 'extid': '2'},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 601, 'extid': '2'}
    ]
  },

  /* pk10 */
  // 猜冠军
  34000: {
    'areas': [
      {
        'show': '冠',
        'en': 'First',
        'baseballid': 100,
        'ballpanid': 101,
        'extid': 2
      }
    ]
  },
  // 猜冠亚军
  34100: {
    'areas': [
      {
        'show': '冠',
        'en': 'First',
        'baseballid': 100,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '亚',
        'en': 'Second',
        'baseballid': 200,
        'ballpanid': 101,
        'extid': 2
      }
    ]
  },
  // 猜前三名
  34200: {
    'areas': [
      {
        'show': '冠',
        'en': 'First',
        'baseballid': 100,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '亚',
        'en': 'Second',
        'baseballid': 200,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '季',
        'en': 'Third',
        'baseballid': 300,
        'ballpanid': 101,
        'extid': 2
      }
    ]
  },
  // 两面
  34300: {
    'areas': [
      {'show': '冠', 'en': 'First', 'baseballid': 100, 'ballpanid': 102},
      {'show': '亚', 'en': 'Second', 'baseballid': 200, 'ballpanid': 102},
      {'show': '季', 'en': 'Third', 'baseballid': 300, 'ballpanid': 102},
      {'show': '四', 'en': 'Fourth', 'baseballid': 400, 'ballpanid': 102},
      {'show': '五', 'en': 'Fifth', 'baseballid': 500, 'ballpanid': 102},
      {'show': '六', 'en': 'Sixth', 'baseballid': 600, 'ballpanid': 102},
      {'show': '七', 'en': 'Seventh', 'baseballid': 700, 'ballpanid': 102},
      {'show': '八', 'en': 'Eighth', 'baseballid': 800, 'ballpanid': 102},
      {'show': '九', 'en': 'Ninth', 'baseballid': 900, 'ballpanid': 102},
      {'show': '十', 'en': 'Tenth', 'baseballid': 1000, 'ballpanid': 102}
    ]
  },
  // 龙虎
  34400: {
    'areas': [
      {'show': '冠军VS十位', 'baseballid': 100, 'ballpanid': 103},
      {'show': '亚军VS九位', 'baseballid': 200, 'ballpanid': 103},
      {'show': '季军VS八位', 'baseballid': 300, 'ballpanid': 103},
      {'show': '四位VS七位', 'baseballid': 400, 'ballpanid': 103},
      {'show': '五位VS六位', 'baseballid': 500, 'ballpanid': 103}
    ]
  },
  // 冠亚季选一
  34500: {'areas': []},
  // 冠亚组合
  34600: {'areas': []},
  // 冠亚总和
  34601: {'areas': []},
  // 定位胆
  34700: {
    'areas': [
      {
        'show': '冠',
        'en': 'First',
        'baseballid': 100,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '亚',
        'en': 'Second',
        'baseballid': 200,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '季',
        'en': 'Third',
        'baseballid': 300,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '四',
        'en': 'Fourth',
        'baseballid': 400,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '五',
        'en': 'Fifth',
        'baseballid': 500,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '六',
        'en': 'Sixth',
        'baseballid': 600,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '七',
        'en': 'Seventh',
        'baseballid': 700,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '八',
        'en': 'Eighth',
        'baseballid': 800,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '九',
        'en': 'Ninth',
        'baseballid': 900,
        'ballpanid': 101,
        'extid': 2
      },
      {
        'show': '十',
        'en': 'Tenth',
        'baseballid': 1000,
        'ballpanid': 101,
        'extid': 2
      }
    ]
  },
  // 冠亚和值单双
  34800: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 104}
    ]
  },
  // 冠亚和值大小
  34801: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 105}
    ]
  },
  // 冠亚和值指定
  34802: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 106, 'extid': 2}
    ]
  },

  /* 北京28 */
  //	普通投注(猜数字)
  40000: {
    'areas': [
      {'show': '猜数字', 'baseballid': 0, 'ballpanid': 201}
    ]
  },

  //	大小单双
  40001: {
    'areas': [
      {'show': '大小单双', 'baseballid': 0, 'ballpanid': 202}
    ]
  },

  //	波色
  40002: {
    'areas': [
      {'show': '波色', 'baseballid': 0, 'ballpanid': 203}
    ]
  },

  //	豹子
  40003: {
    'areas': [
      {'show': '', 'baseballid': 0, 'ballpanid': 204}
    ]
  },

  //	特码包3
  40004: {
    'areas': [
      {'show': '', 'baseballid': 0, 'ballpanid': 205}
    ]
  },

  /* 加拿大28 */
  //	普通投注(猜数字)
  41000: {
    'areas': [
      {'show': '猜数字', 'baseballid': 0, 'ballpanid': 201}
    ]
  },

  //	大小单双
  41001: {
    'areas': [
      {'show': '大小单双', 'baseballid': 0, 'ballpanid': 202}
    ]
  },

  //	波色
  41002: {
    'areas': [
      {'show': '波色', 'baseballid': 0, 'ballpanid': 203}
    ]
  },

  //	豹子
  41003: {
    'areas': [
      {'show': '', 'baseballid': 0, 'ballpanid': 204}
    ]
  },

  //	特码包3
  41004: {
    'areas': [
      {'show': '', 'baseballid': 0, 'ballpanid': 205}
    ]
  },

  /* 重庆时时彩 */
  // 定位胆
  17000: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 400,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 500,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 前二直选复式
  17001: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 前二直选和值
  17002: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 302, 'extid': '2'}
    ]
  },
  // 前二直选跨度
  17003: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后二直选复式
  17004: {
    'areas': [
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 后二直选和值
  17005: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 302, 'extid': '2'}
    ]
  },
  // 后二直选跨度
  17006: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前二组选复式
  17007: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前二组选和值
  17008: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 303, 'extid': '2'}
    ]
  },
  // 前二组选包胆
  17009: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后二组选复式
  17010: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后二组选和值
  17011: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 303, 'extid': '2'}
    ]
  },
  // 后二组选包胆
  17012: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三直选复式
  17013: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 前三直选和值
  17014: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 304, 'extid': '2'}
    ]
  },
  // 前三直选跨度
  17015: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三直选组合
  17016: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 前三组选组三
  17017: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三组选组六
  17018: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三组选组选和值
  17019: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 305, 'extid': '2'}
    ]
  },
  // 前三组选组选包胆
  17020: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三其他和值尾数
  17021: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三其他特殊号码
  17022: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 306, 'extid': '2'}
    ]
  },
  // 中三直选复式
  17023: {
    'areas': [
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 中三直选和值
  17024: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 304, 'extid': '2'}
    ]
  },
  // 中三直选跨度
  17025: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 中三直选组合
  17026: {
    'areas': [
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 中三组选组三
  17027: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 中三组选组六
  17028: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 中三组选组选和值
  17029: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 305, 'extid': '2'}
    ]
  },
  // 中三组选组选包胆
  17030: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 中三其他和值尾数
  17031: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 中三其他特殊号码
  17032: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 306, 'extid': '2'}
    ]
  },

  // 后三直选复式
  17033: {
    'areas': [
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 后三直选和值
  17034: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 304, 'extid': '2'}
    ]
  },
  // 后三直选跨度
  17035: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三直选组合
  17036: {
    'areas': [
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 后三组选组三
  17037: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三组选组六
  17038: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三组选组选和值
  17039: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 305, 'extid': '2'}
    ]
  },
  // 后三组选组选包胆
  17040: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三其他和值尾数
  17041: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三其他特殊号码
  17042: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 306, 'extid': '2'}
    ]
  },

  // 后四直选
  17043: {
    'areas': [
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 400,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 五星直选
  17044: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'baseballid': 100,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '千',
        'en': 'thousand',
        'baseballid': 200,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '百',
        'en': 'hundred',
        'baseballid': 300,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 400,
        'ballpanid': 301,
        'extid': '2'
      },
      {
        'show': '个',
        'en': 'individual',
        'baseballid': 500,
        'ballpanid': 301,
        'extid': '2'
      }
    ]
  },
  // 大小单双后二
  17045: {
    'areas': [
      {'show': '十', 'en': 'ten', 'baseballid': 100, 'ballpanid': 307},
      {'show': '个', 'en': 'individual', 'baseballid': 200, 'ballpanid': 307}
    ]
  },
  // 大小单双后三
  17046: {
    'areas': [
      {'show': '百', 'en': 'hundred', 'baseballid': 100, 'ballpanid': 307},
      {'show': '十', 'en': 'ten', 'baseballid': 200, 'ballpanid': 307},
      {'show': '个', 'en': 'individual', 'baseballid': 300, 'ballpanid': 307}
    ]
  },
  // 大小单双前二
  17047: {
    'areas': [
      {'show': '万', 'en': 'myriad', 'baseballid': 100, 'ballpanid': 307},
      {'show': '千', 'en': 'thousand', 'baseballid': 200, 'ballpanid': 307}
    ]
  },
  // 大小单双前三
  17048: {
    'areas': [
      {'show': '万', 'en': 'myriad', 'baseballid': 100, 'ballpanid': 307},
      {'show': '千', 'en': 'thousand', 'baseballid': 200, 'ballpanid': 307},
      {'show': '百', 'en': 'hundred', 'baseballid': 300, 'ballpanid': 307}
    ]
  },
  // 前三一码不定位
  17049: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前三二码不定位
  17050: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三一码不定位
  17051: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后三二码不定位
  17052: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前四一码不定位
  17053: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 前四二码不定位
  17054: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后四一码不定位
  17055: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 后四二码不定位
  17056: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 五星一码不定位
  17057: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 五星二码不定位
  17058: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 五星三码不定位
  17059: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 四星组选4
  17060: {
    'areas': [
      {'show': '三重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17061: {
    'areas': [
      {'show': '二重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17062: {
    'areas': [
      {'show': '二重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17063: {
    'areas': [
      {'show': '组选24', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17064: {
    'areas': [
      {'show': '四重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17065: {
    'areas': [
      {'show': '三重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '二重号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17066: {
    'areas': [
      {'show': '三重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17067: {
    'areas': [
      {'show': '二重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17068: {
    'areas': [
      {'show': '二重号', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17069: {
    'areas': [
      {'show': '组选120', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17070: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17071: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17072: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17073: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  17074: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17075: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17076: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17077: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17078: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17079: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17080: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17081: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17082: {
    'areas': [
      {'show': '', 'baseballid': 'text'}
    ]
  },

  // 任二
  // 直选复式
  17083: {
    'areas': [
      {'show': '万位', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '千位', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'},
      {'show': '百位', 'baseballid': 300, 'ballpanid': 301, 'extid': '2'},
      {'show': '十位', 'baseballid': 400, 'ballpanid': 301, 'extid': '2'},
      {'show': '个位', 'baseballid': 500, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 直选单式
  17084: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 2,
          'balls': [4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },
  // 直选和值
  17085: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 2,
          'balls': [4, 5]
        }
      },
      {'show': '和值', 'baseballid': 200, 'ballpanid': 302, 'extid': '2'}
    ]
  },
  // 组选复式
  17086: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 2,
          'balls': [4, 5]
        }
      },
      {'show': '组选', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 组选单式
  17087: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 2,
          'balls': [4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },
  // 组选和值
  17088: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 2,
          'balls': [4, 5]
        }
      },
      {'show': '和值', 'baseballid': 200, 'ballpanid': 303, 'extid': '2'}
    ]
  },

  // 任三
  // 直选复式
  17089: {
    'areas': [
      {'show': '万位', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '千位', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'},
      {'show': '百位', 'baseballid': 300, 'ballpanid': 301, 'extid': '2'},
      {'show': '十位', 'baseballid': 400, 'ballpanid': 301, 'extid': '2'},
      {'show': '个位', 'baseballid': 500, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 直选单式
  17090: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },
  // 直选和值'
  17091: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '和值', 'baseballid': 200, 'ballpanid': 304, 'extid': '2'}
    ]
  },
  // 组三复式
  17092: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '组三', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 组三单式
  17093: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17094: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '组六', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 组六单式
  17095: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },
  17096: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 3,
          'balls': [3, 4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },

  // 任四
  // 直选复式
  17097: {
    'areas': [
      {'show': '万位', 'baseballid': 100, 'ballpanid': 301, 'extid': '2'},
      {'show': '千位', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'},
      {'show': '百位', 'baseballid': 300, 'ballpanid': 301, 'extid': '2'},
      {'show': '十位', 'baseballid': 400, 'ballpanid': 301, 'extid': '2'},
      {'show': '个位', 'baseballid': 500, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 直选单式
  17098: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 4,
          'balls': [2, 3, 4, 5]
        }
      },
      {'show': '', 'baseballid': 'text'}
    ]
  },
  // 组选24
  17099: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 4,
          'balls': [2, 3, 4, 5]
        }
      },
      {'show': '组选24', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 组选12
  17100: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 4,
          'balls': [2, 3, 4, 5]
        }
      },
      {'show': '二重号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 300, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 组选6
  17101: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 4,
          'balls': [2, 3, 4, 5]
        }
      },
      {'show': '二重号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'}
    ]
  },
  // 组选4
  17102: {
    'areas': [
      {
        'show': '选择框',
        'baseballid': 100,
        'ballpanid': 308,
        'isoption': true,
        'option': {
          'min': 4,
          'balls': [2, 3, 4, 5]
        }
      },
      {'show': '三重号', 'baseballid': 200, 'ballpanid': 301, 'extid': '2'},
      {'show': '单号', 'baseballid': 300, 'ballpanid': 301, 'extid': '2'}
    ]
  },

  /* 快3 */
  37000: {
    'areas': [
      {'show': '和值', 'baseballid': 100, 'ballpanid': 401}
    ]
  },
  37100: {
    'areas': [
      {'show': '同号', 'baseballid': 100, 'ballpanid': 407},
      {'show': '不同号', 'baseballid': 200, 'ballpanid': 404}
    ]
  },
  37200: {
    'areas': [
      {'show': '二同号复选', 'baseballid': 100, 'ballpanid': 407}
    ]
  },
  37201: {
    'areas': [
      {'show': '二同号', 'baseballid': 100, 'ballpanid': 407}
    ]
  },
  37300: {
    'areas': [
      {'show': '二不同号', 'baseballid': 100, 'ballpanid': 404}
    ]
  },
  37400: {
    'areas': [
      {'show': '三不同号', 'baseballid': 100, 'ballpanid': 404}
    ]
  },
  37500: {
    'areas': [
      {'show': '三同号单选', 'baseballid': 100, 'ballpanid': 403}
    ]
  },
  37600: {
    'areas': [
      {'show': '三同号通选', 'baseballid': 100, 'ballpanid': 402}
    ]
  },
  37700: {
    'areas': [
      {'show': '三连号通选', 'baseballid': 100, 'ballpanid': 405}
    ]
  },
  /* 虚拟币 */
  38100: {
    'areas': [
      {'show': '反投', 'baseballid': 100, 'ballpanid': 411}
    ]
  },
  38200: {
    'areas': [
      {'show': '和值', 'baseballid': 200, 'ballpanid': 412}
    ]
  },
  38300: {
    'areas': [
      {'show': '正投', 'baseballid': 300, 'ballpanid': 413}
    ]
  },
  38400: {
    'areas': [
      {'show': '和值反投', 'baseballid': 400, 'ballpanid': 414}
    ]
  },
  38500: {
    'areas': [
      {'show': '后二和值', 'baseballid': 500, 'ballpanid': 415}
    ]
  },
  39100: {
    'areas': [
      {'show': '区块', 'baseballid': 100, 'ballpanid': 416}
    ]
  },

  /* 重庆六合彩 */
  42000: {
    'areas': [
      {'show': '特码', 'baseballid': 100, 'ballpanid': 501}
    ]
  },
  42001: {
    'areas': [
      {'show': '生肖', 'baseballid': 100, 'ballpanid': 502}
    ]
  },
  42002: {
    'areas': [
      {'show': '组合', 'baseballid': 100, 'ballpanid': 503}
    ]
  },
  42003: {
    'areas': [
      {'show': '波色', 'baseballid': 100, 'ballpanid': 504}
    ]
  },
  // 印度彩
  52000: {
    'areas': [
      {'show': '绿色', 'baseballid': 500, 'ballpanid': 1001, 'maxselect': 1}
    ]
  },
  52001: {
    'areas': [
      {'show': '红色', 'baseballid': 500, 'ballpanid': 1002, 'maxselect': 1}
    ]
  },
  52002: {
    'areas': [
      {'show': '紫色', 'baseballid': 500, 'ballpanid': 1003, 'maxselect': 1}
    ]
  },
  52003: {
    'areas': [
      {'show': '选号码', 'baseballid': 500, 'ballpanid': 1004, 'maxselect': 1}
    ]
  },

  /* 重庆时时彩-经典 */
  54000: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'webshow': '第一球(万位)',
        'baseballid': 100,
        'ballpanid': 701,
        'basecmd': 100
      },
      {
        'show': '千',
        'en': 'thousand',
        'webshow': '第二球(千位)',
        'baseballid': 200,
        'ballpanid': 701,
        'basecmd': 200
      },
      {
        'show': '百',
        'en': 'hundred',
        'webshow': '第三球(百位)',
        'baseballid': 300,
        'ballpanid': 701,
        'basecmd': 300
      },
      {
        'show': '十',
        'en': 'ten',
        'webshow': '第四球(十位)',
        'baseballid': 400,
        'ballpanid': 701,
        'basecmd': 400
      },
      {
        'show': '个',
        'en': 'individual',
        'webshow': '第五球(个位)',
        'baseballid': 500,
        'ballpanid': 701,
        'basecmd': 500
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 600,
        'ballpanid': 705,
        'basecmd': 600
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 700,
        'ballpanid': 705,
        'basecmd': 700
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 800,
        'ballpanid': 705,
        'basecmd': 800
      }
    ]
  },
  54001: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'webshow': '第一球(万位)',
        'baseballid': 100,
        'ballpanid': 703,
        'basecmd': 100
      },
      {
        'show': '千',
        'en': 'thousand',
        'webshow': '第二球(千位)',
        'baseballid': 200,
        'ballpanid': 703,
        'basecmd': 200
      },
      {
        'show': '百',
        'en': 'hundred',
        'webshow': '第三球(百位)',
        'baseballid': 300,
        'ballpanid': 703,
        'basecmd': 300
      },
      {
        'show': '十',
        'en': 'ten',
        'webshow': '第四球(十位)',
        'baseballid': 400,
        'ballpanid': 703,
        'basecmd': 400
      },
      {
        'show': '个',
        'en': 'individual',
        'webshow': '第五球(个位)',
        'baseballid': 500,
        'ballpanid': 703,
        'basecmd': 500
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 600,
        'ballpanid': 705,
        'basecmd': 600
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 700,
        'ballpanid': 705,
        'basecmd': 700
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 800,
        'ballpanid': 705,
        'basecmd': 800
      }
    ]
  },
  54002: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'webshow': '第一球(万位)',
        'baseballid': 100,
        'ballpanid': 704,
        'basecmd': 100
      },
      {
        'show': '千',
        'en': 'thousand',
        'webshow': '第二球(千位)',
        'baseballid': 200,
        'ballpanid': 704,
        'basecmd': 200
      },
      {
        'show': '百',
        'en': 'hundred',
        'webshow': '第三球(百位)',
        'baseballid': 300,
        'ballpanid': 704,
        'basecmd': 300
      },
      {
        'show': '十',
        'en': 'ten',
        'webshow': '第四球(十位)',
        'baseballid': 400,
        'ballpanid': 704,
        'basecmd': 400
      },
      {
        'show': '个',
        'en': 'individual',
        'webshow': '第五球(个位)',
        'baseballid': 500,
        'ballpanid': 704,
        'basecmd': 500
      },
      {
        'show': '总和/龙虎',
        'webshow': '总和/龙虎',
        'baseballid': 600,
        'ballpanid': 706,
        'basecmd': 600
      }
    ]
  },
  54003: {
    'areas': [
      {
        'show': '万',
        'en': 'myriad',
        'webshow': '第一球(万位)',
        'baseballid': 100,
        'ballpanid': 701,
        'basecmd': 100
      },
      {
        'show': '总和/龙虎',
        'webshow': '总和/龙虎',
        'baseballid': 200,
        'ballpanid': 706,
        'basecmd': 200
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 300,
        'ballpanid': 705,
        'basecmd': 300
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 400,
        'ballpanid': 705,
        'basecmd': 400
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 500,
        'ballpanid': 705,
        'basecmd': 500
      }
    ]
  },
  54004: {
    'areas': [
      {
        'show': '千',
        'en': 'thousand',
        'webshow': '第二球(千位)',
        'baseballid': 100,
        'ballpanid': 701,
        'basecmd': 100
      },
      {
        'show': '总和/龙虎',
        'webshow': '总和/龙虎',
        'baseballid': 200,
        'ballpanid': 707,
        'basecmd': 200
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 300,
        'ballpanid': 705,
        'basecmd': 300
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 400,
        'ballpanid': 705,
        'basecmd': 400
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 500,
        'ballpanid': 705,
        'basecmd': 500
      }
    ]
  },
  54005: {
    'areas': [
      {
        'show': '百',
        'en': 'hundred',
        'webshow': '第三球(百位)',
        'baseballid': 100,
        'ballpanid': 701,
        'basecmd': 100
      },
      {
        'show': '总和/龙虎',
        'webshow': '总和/龙虎',
        'baseballid': 200,
        'ballpanid': 707,
        'basecmd': 200
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 300,
        'ballpanid': 705,
        'basecmd': 300
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 400,
        'ballpanid': 705,
        'basecmd': 400
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 500,
        'ballpanid': 705,
        'basecmd': 500
      }
    ]
  },
  54006: {
    'areas': [
      {
        'show': '十',
        'en': 'ten',
        'webshow': '第四球(十位)',
        'baseballid': 100,
        'ballpanid': 701,
        'basecmd': 100
      },
      {
        'show': '总和/龙虎',
        'webshow': '总和/龙虎',
        'baseballid': 200,
        'ballpanid': 707,
        'basecmd': 200
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 300,
        'ballpanid': 705,
        'basecmd': 300
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 400,
        'ballpanid': 705,
        'basecmd': 400
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 500,
        'ballpanid': 705,
        'basecmd': 500
      }
    ]
  },
  54007: {
    'areas': [
      {
        'show': '个',
        'en': 'individual',
        'webshow': '第五球(个位)',
        'baseballid': 100,
        'ballpanid': 701,
        'basecmd': 100
      },
      {
        'show': '总和/龙虎',
        'webshow': '总和/龙虎',
        'baseballid': 200,
        'ballpanid': 707,
        'basecmd': 200
      },
      {
        'show': '前三',
        'webshow': '前三(百千万位)',
        'baseballid': 300,
        'ballpanid': 705,
        'basecmd': 300
      },
      {
        'show': '中三',
        'webshow': '中三(十百千位)',
        'baseballid': 400,
        'ballpanid': 705,
        'basecmd': 400
      },
      {
        'show': '后三',
        'webshow': '后三(个十百位)',
        'baseballid': 500,
        'ballpanid': 705,
        'basecmd': 500
      }
    ]
  },

  /* 北京赛车-经典 */
  // 数字盘
  57000: {
    'areas': [
      {'show': '冠军', 'baseballid': 1000, 'ballpanid': 801, 'basecmd': 1000},
      {'show': '亚军', 'baseballid': 1100, 'ballpanid': 801, 'basecmd': 1100},
      {'show': '季军', 'baseballid': 1200, 'ballpanid': 801, 'basecmd': 1200},
      {'show': '第4名', 'baseballid': 1300, 'ballpanid': 801, 'basecmd': 1300},
      {'show': '第5名', 'baseballid': 1400, 'ballpanid': 801, 'basecmd': 1400},
      {'show': '第6名', 'baseballid': 1500, 'ballpanid': 801, 'basecmd': 1500},
      {'show': '第7名', 'baseballid': 1600, 'ballpanid': 801, 'basecmd': 1600},
      {'show': '第8名', 'baseballid': 1700, 'ballpanid': 801, 'basecmd': 1700},
      {'show': '第9名', 'baseballid': 1800, 'ballpanid': 801, 'basecmd': 1800},
      {'show': '第10名', 'baseballid': 1900, 'ballpanid': 801, 'basecmd': 1900}
    ]
  },
  // 两面盘
  57001: {
    'areas': [
      {'show': '冠、亚军和', 'baseballid': 1000, 'ballpanid': 802, 'basecmd': 1000},
      {'show': '冠军', 'baseballid': 1100, 'ballpanid': 803, 'basecmd': 1100},
      {'show': '亚军', 'baseballid': 1200, 'ballpanid': 803, 'basecmd': 1200},
      {'show': '季军', 'baseballid': 1300, 'ballpanid': 803, 'basecmd': 1300},
      {'show': '第4名', 'baseballid': 1400, 'ballpanid': 803, 'basecmd': 1400},
      {'show': '第5名', 'baseballid': 1500, 'ballpanid': 803, 'basecmd': 1500},
      {'show': '第6名', 'baseballid': 1600, 'ballpanid': 804, 'basecmd': 1600},
      {'show': '第7名', 'baseballid': 1700, 'ballpanid': 804, 'basecmd': 1700},
      {'show': '第8名', 'baseballid': 1800, 'ballpanid': 804, 'basecmd': 1800},
      {'show': '第9名', 'baseballid': 1900, 'ballpanid': 804, 'basecmd': 1900},
      {'show': '第10名', 'baseballid': 2000, 'ballpanid': 804, 'basecmd': 2000}
    ]
  },
  // 冠、亚军和
  57002: {
    'areas': [
      {'show': '冠、亚军和', 'baseballid': 1000, 'ballpanid': 805, 'basecmd': 1000},
      {'show': '冠军', 'baseballid': 1100, 'ballpanid': 807, 'basecmd': 1100},
      {'show': '亚军', 'baseballid': 1200, 'ballpanid': 807, 'basecmd': 1200}
    ]
  },
  // 1~5
  57003: {
    'areas': [
      {'show': '第1名', 'baseballid': 1000, 'ballpanid': 806, 'basecmd': 1000},
      {'show': '第2名', 'baseballid': 1100, 'ballpanid': 806, 'basecmd': 1100},
      {'show': '第3名', 'baseballid': 1200, 'ballpanid': 806, 'basecmd': 1200},
      {'show': '第4名', 'baseballid': 1300, 'ballpanid': 806, 'basecmd': 1300},
      {'show': '第5名', 'baseballid': 1400, 'ballpanid': 806, 'basecmd': 1400}
    ]
  },
  // 6~10
  57004: {
    'areas': [
      {'show': '第6名', 'baseballid': 1000, 'ballpanid': 807, 'basecmd': 1000},
      {'show': '第7名', 'baseballid': 1100, 'ballpanid': 807, 'basecmd': 1100},
      {'show': '第8名', 'baseballid': 1200, 'ballpanid': 807, 'basecmd': 1200},
      {'show': '第9名', 'baseballid': 1300, 'ballpanid': 807, 'basecmd': 1300},
      {'show': '第10名', 'baseballid': 1400, 'ballpanid': 807, 'basecmd': 1400}
    ]
  },
  // 冠亚军组合
  57005: {
    'areas': [
      {'show': '冠亚军组合', 'baseballid': 1000, 'ballpanid': 808, 'basecmd': 1000}
    ]
  },

  /* 幸运飞艇  */
  // 前一直选复式
  58000: {
    'areas': [
      {'show': '冠', 'baseballid': 100, 'ballpanid': 101, 'extid': 2}
    ]
  },
  // 前二直选复式
  58100: {
    'areas': [
      {'show': '冠', 'baseballid': 100, 'ballpanid': 101, 'extid': 2},
      {'show': '亚', 'baseballid': 200, 'ballpanid': 101, 'extid': 2}
    ]
  },
  // 前三直选复式
  58200: {
    'areas': [
      {'show': '冠', 'baseballid': 100, 'ballpanid': 101, 'extid': 2},
      {'show': '亚', 'baseballid': 200, 'ballpanid': 101, 'extid': 2},
      {'show': '季', 'baseballid': 300, 'ballpanid': 101, 'extid': 2}
    ]
  },
  // 龙虎
  58400: {
    'areas': [
      {'show': '1V10', 'baseballid': 100, 'ballpanid': 103},
      {'show': '2V9', 'baseballid': 200, 'ballpanid': 103},
      {'show': '3V8', 'baseballid': 300, 'ballpanid': 103},
      {'show': '4V7', 'baseballid': 400, 'ballpanid': 103},
      {'show': '5V6', 'baseballid': 500, 'ballpanid': 103}
    ]
  },

  // 前四直选复式
  58500: {
    'areas': [
      {'show': '冠', 'baseballid': 100, 'ballpanid': 101, 'extid': 2},
      {'show': '亚', 'baseballid': 200, 'ballpanid': 101, 'extid': 2},
      {'show': '季', 'baseballid': 300, 'ballpanid': 101, 'extid': 2},
      {'show': '四', 'baseballid': 400, 'ballpanid': 101, 'extid': 2}
    ]
  },
  // 前五直选复式
  58600: {
    'areas': [
      {'show': '冠', 'baseballid': 100, 'ballpanid': 101, 'extid': 2},
      {'show': '亚', 'baseballid': 200, 'ballpanid': 101, 'extid': 2},
      {'show': '季', 'baseballid': 300, 'ballpanid': 101, 'extid': 2},
      {'show': '四', 'baseballid': 400, 'ballpanid': 101, 'extid': 2},
      {'show': '五', 'baseballid': 500, 'ballpanid': 101, 'extid': 2}
    ]
  },
  // 定位胆
  58700: {
    'areas': [
      {'show': '冠', 'baseballid': 100, 'ballpanid': 101, 'extid': 2},
      {'show': '亚', 'baseballid': 200, 'ballpanid': 101, 'extid': 2},
      {'show': '季', 'baseballid': 300, 'ballpanid': 101, 'extid': 2},
      {'show': '四', 'baseballid': 400, 'ballpanid': 101, 'extid': 2},
      {'show': '五', 'baseballid': 500, 'ballpanid': 101, 'extid': 2},
      {'show': '六', 'baseballid': 600, 'ballpanid': 101, 'extid': 2},
      {'show': '七', 'baseballid': 700, 'ballpanid': 101, 'extid': 2},
      {'show': '八', 'baseballid': 800, 'ballpanid': 101, 'extid': 2},
      {'show': '九', 'baseballid': 900, 'ballpanid': 101, 'extid': 2},
      {
        'show': '十',
        'en': 'ten',
        'baseballid': 1000,
        'ballpanid': 101,
        'extid': 2
      }
    ]
  },
  // 冠亚和值单双
  58800: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 104}
    ]
  },
  // 冠亚和值大小
  58801: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 105}
    ]
  },
  // 冠亚和值指定
  58802: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 106, 'extid': 2}
    ]
  },

  // 幸运飞艇B盘
  // 数字盘
  83000: {
    'areas': [
      {'show': '冠军', 'baseballid': 1000, 'ballpanid': 801, 'basecmd': 1000},
      {'show': '亚军', 'baseballid': 1100, 'ballpanid': 801, 'basecmd': 1100},
      {'show': '季军', 'baseballid': 1200, 'ballpanid': 801, 'basecmd': 1200},
      {'show': '第4名', 'baseballid': 1300, 'ballpanid': 801, 'basecmd': 1300},
      {'show': '第5名', 'baseballid': 1400, 'ballpanid': 801, 'basecmd': 1400},
      {'show': '第6名', 'baseballid': 1500, 'ballpanid': 801, 'basecmd': 1500},
      {'show': '第7名', 'baseballid': 1600, 'ballpanid': 801, 'basecmd': 1600},
      {'show': '第8名', 'baseballid': 1700, 'ballpanid': 801, 'basecmd': 1700},
      {'show': '第9名', 'baseballid': 1800, 'ballpanid': 801, 'basecmd': 1800},
      {'show': '第10名', 'baseballid': 1900, 'ballpanid': 801, 'basecmd': 1900}
    ]
  },
  // 两面盘
  83001: {
    'areas': [
      {'show': '冠、亚军和', 'baseballid': 1000, 'ballpanid': 802, 'basecmd': 1000},
      {'show': '冠军', 'baseballid': 1100, 'ballpanid': 803, 'basecmd': 1100},
      {'show': '亚军', 'baseballid': 1200, 'ballpanid': 803, 'basecmd': 1200},
      {'show': '季军', 'baseballid': 1300, 'ballpanid': 803, 'basecmd': 1300},
      {'show': '第4名', 'baseballid': 1400, 'ballpanid': 803, 'basecmd': 1400},
      {'show': '第5名', 'baseballid': 1500, 'ballpanid': 803, 'basecmd': 1500},
      {'show': '第6名', 'baseballid': 1600, 'ballpanid': 804, 'basecmd': 1600},
      {'show': '第7名', 'baseballid': 1700, 'ballpanid': 804, 'basecmd': 1700},
      {'show': '第8名', 'baseballid': 1800, 'ballpanid': 804, 'basecmd': 1800},
      {'show': '第9名', 'baseballid': 1900, 'ballpanid': 804, 'basecmd': 1900},
      {'show': '第10名', 'baseballid': 2000, 'ballpanid': 804, 'basecmd': 2000}
    ]
  },
  // 冠、亚军和
  83002: {
    'areas': [
      {'show': '冠、亚军和', 'baseballid': 1000, 'ballpanid': 805, 'basecmd': 1000},
      {'show': '冠军', 'baseballid': 1100, 'ballpanid': 807, 'basecmd': 1100},
      {'show': '亚军', 'baseballid': 1200, 'ballpanid': 807, 'basecmd': 1200}
    ]
  },
  // 1~5
  83003: {
    'areas': [
      {'show': '第1名', 'baseballid': 1000, 'ballpanid': 806, 'basecmd': 1000},
      {'show': '第2名', 'baseballid': 1100, 'ballpanid': 806, 'basecmd': 1100},
      {'show': '第3名', 'baseballid': 1200, 'ballpanid': 806, 'basecmd': 1200},
      {'show': '第4名', 'baseballid': 1300, 'ballpanid': 806, 'basecmd': 1300},
      {'show': '第5名', 'baseballid': 1400, 'ballpanid': 806, 'basecmd': 1400}
    ]
  },
  // 6~10
  83004: {
    'areas': [
      {'show': '第6名', 'baseballid': 1000, 'ballpanid': 807, 'basecmd': 1000},
      {'show': '第7名', 'baseballid': 1100, 'ballpanid': 807, 'basecmd': 1100},
      {'show': '第8名', 'baseballid': 1200, 'ballpanid': 807, 'basecmd': 1200},
      {'show': '第9名', 'baseballid': 1300, 'ballpanid': 807, 'basecmd': 1300},
      {'show': '第10名', 'baseballid': 1400, 'ballpanid': 807, 'basecmd': 1400}
    ]
  },
  // 冠亚军组合
  83005: {
    'areas': [
      {'show': '冠亚军组合', 'baseballid': 1000, 'ballpanid': 808, 'basecmd': 1000}
    ]
  },
  // 香港彩
  // 特码
  33000: {
    'areas': [
      {
        'show': '',
        'baseballid': 100,
        'ballpanid': 901,
        'extid': [3, 4, 5, 6]
      },
      {'show': '', 'baseballid': 200, 'ballpanid': 902}
    ]
  },
  // 色波
  33001: {
    'areas': [
      {'show': '色波', 'baseballid': 100, 'ballpanid': 903}
    ]
  },
  // 特肖
  33002: {
    'areas': [
      {'show': '特肖', 'baseballid': 100, 'ballpanid': 904}
    ]
  },
  // 正码
  33003: {
    'areas': [
      {
        'show': '正码',
        'baseballid': 100,
        'ballpanid': 901,
        'extid': [3, 4, 5, 6]
      }
    ]
  },
  // 正特一
  33004: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901}
    ]
  },
  // 正特二
  33005: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901}
    ]
  },
  // 正特三
  33006: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901}
    ]
  },
  // 正特四
  33007: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901}
    ]
  },
  // 正特五
  33008: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901}
    ]
  },
  // 正特六
  33009: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901}
    ]
  },

  // 正码1-6
  33010: {
    'areas': [
      {'show': '正码一', 'baseballid': 100, 'ballpanid': 905, 'basecmd': 100},
      {'show': '正码二', 'baseballid': 200, 'ballpanid': 905, 'basecmd': 200},
      {'show': '正码三', 'baseballid': 300, 'ballpanid': 905, 'basecmd': 300},
      {'show': '正码四', 'baseballid': 400, 'ballpanid': 905, 'basecmd': 400},
      {'show': '正码五', 'baseballid': 500, 'ballpanid': 905, 'basecmd': 500},
      {'show': '正码六', 'baseballid': 600, 'ballpanid': 905, 'basecmd': 600}
    ]
  },
  // 连码三中二单选/复式
  33011: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 12}
    ]
  },
  // 连码三中二胆拖
  33012: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 2},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 901, 'maxselect': 47}
    ]
  },
  // 连码三全中单选/复式
  33013: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 12}
    ]
  },
  // 连码三全中胆拖
  33014: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 2},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 901, 'maxselect': 47}
    ]
  },
  // 连码二全中单选/复式
  33015: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 12}
    ]
  },
  // 连码二全中胆拖
  33016: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 1},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 901, 'maxselect': 48}
    ]
  },
  // 连码二全中生肖对碰
  33017: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 2}
    ]
  },
  // 连码二全中尾数对碰
  33018: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 907, 'maxselect': 2}
    ]
  },
  // 连码二全中混合对碰
  33019: {
    'areas': [
      {'show': '生肖对碰', 'baseballid': 100, 'ballpanid': 904},
      {'show': '尾数对碰', 'baseballid': 200, 'ballpanid': 907}
    ]
  },
  // 连码二中特单选/复选
  33020: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 12}
    ]
  },
  // 连码二中特胆拖
  33021: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 1},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 901, 'maxselect': 48}
    ]
  },
  // 连码二中特生肖对碰
  33022: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 2}
    ]
  },
  // 连码二中特尾数对碰
  33023: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 907, 'maxselect': 2}
    ]
  },
  // 连码二中特混合对碰
  33024: {
    'areas': [
      {'show': '生肖对碰', 'baseballid': 100, 'ballpanid': 904},
      {'show': '尾数对碰', 'baseballid': 200, 'ballpanid': 907}
    ]
  },
  // 连码特串单选/复选
  33025: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 12}
    ]
  },
  // 连码特串胆拖
  33026: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 1},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 901, 'maxselect': 48}
    ]
  },
  // 连码特串生肖对碰
  33027: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 2}
    ]
  },
  // 连码特串尾数对碰
  33028: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 907, 'maxselect': 2}
    ]
  },
  // 连码特串混合对碰
  33029: {
    'areas': [
      {'show': '生肖对碰', 'baseballid': 100, 'ballpanid': 904},
      {'show': '尾数对碰', 'baseballid': 200, 'ballpanid': 907}
    ]
  },
  // 一肖
  33030: {
    'areas': [
      {'show': '生肖', 'baseballid': 100, 'ballpanid': 904},
      {'show': '七色波', 'baseballid': 100, 'ballpanid': 906}
    ]
  },
  // 尾数
  33031: {
    'areas': [
      {'show': '尾数', 'baseballid': 100, 'ballpanid': 909}
    ]
  },

  // 合肖一肖中
  33032: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 1}
    ]
  },
  // 合肖一肖不中
  33033: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 1}
    ]
  },
  // 合肖二肖中
  33034: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 2}
    ]
  },
  // 合肖二肖不中
  33035: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 2}
    ]
  },
  // 合肖三肖中
  33036: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 3}
    ]
  },
  // 合肖三肖不中
  33037: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 3}
    ]
  },
  // 合肖四肖中
  33038: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 4}
    ]
  },
  // 合肖四肖不中
  33039: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 4}
    ]
  },
  // 合肖五肖中
  33040: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 5}
    ]
  },
  // 合肖五肖不中
  33041: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 5}
    ]
  },

  // 合肖六肖中
  33042: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 6}
    ]
  },
  // 合肖六肖不中
  33043: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 6}
    ]
  },
  // 合肖七肖中
  33044: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 7}
    ]
  },
  // 合肖七肖不中
  33045: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 7}
    ]
  },
  // 合肖八肖中
  33046: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 8}
    ]
  },
  // 合肖八肖不中
  33047: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 8}
    ]
  },
  // 合肖九肖中
  33048: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 9}
    ]
  },
  // 合肖九肖不中
  33049: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 9}
    ]
  },
  // 合肖十肖中
  33050: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 10}
    ]
  },
  // 合肖十肖不中
  33051: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 10}
    ]
  },
  // 合肖十一肖中
  33052: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 11}
    ]
  },
  // 合肖十一肖不中
  33053: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 11}
    ]
  },

  // 自选不中五不中
  33054: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 5}
    ]
  },
  // 自选不中六不中
  33055: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 6}
    ]
  },
  // 自选不中七不中
  33056: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 7}
    ]
  },
  // 自选不中八不中
  33057: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 8}
    ]
  },
  // 自选不中九不中
  33058: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 9}
    ]
  },
  // 自选不中十不中
  33059: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 10}
    ]
  },
  // 自选不中十一不中
  33060: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 11}
    ]
  },
  // 自选不中十二不中
  33061: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 901, 'maxselect': 12}
    ]
  },

  // 连肖二肖单选/复式
  33062: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904}
    ]
  },
  // 连肖二肖胆拖
  33063: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 1},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 904, 'maxselect': 11}
    ]
  },
  // 连肖三肖单选/复式
  33064: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904}
    ]
  },
  // 连肖三肖胆拖
  33065: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 2},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 904, 'maxselect': 10}
    ]
  },
  // 连肖四肖单选/复式
  33066: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904}
    ]
  },
  // 连肖四肖胆拖
  33067: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 3},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 904, 'maxselect': 9}
    ]
  },
  // 连肖五肖单选/复式
  33068: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 904}
    ]
  },
  // 连肖五肖胆拖
  33069: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 904, 'maxselect': 4},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 904, 'maxselect': 8}
    ]
  },

  // 连尾二尾单选/复式
  33070: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 910}
    ]
  },
  // 连尾二尾胆拖
  33071: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 910, 'maxselect': 1},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 910, 'maxselect': 9}
    ]
  },
  // 连尾三尾单选/复式
  33072: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 910}
    ]
  },
  // 连尾三尾胆拖
  33073: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 910, 'maxselect': 2},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 910, 'maxselect': 8}
    ]
  },
  // 连尾四尾单选/复式
  33074: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 910}
    ]
  },
  // 连尾四尾胆拖
  33075: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 910, 'maxselect': 3},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 910, 'maxselect': 7}
    ]
  },
  // 连尾二尾不中单选/复式
  33076: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 910}
    ]
  },
  // 连尾二尾不中胆拖
  33077: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 910, 'maxselect': 1},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 910, 'maxselect': 9}
    ]
  },
  // 连尾三尾不中单选/复式
  33078: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 910}
    ]
  },
  // 连尾三尾不中胆拖
  33079: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 910, 'maxselect': 2},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 910, 'maxselect': 8}
    ]
  },
  // 连尾四尾不中单选/复式
  33080: {
    'areas': [
      {'show': '', 'baseballid': 100, 'ballpanid': 910}
    ]
  },
  // 连尾四尾不中胆拖
  33081: {
    'areas': [
      {'show': '胆码', 'baseballid': 100, 'ballpanid': 910, 'maxselect': 3},
      {'show': '拖码', 'baseballid': 200, 'ballpanid': 910, 'maxselect': 7}
    ]
  },
  // 龙虎龙虎斗
  33082: {
    'areas': [
      {
        'show': '1 vs 2',
        'webshow': '正码一VS正码二',
        'baseballid': 100,
        'ballpanid': 908
      },
      {
        'show': '1 vs 3',
        'webshow': '正码一VS正码三',
        'baseballid': 200,
        'ballpanid': 908
      },
      {
        'show': '1 vs 4',
        'webshow': '正码一VS正码四',
        'baseballid': 300,
        'ballpanid': 908
      },
      {
        'show': '1 vs 5',
        'webshow': '正码一VS正码五',
        'baseballid': 400,
        'ballpanid': 908
      },
      {
        'show': '1 vs 6',
        'webshow': '正码一VS正码六',
        'baseballid': 500,
        'ballpanid': 908
      },
      {
        'show': '1 vs 特',
        'webshow': '正码一VS特码',
        'baseballid': 600,
        'ballpanid': 908
      },
      {
        'show': '2 vs 3',
        'webshow': '正码二VS正码三',
        'baseballid': 700,
        'ballpanid': 908
      },
      {
        'show': '2 vs 4',
        'webshow': '正码二VS正码四',
        'baseballid': 800,
        'ballpanid': 908
      },
      {
        'show': '2 vs 5',
        'webshow': '正码二VS正码五',
        'baseballid': 900,
        'ballpanid': 908
      },
      {
        'show': '2 vs 6',
        'webshow': '正码二VS正码六',
        'baseballid': 1000,
        'ballpanid': 908
      },
      {
        'show': '2 vs 特',
        'webshow': '正码二VS特码',
        'baseballid': 1100,
        'ballpanid': 908
      },
      {
        'show': '3 vs 4',
        'webshow': '正码三VS正码四',
        'baseballid': 1200,
        'ballpanid': 908
      },
      {
        'show': '3 vs 5',
        'webshow': '正码三VS正码五',
        'baseballid': 1300,
        'ballpanid': 908
      },
      {
        'show': '3 vs 6',
        'webshow': '正码三VS正码六',
        'baseballid': 1400,
        'ballpanid': 908
      },
      {
        'show': '3 vs 特',
        'webshow': '正码三VS特码',
        'baseballid': 1500,
        'ballpanid': 908
      },
      {
        'show': '4 vs 5',
        'webshow': '正码四VS正码五',
        'baseballid': 1600,
        'ballpanid': 908
      },
      {
        'show': '4 vs 6',
        'webshow': '正码四VS正码六',
        'baseballid': 1700,
        'ballpanid': 908
      },
      {
        'show': '4 vs 特',
        'webshow': '正码四VS特码',
        'baseballid': 1800,
        'ballpanid': 908
      },
      {
        'show': '5 vs 6',
        'webshow': '正码五VS正码六',
        'baseballid': 1900,
        'ballpanid': 908
      },
      {
        'show': '5 vs 特',
        'webshow': '正码五VS特码',
        'baseballid': 2000,
        'ballpanid': 908
      },
      {
        'show': '6 vs 特',
        'webshow': '正码六VS特码',
        'baseballid': 2100,
        'ballpanid': 908
      }
    ]
  },
  753000: {
    'areas': [
      {'show': '一字组合', 'baseballid': 0, 'ballpanid': 911}
    ]
  },
  753001: {
    'areas': [
      {'show': '大小单双质合', 'baseballid': 0, 'ballpanid': 912}
    ]
  },
  753002: {
    'areas': [
      {'show': '二字组合', 'baseballid': 0, 'ballpanid': 913}
    ]
  },
  753003: {
    'areas': [
      {'show': '三字组合', 'baseballid': 0, 'ballpanid': 914}
    ]
  },
  753004: {
    'areas': [
      {'show': '一字定位', 'baseballid': 0, 'ballpanid': 915}
    ]
  },
  753005: {
    'areas': [
      {'show': '佰', 'baseballid': 0, 'ballpanid': 916},
      {'show': '拾', 'baseballid': 0, 'ballpanid': 1005},
      {'show': '个', 'baseballid': 0, 'ballpanid': 1006}
    ]
  },
  753006: {
    'areas': [
      {'show': '佰', 'baseballid': 0, 'ballpanid': 916},
      {'show': '拾', 'baseballid': 0, 'ballpanid': 1005},
      {'show': '个', 'baseballid': 0, 'ballpanid': 1006}
    ]
  },
  753007: {
    'areas': [
      {'show': '二字和数', 'baseballid': 0, 'ballpanid': 917}
    ]
  },
  753008: {
    'areas': [
      {'show': '三字和数', 'baseballid': 0, 'ballpanid': 918}
    ]
  },
  753009: {
    'areas': [
      {'show': '组选三', 'baseballid': 0, 'ballpanid': 916}
    ]
  },
  753010: {
    'areas': [
      {'show': '组选六', 'baseballid': 0, 'ballpanid': 916}
    ]
  },
  753011: {
    'areas': [
      {'show': '跨度', 'baseballid': 0, 'ballpanid': 919}
    ]
  },
};
