/// 提现方式配置
const List<Map<String, dynamic>> withdrawMethodConfigList = [
  {
    'label': '银行卡',
    'value': 0, // cut
    'payType': 0, // 提现方式类型 pay_org_id
    'add': 'bankcardadd',
    'key': 'yinghangka',
  },
  {
    'label': '支付宝',
    'value': 1,
    'payType': 185,
    'add': 'zfbadd',
    'key': 'zhifubao',
  },
  {
    'label': '虚拟币',
    'value': 2,
    'payType': 187,
    'add': 'virtualadd',
    'key': 'xunihuobi',
  },
  {
    'label': 'UPI',
    'value': 3,
    'payType': 195,
    'add': 'upiadd',
    'key': 'upi',
  },
  {
    'label': 'PicPay',
    'value': 4,
    'payType': 199,
    'add': 'picpayadd',
    'key': 'picpay',
  },
  {
    'label': 'PixPay',
    'value': 5,
    'payType': 203,
    'add': 'pixpayadd',
    'key': 'pix',
  },
  {
    'label': 'GoPay',
    'value': 6,
    'payType': 220,
    'add': 'gopayadd',
    'key': 'gopay',
  },
  {
    'label': 'OKPay',
    'value': 7,
    'payType': 230,
    'add': 'okpayadd',
    'key': 'okpay',
  },
  {
    'label': 'CPay',
    'value': 20,
    'payType': 318,
    'add': 'cpayadd',
    'key': 'cpay',
  },
  {
    'label': 'KdPay',
    'value': 19,
    'payType': 316,
    'add': 'kdpayadd',
    'key': 'kdpay',
  },
  {
    'label': '万币',
    'value': 17,
    'payType': 312,
    'add': 'wbpayadd',
    'key': 'wbpay',
  },
  {
    'label': 'MPay',
    'value': 18,
    'payType': 314,
    'add': 'mpayadd',
    'key': 'mpay',
  },
  {
    'label': 'IPay',
    'value': 23,
    'payType': 324,
    'add': 'ipayadd',
    'key': 'ipay',
  },
  {
    'label': '波币',
    'value': 24,
    'payType': 326,
    'add': 'bocoinadd',
    'key': 'bocoin',
  },
  {
    'label': 'AIPay',
    'value': 25,
    'payType': 328,
    'add': 'aipayadd',
    'key': 'aipay',
  },
  {
    'label': 'GCash',
    'value': 22,
    'payType': 322,
    'add': 'gcashadd',
    'key': 'gcash',
  },
  {
    'label': 'ToPay',
    'value': 8,
    'payType': 240,
    'add': 'topayadd',
    'key': 'topay',
  },
  {
    'label': 'AGPay',
    'value': 11,
    'payType': 250,
    'add': 'agpayadd',
    'key': 'agpay',
  },
  {
    'label': '博币',
    'value': 12,
    'payType': 302,
    'add': 'bobiadd',
    'key': 'bobi',
  },
  {
    'label': '数字人民币',
    'value': 13,
    'payType': 300,
    'add': 'numadd',
    'key': 'num',
  },
];

enum AddressType {
  virtualCurrencyType, //虚拟货币类型
  digitalWalletsType, //数字钱包类型
  aliPayType, //支付宝类型
  bankcardsType, //银行卡类型
  upiType, // UPI
  picPayType, // PicPay
  pixPayType, // PixPay
  goPayType, // GoPay
  oKPayType, // OKPay
  cPayType, // CPay
  kdPayType, // KdPay
  wbPayType, // 万币
  mPayType, // MPay
  iPayType, // IPay
  boCoinType, // 波币
  aIPayType, // AIPay
  gCashType, // GCash
  toPayType, // ToPay
  aGPayType, // AGPay
  bobiType, // 博币
  digitalType, //数字人民币
  huiwangType, //汇旺
  virtualCurrencyUnLineType, //虚拟货币线下
  goubaoType, //购宝钱包
}

const Map<String, AddressType> addressTypeMap = {
  '0': AddressType.bankcardsType, // 银行卡
  '185': AddressType.aliPayType, // 支付宝
  '187': AddressType.virtualCurrencyType, // 虚拟货币
  '195': AddressType.upiType, // UPI
  '199': AddressType.picPayType, // PicPay
  '203': AddressType.pixPayType, // PixPay
  '220': AddressType.goPayType, // GoPay
  '230': AddressType.oKPayType, // OKPay
  '318': AddressType.cPayType, // CPay
  '316': AddressType.kdPayType, // KdPay
  '312': AddressType.wbPayType, // 万币
  '314': AddressType.mPayType, // MPay
  '324': AddressType.iPayType, // IPay
  '326': AddressType.boCoinType, // 波币
  '328': AddressType.aIPayType, // AIPay
  '322': AddressType.gCashType, // GCash
  '240': AddressType.toPayType, // ToPay
  '250': AddressType.aGPayType, // AGPay
  '302': AddressType.bobiType, // 博币
  '300': AddressType.digitalType, // 数字人民币
  '337': AddressType.huiwangType, // 汇旺
  '188': AddressType.virtualCurrencyUnLineType, //虚拟货币线下
  '280': AddressType.goubaoType, //购宝钱包
};

const Map<AddressType, String> addressCutIdMap = {
  AddressType.bankcardsType: '0', // 银行卡
  AddressType.aliPayType: '1', // 支付宝
  AddressType.virtualCurrencyType: '2', // 虚拟货币
  AddressType.upiType: '3', // UPI
  AddressType.picPayType: '4', // PicPay
  AddressType.pixPayType: '5', // PixPay
  AddressType.goPayType: '6', // GoPay
  AddressType.oKPayType: '7', // OKPay
  AddressType.cPayType: '20', // CPay
  AddressType.kdPayType: '19', // KdPay
  AddressType.wbPayType: '17', // 万币
  AddressType.mPayType: '18', // MPay
  AddressType.iPayType: '23', // IPay
  AddressType.boCoinType: '24', // 波币
  AddressType.aIPayType: '25', // AIPay
  AddressType.gCashType: '22', // GCash
  AddressType.toPayType: '8', // ToPay
  AddressType.aGPayType: '11', // AGPay
  AddressType.bobiType: '12', // 博币
  AddressType.digitalType: '13', // 数字人民币
  AddressType.huiwangType: '0', // 汇旺
  AddressType.virtualCurrencyUnLineType: '0', //虚拟货币线下
  AddressType.goubaoType: '0', //购宝钱包 cut = 15 ，没有这个分类，先按0处理
};
