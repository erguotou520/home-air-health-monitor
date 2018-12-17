// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirHealth _$AirHealthFromJson(Map<String, dynamic> json) {
  return AirHealth(
      (json['formaldehyde'] as num)?.toDouble(),
      (json['formaldehyde_min'] as num)?.toDouble(),
      (json['formaldehyde_avg'] as num)?.toDouble(),
      (json['formaldehyde_max'] as num)?.toDouble(),
      (json['pm25'] as num)?.toDouble(),
      (json['pm25_min'] as num)?.toDouble(),
      (json['pm25_avg'] as num)?.toDouble(),
      (json['pm25_max'] as num)?.toDouble(),
      (json['temperature'] as num)?.toDouble(),
      (json['temperature_min'] as num)?.toDouble(),
      (json['temperature_avg'] as num)?.toDouble(),
      (json['temperature_max'] as num)?.toDouble(),
      (json['humidity'] as num)?.toDouble(),
      (json['humidity_min'] as num)?.toDouble(),
      (json['humidity_avg'] as num)?.toDouble(),
      (json['humidity_max'] as num)?.toDouble(),
      json['latest_time'] == null
          ? null
          : DateTime.parse(json['latest_time'] as String));
}

Map<String, dynamic> _$AirHealthToJson(AirHealth instance) => <String, dynamic>{
      'formaldehyde': instance.formaldehyde,
      'formaldehyde_min': instance.formaldehyde_min,
      'formaldehyde_avg': instance.formaldehyde_avg,
      'formaldehyde_max': instance.formaldehyde_max,
      'pm25': instance.pm25,
      'pm25_min': instance.pm25_min,
      'pm25_avg': instance.pm25_avg,
      'pm25_max': instance.pm25_max,
      'temperature': instance.temperature,
      'temperature_min': instance.temperature_min,
      'temperature_avg': instance.temperature_avg,
      'temperature_max': instance.temperature_max,
      'humidity': instance.humidity,
      'humidity_min': instance.humidity_min,
      'humidity_avg': instance.humidity_avg,
      'humidity_max': instance.humidity_max,
      'latest_time': instance.latest_time?.toIso8601String()
    };
