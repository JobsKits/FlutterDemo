import './plays.115.dart';
import './plays.cqlhc.dart';
import './plays.fc3d.dart';
import './plays.k3.dart';
import './plays.pc00.dart';
import './plays.pk10.dart';
import './plays.pk10jdc.dart';
import './plays.qkl.dart';
import './plays.ssc.dart';
import './plays.sscjdc.dart';
import './plays.ssctxffc.dart';
import './plays.xgc.dart';
import './plays.xnb.dart';
import './plays.xyft.dart';
import './plays.ydc.dart';

const playsStrategy = {
  '115': plays_115, // 11选5
  'MARKSIX': plays_xgc, // 香港彩
  'LHCJDC': plays_xgc, // 香港彩
  'PK10JDC': plays_pk10jdc, // 北京赛车-经典彩
  'XYFTJDC': plays_pk10jdc, // 北京赛车-经典彩
  'SSC_TXFFC': plays_ssctxffc, // 时时彩腾讯分分彩
  'LHC': plays_cqlhc, // 重庆六合彩
  'PC00': plays_pc00, // 北京28
  'SSC': plays_ssc, // 时时彩
  'XYFT': plays_xyft, // 幸运飞艇
  'K3': plays_k3, // 快3
  'FC3D': plays_fc3d, // 福彩3D
  'PK10': plays_pk10, // 北京赛车
  'SSCJDC': plays_sscjdc, // 重庆时时彩-经典彩
  'YDC': plays_ydc, // 印度彩
  'XNB': plays_xnb, // 虚拟币
  'QKL': plays_qkl, // 原创
};
