import 'dart:io';
import 'package:dio/dio.dart';
import 'config.dart';
import 'dart:convert';
import 'model.dart';
import 'package:crypto/crypto.dart' as crypto;

class _Http {
  static Options options = new Options(
    baseUrl: 'https://' + APP_ID.substring(0, 8) + '.api.lncldapi.com/1.1/classes/',
    contentType: ContentType.json
  );
  Dio instance;
  _Http() {
    instance = new Dio(options);
    instance.interceptor.request.onSend = (Options options) {
      options.headers['X-LC-Id'] = APP_ID;
      options.headers['X-LC-Sign'] = sign();
      return options;
    };
  }

  //Generate MD5 hash
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = crypto.md5.convert(content);
    return digest.toString();
  }

  static String sign() {
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    String sign = generateMd5(timestamp + APP_KEY);
    return sign + ',' + timestamp;
  }

  Future<DailyList> getData([dynamic query]) async {
    try {
      Response resp = await instance.get('Daily', data: query);
      return DailyList.fromJson(resp.data);
    } catch (e) {
      print(e);
      return new DailyList([]);
    }
  }

  Future<HomeData> getTodayData() async {
    List<DataModel> values = DataModel.generateList();
    DateTime now = new DateTime.now();
    DateTime from = new DateTime(now.year, now.month, now.day);
    DateTime to = new DateTime(now.year, now.month, now.day + 1);
    // DateTime from = new DateTime(2018, 12, 12);
    // DateTime to = new DateTime(2018, 12, 13);
    DailyList data = await getData({
      'where': json.encode({
        "createdAt": {
          "\$gte": {
            "__type": "Date",
            "iso": "${from.toIso8601String()}Z"
          },
          "\$lt": {
            "__type": "Date",
            "iso": "${to.toIso8601String()}Z"
          }
        }
      }),
      'order': '-createdAt'
    });
    String latestTime = '';
    if (data.results.length > 0) {
      final latest = data.results[0];
      latestTime = latest.createdAt.toString();
      values[0].value = latest.formaldehyde;
      values[1].value = latest.pm25;
      values[2].value = latest.temperature;
      values[3].value = latest.humidity;
      double formaldehydeSum = 0;
      double pm25Sum = 0;
      double temperatureSum = 0;
      double humiditySum = 0;
      data.results.forEach((_data) {
        formaldehydeSum += _data.formaldehyde;
        pm25Sum += _data.pm25;
        temperatureSum += _data.temperature;
        humiditySum += _data.humidity;
        if (_data.formaldehyde > values[0].max) {
          values[0].max = _data.formaldehyde;
        }
        if (_data.formaldehyde < values[0].min || values[0].min == 0) {
          values[0].min = _data.formaldehyde;
        }

        if (_data.pm25 > values[1].max) {
          values[1].max = _data.pm25;
        }
        if (_data.pm25 < values[1].min || values[1].min == 0) {
          values[1].min = _data.pm25;
        }

        if (_data.temperature > values[2].max) {
          values[2].max = _data.temperature;
        }
        if (_data.temperature < values[2].min || values[2].min == 0) {
          values[2].min = _data.temperature;
        }

        if (_data.humidity > values[3].max) {
          values[3].max = _data.humidity;
        }
        if (_data.humidity < values[3].min || values[3].min == 0) {
          values[3].min = _data.humidity;
        }
      });
      values[0].average = (1000 * formaldehydeSum / data.results.length).roundToDouble() / 1000;
      values[1].average = (1000 * pm25Sum / data.results.length).roundToDouble() / 1000;
      values[2].average = (1000 * temperatureSum / data.results.length).roundToDouble() / 1000;
      values[3].average = (1000 * humiditySum / data.results.length).roundToDouble() / 1000;
    }
    return new HomeData(values, latestTime);
  }
}

final _Http http = _Http();
