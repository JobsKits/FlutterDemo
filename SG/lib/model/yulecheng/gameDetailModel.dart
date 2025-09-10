/// id : "63785015282603"
/// platform_id : "26595015200309"
/// name : "闪电牛牛"
/// zh_name : "闪电牛牛"
/// en_name : "Beef Lightning"
/// pt_name : "Beef Lightning"
/// th_name : "ฟาร์มวัวไฟแรงสูง"
/// vn_name : "Tia Sét Thịt Bò"
/// client_type : "[{\"id\": \"24\"}, {\"id\": \"25\"}, {\"id\": \"26\"}, {\"id\": \"27\"}]"
/// game_type : 3
/// game_id : "beeflightningv10"
/// img : "/images/EVO/slot/%lang%/beeflightningv10.png"
/// online : 1
/// is_hot : 1
/// sorting : 0
/// created_at : 0
/// is_new : 1
/// tag_id : ""
/// currency : "[{\"id\": \"BRL\"}, {\"id\": \"CNY\"}, {\"id\": \"INR\"}, {\"id\": \"VND\"}, {\"id\": \"THB\"}, {\"id\": \"USDT\"}]"
/// lang : ""
/// is_fav : 2
/// rtp : "96.44"
/// rate : "0.00"

class GameDetailModel {
  GameDetailModel({
      String? id, 
      String? platformId, 
      String? name, 
      String? zhName, 
      String? enName, 
      String? ptName, 
      String? thName, 
      String? vnName, 
      String? clientType, 
      num? gameType, 
      String? gameId, 
      String? img, 
      num? online, 
      num? isHot, 
      num? sorting, 
      num? createdAt, 
      num? isNew, 
      String? tagId, 
      String? currency, 
      String? lang, 
      num? isFav, 
      String? rtp, 
      String? rate,}){
    _id = id;
    _platformId = platformId;
    _name = name;
    _zhName = zhName;
    _enName = enName;
    _ptName = ptName;
    _thName = thName;
    _vnName = vnName;
    _clientType = clientType;
    _gameType = gameType;
    _gameId = gameId;
    _img = img;
    _online = online;
    _isHot = isHot;
    _sorting = sorting;
    _createdAt = createdAt;
    _isNew = isNew;
    _tagId = tagId;
    _currency = currency;
    _lang = lang;
    _isFav = isFav;
    _rtp = rtp;
    _rate = rate;
}

  GameDetailModel.fromJson(dynamic json) {
    _id = json['id'];
    _platformId = json['platform_id'];
    _name = json['name'];
    _zhName = json['zh_name'];
    _enName = json['en_name'];
    _ptName = json['pt_name'];
    _thName = json['th_name'];
    _vnName = json['vn_name'];
    _clientType = json['client_type'];
    _gameType = json['game_type'];
    _gameId = json['game_id'];
    _img = json['img'];
    _online = json['online'];
    _isHot = json['is_hot'];
    _sorting = json['sorting'];
    _createdAt = json['created_at'];
    _isNew = json['is_new'];
    _tagId = json['tag_id'];
    _currency = json['currency'];
    _lang = json['lang'];
    _isFav = json['is_fav'];
    _rtp = json['rtp'];
    _rate = json['rate'];
  }
  String? _id;
  String? _platformId;
  String? _name;
  String? _zhName;
  String? _enName;
  String? _ptName;
  String? _thName;
  String? _vnName;
  String? _clientType;
  num? _gameType;
  String? _gameId;
  String? _img;
  num? _online;
  num? _isHot;
  num? _sorting;
  num? _createdAt;
  num? _isNew;
  String? _tagId;
  String? _currency;
  String? _lang;
  num? _isFav;
  String? _rtp;
  String? _rate;
GameDetailModel copyWith({  String? id,
  String? platformId,
  String? name,
  String? zhName,
  String? enName,
  String? ptName,
  String? thName,
  String? vnName,
  String? clientType,
  num? gameType,
  String? gameId,
  String? img,
  num? online,
  num? isHot,
  num? sorting,
  num? createdAt,
  num? isNew,
  String? tagId,
  String? currency,
  String? lang,
  num? isFav,
  String? rtp,
  String? rate,
}) => GameDetailModel(  id: id ?? _id,
  platformId: platformId ?? _platformId,
  name: name ?? _name,
  zhName: zhName ?? _zhName,
  enName: enName ?? _enName,
  ptName: ptName ?? _ptName,
  thName: thName ?? _thName,
  vnName: vnName ?? _vnName,
  clientType: clientType ?? _clientType,
  gameType: gameType ?? _gameType,
  gameId: gameId ?? _gameId,
  img: img ?? _img,
  online: online ?? _online,
  isHot: isHot ?? _isHot,
  sorting: sorting ?? _sorting,
  createdAt: createdAt ?? _createdAt,
  isNew: isNew ?? _isNew,
  tagId: tagId ?? _tagId,
  currency: currency ?? _currency,
  lang: lang ?? _lang,
  isFav: isFav ?? _isFav,
  rtp: rtp ?? _rtp,
  rate: rate ?? _rate,
);
  String? get id => _id;
  String? get platformId => _platformId;
  String? get name => _name;
  String? get zhName => _zhName;
  String? get enName => _enName;
  String? get ptName => _ptName;
  String? get thName => _thName;
  String? get vnName => _vnName;
  String? get clientType => _clientType;
  num? get gameType => _gameType;
  String? get gameId => _gameId;
  String? get img => _img;
  num? get online => _online;
  num? get isHot => _isHot;
  num? get sorting => _sorting;
  num? get createdAt => _createdAt;
  num? get isNew => _isNew;
  String? get tagId => _tagId;
  String? get currency => _currency;
  String? get lang => _lang;
  num? get isFav => _isFav;
  String? get rtp => _rtp;
  String? get rate => _rate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['platform_id'] = _platformId;
    map['name'] = _name;
    map['zh_name'] = _zhName;
    map['en_name'] = _enName;
    map['pt_name'] = _ptName;
    map['th_name'] = _thName;
    map['vn_name'] = _vnName;
    map['client_type'] = _clientType;
    map['game_type'] = _gameType;
    map['game_id'] = _gameId;
    map['img'] = _img;
    map['online'] = _online;
    map['is_hot'] = _isHot;
    map['sorting'] = _sorting;
    map['created_at'] = _createdAt;
    map['is_new'] = _isNew;
    map['tag_id'] = _tagId;
    map['currency'] = _currency;
    map['lang'] = _lang;
    map['is_fav'] = _isFav;
    map['rtp'] = _rtp;
    map['rate'] = _rate;
    return map;
  }

}