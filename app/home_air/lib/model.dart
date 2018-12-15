import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Daily {
  double formaldehyde;
  double pm25;
  double temperature;
  double humidity;
  DateTime createdAt;

  Daily(this.formaldehyde, this.pm25, this.temperature, this.humidity, this.createdAt);

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);

  @override
  String toString() {
    return "formaldehyde=${this.formaldehyde} pm25=${this.pm25} temperature=${this.temperature} humidity=${this.humidity}";
  }
}

@JsonSerializable()
class DailyList {
  @JsonKey(nullable: false)
  List<Daily> results;

  DailyList(this.results);

  factory DailyList.fromJson(Map<String, dynamic> json) => _$DailyListFromJson(json);

  Map<String, dynamic> toJson() => _$DailyListToJson(this);
}

class DataModel {
  String enName;
  String zhName;
  String unit;
  double value;
  double min;
  double average;
  double max;

  DataModel(this.enName, this.zhName, this.unit, this.value, this.min, this.average, this.max);

  static List<DataModel> generateList() {
    return <DataModel>[
      new DataModel('formaldehyde', '甲醛', 'ppm', 0, 0, 0, 0),
      new DataModel('pm25', 'PM2.5', 'ug/m3',  0, 0, 0, 0),
      new DataModel('temperature', '温度', '度',  0, 0, 0, 0),
      new DataModel('humidity', '湿度', '%',  0, 0, 0, 0),
    ];
  }
}

class HomeData {
  List<DataModel> values;
  String latest;
  HomeData(this.values, this.latest);
}
