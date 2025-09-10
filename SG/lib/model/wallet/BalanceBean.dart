class BalanceBean {
  BalanceBean({
    this.uid,
    this.brl,
    this.cny,
    this.inr,
    this.vnd,
    this.thb,
    this.usdt,
    this.btc,
    this.eth,
    this.bnb,
    this.EUR,
    this.JPY,
    this.CAD,
    this.ARS,
    this.CLP,
    this.PEN,
    this.MXN,
    this.LTC,
    this.DOGE,
    this.BCH,
    this.XRP,
    this.EOS,
    this.TRX,
    this.USDC,
    this.APE,
    this.BUSD,
    this.CRO,
    this.DAI,
    this.LINK,
    this.SAND,
    this.SHIB,
    this.UNI,
    this.MATIC,
  });

  BalanceBean.fromJson(dynamic json) {
    uid = json['uid'];
    brl = json['BRL'];
    cny = json['CNY'];
    inr = json['INR'];
    vnd = json['VND'];
    thb = json['THB'];
    usdt = json['USDT'];
    btc = json['BTC'];
    eth = json['ETH'];
    bnb = json['BNB'];
    EUR = json["EUR"];
    JPY = json["JPY"];
    CAD = json["CAD"];
    ARS = json["ARS"];
    CLP = json["CLP"];
    PEN = json["PEN"];
    MXN = json["MXN"];
    LTC = json["LTC"];
    DOGE = json["DOGE"];
    BCH = json["BCH"];
    XRP = json["XRP"];
    EOS = json["EOS"];
    TRX = json["TRX"];
    USDC = json["USDC"];
    APE = json["APE"];
    BUSD = json["BUSD"];
    CRO = json["CRO"];
    DAI = json["DAI"];
    LINK = json["LINK"];
    SAND = json["SAND"];
    SHIB = json["SHIB"];
    UNI = json["UNI"];
    MATIC = json["MATIC"];
  }

  String? uid;
  String? brl;
  String? cny;
  String? inr;
  String? vnd;
  String? thb;
  String? usdt;
  String? btc;
  String? eth;
  String? bnb;
  String? EUR;
  String? JPY;
  String? CAD;
  String? ARS;
  String? CLP;
  String? PEN;
  String? MXN;
  String? LTC;
  String? DOGE;
  String? BCH;
  String? XRP;
  String? EOS;
  String? TRX;
  String? USDC;
  String? APE;
  String? BUSD;
  String? CRO;
  String? DAI;
  String? LINK;
  String? SAND;
  String? SHIB;
  String? UNI;
  String? MATIC;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['BRL'] = brl;
    map['CNY'] = cny;
    map['INR'] = inr;
    map['VND'] = vnd;
    map['THB'] = thb;
    map['USDT'] = usdt;
    map['BTC'] = btc;
    map['ETH'] = eth;
    map['BNB'] = bnb;
    map["EUR"] = EUR;
    map["JPY"] = JPY;
    map["CAD"] = CAD;
    map["ARS"] = ARS;
    map["CLP"] = CLP;
    map["PEN"] = PEN;
    map["MXN"] = MXN;
    map["LTC"] = LTC;
    map["DOGE"] = DOGE;
    map["BCH"] = BCH;
    map["XRP"] = XRP;
    map["EOS"] = EOS;
    map["TRX"] = TRX;
    map["USDC"] = USDC;
    map["APE"] = APE;
    map["BUSD"] = BUSD;
    map["CRO"] = CRO;
    map["DAI"] = DAI;
    map["LINK"] = LINK;
    map["SAND"] = SAND;
    map["SHIB"] = SHIB;
    map["UNI"] = UNI;
    map["MATIC"] = MATIC;
    return map;
  }
}
