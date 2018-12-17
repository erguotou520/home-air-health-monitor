import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class AirHealth {
  double formaldehyde;
  double formaldehyde_min;
  double formaldehyde_avg;
  double formaldehyde_max;
  double pm25;
  double pm25_min;
  double pm25_avg;
  double pm25_max;
  double temperature;
  double temperature_min;
  double temperature_avg;
  double temperature_max;
  double humidity;
  double humidity_min;
  double humidity_avg;
  double humidity_max;
  DateTime latest_time;

  AirHealth(
    this.formaldehyde, this.formaldehyde_min, this.formaldehyde_avg, this.formaldehyde_max,
    this.pm25, this.pm25_min, this.pm25_avg, this.pm25_max,
    this.temperature, this.temperature_min, this.temperature_avg, this.temperature_max,
    this.humidity, this.humidity_min, this.humidity_avg, this.humidity_max,
    this.latest_time
  );

  factory AirHealth.fromEmpty() {
    return new AirHealth(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }

  factory AirHealth.fromJson(Map<String, dynamic> json) => _$AirHealthFromJson(json);

  Map<String, dynamic> toJson() => _$AirHealthToJson(this);
}
