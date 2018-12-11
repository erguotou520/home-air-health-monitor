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
