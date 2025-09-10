import 'dart:convert';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/action_cfg.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'action_cfg.dart';

class ActionCfgConverter implements JsonConverter<ActionCfg?, Object?> {
  const ActionCfgConverter();

  @override
  ActionCfg? fromJson(Object? json) {
    if (json == null) return null;

    // 直接是 Map 的情况
    if (json is Map<String, dynamic>) {
      return ActionCfg.fromJson(json);
    }

    // 如果是字符串，尝试 decode
    if (json is String && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        if (decoded is Map<String, dynamic>) {
          return ActionCfg.fromJson(decoded);
        }
      } catch (_) {
        // 不是有效 JSON，可以直接忽略或抛异常
      }
    }

    throw FormatException('actionCfg 类型不支持: ${json.runtimeType}');
  }

  @override
  Object? toJson(ActionCfg? object) => object?.toJson();
}
