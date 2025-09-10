// 子玩法信息
const Map<String, Map<String, dynamic>> subPlay = {
  // 时时彩
  'SSC': {
    'subs': [
      {
        'groupName': '定位胆',
        'playids': [0]
      },
      {
        'groupName': '二星',
        'playids': [1, 2, 3, 74, 4, 5, 6, 75, 7, 8, 9, 76, 10, 11, 12, 77]
      },
      {
        'groupName': '前三',
        'playids': [13, 14, 15, 78, 16, 17, 18, 19, 20, 21, 22]
      },
      {
        'groupName': '中三',
        'playids': [23, 24, 25, 79, 26, 27, 28, 29, 30, 31, 32]
      },
      {
        'groupName': '后三',
        'playids': [33, 34, 35, 80, 36, 37, 38, 39, 40, 41, 42]
      },
      {
        'groupName': '四星',
        'playids': [63, 62, 61, 60, 43, 81]
      },
      {
        'groupName': '五星',
        'playids': [69, 68, 67, 66, 65, 64, 44, 82]
      },
      {
        'groupName': '大小单双',
        'playids': [45, 46, 47, 48]
      },
      {
        'groupName': '趣味',
        'playids': [70, 71, 72, 73]
      },
      {
        'groupName': '不定位',
        'playids': [49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
      },
      {
        'groupName': '任选二',
        'playids': [83, 84, 85, 86, 87, 88]
      },
      {
        'groupName': '任选三',
        'playids': [89, 90, 91, 92, 93, 94, 95, 96]
      },
      {
        'groupName': '任选四',
        'playids': [97, 98, 99, 100, 101, 102]
      }
    ]
  },

  'SSC_TXFFC': {
    'subs': [
      {
        'groupName': '定位胆',
        'playids': [0]
      },
      {
        'groupName': '二星',
        'playids': [1, 2, 3, 74, 4, 5, 6, 75, 7, 8, 9, 76, 10, 11, 12, 77]
      },
      {
        'groupName': '前三',
        'playids': [13, 14, 15, 78, 16, 17, 18, 19, 20, 21, 22]
      },
      {
        'groupName': '中三',
        'playids': [23, 24, 25, 79, 26, 27, 28, 29, 30, 31, 32]
      },
      {
        'groupName': '后三',
        'playids': [33, 34, 35, 80, 36, 37, 38, 39, 40, 41, 42]
      },
      // { 'groupName': '四星', 'playids': [63, 62, 61, 60, 43, 81] },
      // { 'groupName': '五星', 'playids': [69, 68, 67, 66, 65, 64, 44, 82] },
      {
        'groupName': '大小单双',
        'playids': [45, 46, 47, 48]
      },
      {
        'groupName': '趣味',
        'playids': [70, 71, 72, 73]
      },
      {
        'groupName': '不定位',
        'playids': [49, 50, 51, 52 /*, 53, 54, 55, 56, 57, 58, 59 */]
      },
      {
        'groupName': '任选二',
        'playids': [83, 84, 85, 86, 87, 88]
      },
      {
        'groupName': '任选三',
        'playids': [89, 90, 91, 92, 93, 94, 95, 96]
      },
      {
        'groupName': '任选四',
        'playids': [97, 98, 99, 100, 101, 102]
      }
    ]
  },

  // 广东11选5
  '115': {
    'subs': [
      {
        'groupName': '三码',
        'playids': [0, 1, 2, 3, 4, 5, 6, 7, 8]
      },
      {
        'groupName': '二码',
        'playids': [9, 10, 11, 12, 13, 14]
      },
      {
        'groupName': '不定位',
        'playids': [15, 16, 17]
      },
      {
        'groupName': '定位胆',
        'playids': [18]
      },
      {
        'groupName': '任选复式',
        'playids': [19, 20, 21, 22, 23, 24, 25, 26]
      },
      {
        'groupName': '任选胆拖',
        'playids': [27, 28, 29, 30, 31, 32, 33]
      }
    ]
  },

  'PK10': {
    'subs': [
      {
        'groupName': '冠亚和值',
        'playids': [800, 801, 802]
      },
      {
        'groupName': '其它玩法',
        'playids': [0, 100, 200, 300, 400, /* 34500, 34600, 34601, */ 700]
      }
    ]
  },

  'FC3D': {
    'subs': [
      {
        'groupName': '一字组合',
        'playids': [0]
      },
      {
        'groupName': '大小单双质合',
        'playids': [1]
      },
      {
        'groupName': '二字组合',
        'playids': [2]
      },
      {
        'groupName': '三字组合',
        'playids': [3]
      },
      {
        'groupName': '一字定位',
        'playids': [4]
      },
      {
        'groupName': '二字定位',
        'playids': [5]
      },
      {
        'groupName': '三字定位',
        'playids': [6]
      },
      {
        'groupName': '二字和数',
        'playids': [7]
      },
      {
        'groupName': '三字和数',
        'playids': [8]
      },
      {
        'groupName': '组选三',
        'playids': [9]
      },
      {
        'groupName': '组选六',
        'playids': [10]
      },
      {
        'groupName': '跨度',
        'playids': [11]
      }
    ]
  },

  'K3': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 100, 200, 300, 400, 500, 600, 700]
      }
    ]
  },
  // k3信用
  'K3XY': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [701, 702, 703, 704, 705]
      }
    ]
  },
  // 虚拟币
  'XNB': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [100, 200, 300, 400, 500]
      }
    ]
  },
  // 原创
  'QKL': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [100]
      }
    ]
  },

  'PC00': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 1, 2, 3, 4]
      }
    ]
  },

  // CQLHC
  'LHC': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 1, 2, 3]
      }
    ]
  },
  // 重庆时时彩-经典
  'SSCJDC': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 1, 2, 3, 4, 5, 6, 7]
      }
    ]
  },
  // 时时彩-信用
  'SSCXY': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [103, 104, 105, 106, 107, 108, 109, 110]
      }
    ]
  },

  // 北京赛车B盘-经典
  'PK10JDC': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 1, 2, 3, 4, 5]
      }
    ]
  },
  // 幸运飞艇B盘-经典
  'XYFTJDC': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 1, 2, 3, 4, 5]
      }
    ]
  },
  'XYFTJDCXY': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [0, 1, 2, 3, 4, 5]
      }
    ]
  },
  'XYFT': {
    'subs': [
      {
        'groupName': '冠亚和值',
        'playids': [800, 801, 802]
      },
      {
        'groupName': '其它玩法',
        'playids': [0, 100, 200, 500, 600, 400, 700]
      }
    ]
  },
  // 幸运飞艇-信用
  'XYFTXY': {
    'subs': [
      {
        'groupName': 'default',
        'playids': [803, 804, 805, 806, 807, 808]
      }
    ]
  },
  // 香港彩
  'MARKSIX': {
    'subs': [
      {
        'groupName': '特码',
        'playids': [0]
      },
      {
        'groupName': '两面',
        'playids': [83],
        'prototype': [0]
      },
      {
        'groupName': '色波',
        'playids': [1]
      },
      {
        'groupName': '特肖',
        'playids': [2]
      },
      {
        'groupName': '正码',
        'playids': [3]
      },
      {
        'groupName': '正特',
        'playids': [4, 5, 6, 7, 8, 9]
      },
      {
        'groupName': '正码1-6',
        'playids': [10]
      },
      {
        'groupName': '连码',
        'playids': [
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29
        ]
      },
      {
        'groupName': '一肖',
        'playids': [30]
      },
      {
        'groupName': '尾数',
        'playids': [31]
      },
      {
        'groupName': '合肖',
        'playids': [
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53
        ]
      },
      {
        'groupName': '自选不中',
        'playids': [54, 55, 56, 57, 58, 59, 60, 61]
      },
      {
        'groupName': '连肖',
        'playids': [62, 63, 64, 65, 66, 67, 68, 69]
      },
      {
        'groupName': '连尾',
        'playids': [70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81]
      },
      {
        'groupName': '龙虎斗',
        'playids': [82]
      }
    ],
    'special': true
  },
  // 香港彩
  'LHCJDC': {
    'subs': [
      {
        'groupName': '特码',
        'playids': [0]
      },
      {
        'groupName': '两面',
        'playids': [83],
        'prototype': [0]
      },
      {
        'groupName': '色波',
        'playids': [1]
      },
      {
        'groupName': '特肖',
        'playids': [2]
      },
      {
        'groupName': '正码',
        'playids': [3]
      },
      {
        'groupName': '正特',
        'playids': [4, 5, 6, 7, 8, 9]
      },
      {
        'groupName': '正码1-6',
        'playids': [10]
      },
      {
        'groupName': '连码',
        'playids': [
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29
        ]
      },
      {
        'groupName': '一肖',
        'playids': [30]
      },
      {
        'groupName': '尾数',
        'playids': [31]
      },
      {
        'groupName': '合肖',
        'playids': [
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53
        ]
      },
      {
        'groupName': '自选不中',
        'playids': [54, 55, 56, 57, 58, 59, 60, 61]
      },
      {
        'groupName': '连肖',
        'playids': [62, 63, 64, 65, 66, 67, 68, 69]
      },
      {
        'groupName': '连尾',
        'playids': [70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81]
      },
      {
        'groupName': '龙虎斗',
        'playids': [82]
      }
    ],
    'special': true
  },
  'YDC': {
    'subs': [
      {
        'groupName': '选颜色',
        'playids': [110, 120, 130]
      },
      {
        'groupName': '选号码',
        'playids': [100]
      }
    ]
  },
};
