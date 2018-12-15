// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return Daily(
      (json['formaldehyde'] as num)?.toDouble(),
      (json['pm25'] as num)?.toDouble(),
      (json['temperature'] as num)?.toDouble(),
      (json['humidity'] as num)?.toDouble(),
      DateTime.parse(json['createdAt'])
  );
}

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'formaldehyde': instance.formaldehyde,
      'pm25': instance.pm25,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'createdAt': instance.createdAt.toString()
    };

DailyList _$DailyListFromJson(Map<String, dynamic> json) {
  return DailyList((json['results'] as List)
      .map((e) => Daily.fromJson(e as Map<String, dynamic>))
      .toList());
}

Map<String, dynamic> _$DailyListToJson(DailyList instance) =>
    <String, dynamic>{'results': instance.results};
