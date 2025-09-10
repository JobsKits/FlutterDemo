import 'package:json_annotation/json_annotation.dart';

part 'vip_level_model.g.dart';

@JsonSerializable()
class VipLevelModel {
  @JsonKey(name: '100')
	int? hundred0;
  @JsonKey(name: '101')
	int? hundred1;
  @JsonKey(name: '102')
	int? hundred2;
  @JsonKey(name: '103')
	int? hundred3;
  @JsonKey(name: '104')
	int? hundred4;
  @JsonKey(name: '106')
	int? hundred6;
  @JsonKey(name: '107')
	int? hundred7;
  @JsonKey(name: '109')
	int? hundred9;
	int? level;

	VipLevelModel({
		this.hundred0, 
		this.hundred1, 
		this.hundred2, 
		this.hundred3, 
		this.hundred4, 
		this.hundred6, 
		this.hundred7, 
		this.hundred9, 
		this.level, 
	});

	@override
	String toString() {
		return 'VipLevelModel(hundred0: $hundred0, hundred1: $hundred1, hundred2: $hundred2, hundred3: $hundred3, hundred4: $hundred4, hundred6: $hundred6, hundred7: $hundred7, hundred9: $hundred9, level: $level)';
	}

	factory VipLevelModel.fromJson(Map<String, dynamic> json) {
		return _$VipLevelModelFromJson(json);
	}

	Map<String, dynamic> toJson() => _$VipLevelModelToJson(this);

	VipLevelModel copyWith({
		int? hundred0,
		int? hundred1,
		int? hundred2,
		int? hundred3,
		int? hundred4,
		int? hundred6,
		int? hundred7,
		int? hundred9,
		int? level,
	}) {
		return VipLevelModel(
			hundred0: hundred0 ?? this.hundred0,
			hundred1: hundred1 ?? this.hundred1,
			hundred2: hundred2 ?? this.hundred2,
			hundred3: hundred3 ?? this.hundred3,
			hundred4: hundred4 ?? this.hundred4,
			hundred6: hundred6 ?? this.hundred6,
			hundred7: hundred7 ?? this.hundred7,
			hundred9: hundred9 ?? this.hundred9,
			level: level ?? this.level,
		);
	}
}
