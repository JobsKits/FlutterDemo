// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

@RestApi(
    baseUrl:
        'https://api.telegram.org/bot7221603954:AAHPGYNb331KmYLcNZNruhhbNetUrBi_oqo/')
abstract class LogClient {
  factory LogClient(Dio dio, {String baseUrl}) = _LogClient;

  @GET('sendMessage?chat_id=-1002396611383&text={text}')
  Future<LogData> getLog(@Path('text') String text);
}

@JsonSerializable()
class LogData {
  const LogData({this.ok, this.result});

  factory LogData.fromJson(Map<String, dynamic> json) =>
      _$LogDataFromJson(json);

  final bool? ok;
  final LogResultData? result;

  Map<String, dynamic> toJson() => _$LogDataToJson(this);

  @override
  String toString() {
    return 'Log: {ok: $ok, result: $result}';
  }
}

class _LogClient implements LogClient {
  _LogClient(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  }) {
    baseUrl ??=
        'https://api.telegram.org/bot7221603954:AAHPGYNb331KmYLcNZNruhhbNetUrBi_oqo/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<LogData> getLog(String text) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<LogData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'sendMessage?chat_id=-1002396611383&text=${text}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LogData _value;
    try {
      _value = LogData.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

@JsonSerializable()
class LogResultData {
  const LogResultData({this.message_id, this.date, this.text});

  factory LogResultData.fromJson(Map<String, dynamic> json) =>
      _$LogResultDataFromJson(json);

  final int? message_id;
  final int? date;
  final String? text;

  Map<String, dynamic> toJson() => _$LogResultDataToJson(this);

  @override
  String toString() {
    return 'LogResult: {message_id: $message_id, date: $date, text: $text}';
  }
}

LogData _$LogDataFromJson(Map<String, dynamic> json) => LogData(
      ok: json['ok'] as bool?,
      result: json['result'] == null
          ? null
          : LogResultData.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LogDataToJson(LogData instance) => <String, dynamic>{
      'ok': instance.ok,
      'result': instance.result,
    };

LogResultData _$LogResultDataFromJson(Map<String, dynamic> json) =>
    LogResultData(
      message_id: (json['message_id'] as num?)?.toInt(),
      date: (json['date'] as num?)?.toInt(),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$LogResultDataToJson(LogResultData instance) =>
    <String, dynamic>{
      'message_id': instance.message_id,
      'date': instance.date,
      'text': instance.text,
    };
