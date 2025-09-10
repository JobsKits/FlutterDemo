import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';

import '../app/modules/user/data/agent_commission_bean.dart';
import '../app/modules/user/data/invite_friends_bean.dart';
import '../kernel/network/service.dart';
import '../utils/login_manager.dart';
import '../utils/tenant_manager.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';

import '../app/data/login_bean.dart';

class AgentCenterApi {
  //收件箱 - 一键已读
  Future<InviteFriendsBean?> inviteFriends() async {
    // 我的分享 - 邀请好友页面
    int cmdId = 311935;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'is_clear': 'true',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      return InviteFriendsBean.fromJson(res.data);
      print('推广链接: ${res.data['link_addr']}');
      print('上级账号: ${res.data['partnerName']}');
      print('直属成员人数: ${res.data['direc']}');
      print('团队成员人数: ${res.data['count']}');
      print('今日新增人数: ${res.data['cust_count']['cust_count']}');
      print(
          '团队新增充值人数: ${res.data['new_charge_cust_count']['new_charge_cust_count']}');
    }
    return null;
  }

  // 获取我的分享 - 佣金
  Future<AgentCommissionBean?> getMyInviteMoney() async {
    int cmdId = 324459;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      return AgentCommissionBean.fromJson(res.data);
      print('历史总佣金: ${res.data['rebate_sum'] / 1000}');
      print('昨日佣金: ${res.data['rebate'] / 1000}');
      print('可领取佣金: ${res.data['receive_rebate'] / 1000}');
      if (res.data['code'] != 1) {
        print('展示立即领取按钮');
      }
    }
    return null;
  }

  /*
   * 代理商信息查询
   * @param @requires payload.partner_id
   * @param payload.key 本次请求的key，默认为default
   * @param payload.options 更多参数 JSON
   * @param payload.callback 回调 function (res, err) {}
   * @param payload.isUserInfoPartner 是否更新userInfo
   */
  static Future<NetworkResponse> reqAgentInfo(
      Map<String, dynamic> param) async {
    const cmdId = 311934;

    List<String> data = ['${TenantManager.instance.tenantBean!.tid}'];

    if (param['partner_id'] != null) {
      data.add('${param['partner_id']}');
    } else {
      data.add('${LoginManager.instance.loginInfo!.custId}');
    }

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
      headerType: 2,
      logError: true,
    );
  }

  /* 马上开户，新开户，新增客户/合作伙伴partner_flag: 0 普通会员  1 代理商
    * @param @requires payload.cust_name
    * @param @requires payload.password
    * @param @requires payload.partner_flag
    * @param @requires payload.rebate_ssc
    * @param @requires payload.rebate_ft
    * @param @requires payload.rebate_sc
    * @param @requires payload.rebate_k3
    * @param @requires payload.rebate_115
    * @param @requires payload.rebate_zr
    * @param @requires payload.rebate_dz
    * @param @requires payload.rebate_ty
    * @param @requires payload.busi_code "", //代理商非空 "01011"
    * @param payload.start_time 起始时间
    * @param payload.end_time 结束时间
    * @param payload.is_clear 是否清空本地数据(不清空则追加)
    * @param payload.key 本次请求的key，默认为default
    * @param payload.options 更多参数 JSON
    * @param payload.callback 回调 function (res, err) {}
    */
  static Future<NetworkResponse> reqAddAgentOrUser(Map<String, dynamic> param,
      {LoginPartner? partner}) async {
    const cmdId = 310127;

    // 1 金字塔模式  2.日结模式
    var agentModel = TenantManager.instance.tenantBean?.tenant?.agentModel;

    LoginPartner? partnerInfo = LoginManager.instance.loginInfo!.partner;

    int randomNumber = randomInteger(1, 200);
    final headURI =
        '/static/heads/head_${strPadLeft(randomNumber.toString(), 2)}.png';

    var partnerData = {
      'peer_quota': param['peer_quota'],
      'lower_quota': param['lower_quota'],
    };

    var custContact = {
      'contact_name': param['contact_name'] ?? '',
      'zalo': param['zalo'] ?? '',
      'facebook': param['facebook'] ?? '',
      'whatsApp': param['whatsApp'] ?? '',
      'mobile_phone': param['mobile_phone'] ?? '', // 手机号码
      'qq': param['qq'] ?? '', // qq
      'email': param['email'] ?? '', // 邮箱
      'gender': 0,
    };

    var data = {
      'regist_type': 4, //代理开户注册
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'head': headURI,
      'partner': partnerData,
      'custContact': custContact,
      'cust_type': param['cust_type'] ?? -1,
      'cust_name': param['cust_name'],
      'partner_flag': param['partner_flag'] ?? 0,
      'chan_code': param['chan_code'] ?? AppConfigs.chanCode,
      'password': param['password'] != null ? getP(param['password']) : '',
      'proxy': TenantManager.instance.tenantBean!.proxy,
      'platform': param['platform'] ?? '',
      'regist_from': NetworkService().baseURL,
    };

    if (param['validate'] != null) {
      data['validate'] = param['validate'];
    }

    if (param['fict_flag'] != null) {
      data['fict_flag'] = param['fict_flag'];
    }

    if (param['app_key'] != null) {
      data['app_key'] = param['app_key'];
    }

    if (param['nickName'] != null) {
      data['nickname'] = param['nickName'];
    }
    if (param['isQp'] != null) {
      data['isQp'] = param['isQp'];
    }

    // 修改部分的处理
    if (partner != null) {
      // agentModel = 2 为日结模式
      if (agentModel == 2) {
        // 使用传入的数据， 老后台里面把 userInfo partner 的值改了
        data['rebate'] = partner.rebate;
        data['rebate_ft'] = partner.rebate_ft;
        data['rebate_sc'] = partner.rebate_sc;
        data['rebate_k3'] = partner.rebate_k3;
        data['rebate_115'] = partner.rebate_115;
        data['rebate_ms'] = partner.rebate_ms;
        data['rebate_by'] = partner.rebate_by;
        data['rebate_zr'] = partner.rebate_zr;
        data['rebate_dz'] = partner.rebate_dz;
        data['rebate_ty'] = partner.rebate_ty;
        data['rebate_qp'] = partner.rebate_qp;
        data['rebate_tcl'] = partner.rebate_tcl;
      } else {
        data['rebate'] = (param['rebate'] ?? 0) * 100;
        data['rebate_ft'] = (param['rebate_ft'] ?? 0) * 100;
        data['rebate_sc'] = (param['rebate_sc'] ?? 0) * 100;
        data['rebate_k3'] = (param['rebate_k3'] ?? 0) * 100;
        data['rebate_115'] = (param['rebate_115'] ?? 0) * 100;
        data['rebate_tcl'] = (param['rebate_tcl'] ?? 0) * 100;
        data['rebate_ms'] = (param['rebate_ms'] ?? 0) * 100;
        data['rebate_by'] = (param['rebate_by'] ?? 0) * 100;
        data['rebate_zr'] = (param['rebate_zr'] ?? 0) * 100;
        data['rebate_dz'] = (param['rebate_dz'] ?? 0) * 100;
        data['rebate_ty'] = (param['rebate_ty'] ?? 0) * 100;
        data['rebate_qp'] = (param['rebate_qp'] ?? 0) * 100;
        // 其他逻辑
        if (param['rebate_min'] != null) {
          data['rebate_min'] = (data['rebate_min'] ?? 0) * 100;
          data['rebate_ft_min'] = (data['rebate_ft_min'] ?? 0) * 100;
          data['rebate_sc_min'] = (data['rebate_sc_min'] ?? 0) * 100;
          data['rebate_k3_min'] = (data['rebate_k3_min'] ?? 0) * 100;
          data['rebate_115_min'] = (data['rebate_115_min'] ?? 0) * 100;
          data['rebate_ms_min'] = (data['rebate_ms_min'] ?? 0) * 100;
          data['rebate_tcl_min'] = (data['rebate_tcl_min'] ?? 0) * 100;
        }
      }
    }

    data['rebate_hb'] = partnerInfo?.rebate_hb != null
        ? int.parse('${partnerInfo?.rebate_hb ?? 0}')
        : 0;

    if (double.parse(data['partner_flag'] ?? 0) > 0 && param['busi_code'] > 0) {
      data['partner'] = {
        'busi_code': param['busi_code'],
        'friend_code': param['friend_code']
      };
    }
    // print('====XXX ${data}');

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      isApiV2: param['isQp'] != null,
      logError: true,
    );
  }

  /// 我的分享 - 邀请好友页面
  static Future<NetworkResponse> reqMyShare() async {
    const cmdId = 311935;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'is_clear': true,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: true,
      logError: true,
    );
  }

  /// 推广分享 - 可领取佣金
  static Future<NetworkResponse> reqBalance() async {
    const cmdId = 622009;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo?.partner?.partner_id ??
          LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: true,
      logError: true,
    );
  }

  /// 获取我的分享 - 佣金
  static Future<NetworkResponse> reqMyShareRebate() async {
    const cmdId = 324459;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'is_clear': true,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 代理 手动领取佣金数量 领取
  static Future<NetworkResponse> reqGetYongJin() async {
    const cmdId = 622010;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.custId,
      'oper_code': LoginManager.instance.loginInfo!.custCode,
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
    print("请求参数：${data}   响应：$res");
    return res;
  }

  /// 代理-推广数据
  static Future<NetworkResponse> reqAgentPromoteData(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 622004;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo?.partner?.partner_id ??
          LoginManager.instance.loginInfo!.custId,
      ...param,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
  }

  /// 财务报表 - 游戏记录 (获取投注记录列表信息)
  static Future<NetworkResponse> reqBetHistoryList(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 600125;//314502

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      ...param,
      'cust_id': param['cust_id'] != ''
          ? param['cust_id']
          : LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 财务报表 - 充值记录
  static Future<NetworkResponse> reqDepositList(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 622005;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
      ...param,
      // 'cust_id': LoginManager.instance.loginInfo!.custId,
    };

    print('reqDepositList======> ${data}');

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 财务报表 - 提现记录
  static Future<NetworkResponse> reqWithdrawList(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 622007;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
      ...param,
      // 'cust_id': param['cust_id'] != ''
      //     ? param['cust_id']
      //     : LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 财务报表 - 我的业绩
  static Future<NetworkResponse> reqProfitList(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 622003;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
      ...param,
      // 'cust_id': param['cust_id'] != ''
      //     ? param['cust_id']
      //     : LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 财务报表 - 会员报表
  static Future<NetworkResponse> reqMemberReport(
    Map<String, dynamic> param,
  ) async {
    // const cmdId = 600129;
    const cmdId = 622002;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
      ...param,
      // 'cust_id': param['cust_id'] != ''
      //     ? param['cust_id']
      //     : LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 财务报表 - 提成记录
  static Future<NetworkResponse> reqBonusRecord(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 622001;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
      ...param,
      // 'cust_id': param['cust_id'] != ''
      //     ? param['cust_id']
      //     : LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 财务报表 - 佣金报表
  static Future<NetworkResponse> reqCommissionReport(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 622006;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo!.partner!.partner_id,
      ...param,
      // 'cust_id': param['cust_id'] != ''
      //     ? param['cust_id']
      //     : LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /* 转账下级 gen_amount:金额  marking_quantity:打码量
  * @param @requires payload.cust_id2
  * @param @requires payload.acct_id2
  * @param @requires payload.cust_name2
  * @param @requires payload.gen_amount
  * @param @requires payload.acct_pwd
  * @param @requires payload.marking_quantity 打码量
  * @param payload.remark
  * @param payload.key 本次请求的key，默认为default
  * @param payload.options 更多参数 JSON
  * @param payload.callback 回调 function (res, err) {}
  */
  static Future<NetworkResponse> reqAddTransfer(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 340600;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'acct_id1': LoginManager.instance.loginInfo!.acctId,
      'cust_id1': LoginManager.instance.loginInfo!.custId,
      'acct_name1': LoginManager.instance.loginInfo!.custName,
      'state': 1,
      'chan_code': AppConfigs.chanCode,
      'oper_id': LoginManager.instance.loginInfo!.custId,
      'oper_code': LoginManager.instance.loginInfo!.custCode,
      ...param,
      'acct_pwd': param['acct_pwd'] != null ? getP(param['acct_pwd']) : '',
      'busi_type': param['busi_type'] ?? 802,
    };
    print('====> ${data} ');

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  static Future<NetworkResponse> reqQuerySubMember(String childId) async {
    const cmdId = 311922;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'child_id': childId,
    };
    print('reqQuerySubMember====> ${data} ');

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 查询当前用户下级
  static Future<NetworkResponse> reqLowMemberList() async {
    const cmdId = 311921;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 查询 会员信息
  static Future<NetworkResponse> reqMemberInfo() async {
    const cmdId = 600121;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 查询 下级成员列表
  static Future<NetworkResponse> reqSubMemberList(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 600122;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      ...param,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 查询 下级成员详情
  static Future<NetworkResponse> reqSubMemberDetailInfo(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 600123;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      ...param,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 查询 下级成员 游戏记录
  static Future<NetworkResponse> reqSubMemberGameRecord(
    Map<String, dynamic> param,
  ) async {
    const cmdId = 600125;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'partner_id': LoginManager.instance.loginInfo?.partner?.partner_id,
      'partner_name': LoginManager.instance.loginInfo?.partner?.partner_name,
      ...param,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 查询 打码量比例
  static Future<NetworkResponse> getQuantityMultiple() async {
    const cmdId = 393015;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }
}
