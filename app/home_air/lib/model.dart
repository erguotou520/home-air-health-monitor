import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Daily {
  double formaldehyde;
  double pm25;
  double temperature;
  double humidity;

  Daily(this.formaldehyde, this.pm25, this.temperature, this.humidity);

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}

class DataModel {
  String enName;
  String zhName;
  String unit;
  double value;
  double min;
  double average;
  double max;

  DataModel(String enName, String zhName, String unit, double value, double min, double average, double max) {
    this.enName = enName;
    this.zhName = zhName;
    this.unit = unit;
    this.value = value;
    this.min = min;
    this.average = average;
    this.max = max;
  }
}
