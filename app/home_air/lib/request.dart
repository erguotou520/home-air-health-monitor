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

  Future<DailyList> getData([Map query]) async {
    try {
      Response resp = await instance.get('Daily', data: query);
      return DailyList.fromJson(resp.data);
    } on DioError catch (e) {
      print(e);
      return new DailyList([]);
    }
  }

  Future<List<DataModel>> getTodayData() async {
    List<DataModel> ret = DataModel.generateList();
    DateTime now = new DateTime.now();
    DateTime from = new DateTime(now.year, now.month, now.day);
    DateTime to = new DateTime(now.year, now.month, now.day + 1);
    try {
      DailyList data = await getData({
        'where': json.encode({
          '\$gte': {
            '__type': 'Date',
            'iso': from.toIso8601String()
          },
          '\$lt': {
            '__type': 'Date',
            'iso': to.toIso8601String()
          }
        }),
        'order': '-createdAt'
      });
      final latest = data.results[0];
      ret[0].value = latest.formaldehyde;
      ret[1].value = latest.pm25;
      ret[2].value = latest.temperature;
      ret[3].value = latest.humidity;
      double formaldehydeSum = 0;
      double pm25Sum = 0;
      double temperatureSum = 0;
      double humiditySum = 0;
      data.results.forEach((_data) {
        formaldehydeSum += _data.formaldehyde;
        pm25Sum += _data.pm25;
        temperatureSum += _data.temperature;
        humiditySum += _data.humidity;
        if (_data.formaldehyde > ret[0].max) {
          ret[0].max = _data.formaldehyde;
        }
        if (_data.formaldehyde < ret[0].min || ret[0].min == 0) {
          ret[0].min = _data.formaldehyde;
        }

        if (_data.pm25 > ret[1].max) {
          ret[1].max = _data.pm25;
        }
        if (_data.pm25 < ret[1].min || ret[1].min == 0) {
          ret[1].min = _data.pm25;
        }

        if (_data.temperature > ret[2].max) {
          ret[2].max = _data.temperature;
        }
        if (_data.temperature < ret[2].min || ret[2].min == 0) {
          ret[2].min = _data.temperature;
        }

        if (_data.humidity > ret[3].max) {
          ret[3].max = _data.humidity;
        }
        if (_data.humidity < ret[3].min || ret[3].min == 0) {
          ret[3].min = _data.humidity;
        }
      });
      ret[0].average = (1000 * formaldehydeSum / data.results.length).roundToDouble();
      ret[1].average = (1000 * pm25Sum / data.results.length).roundToDouble();
      ret[2].average = (1000 * temperatureSum / data.results.length).roundToDouble();
      ret[3].average = (1000 * humiditySum / data.results.length).roundToDouble();
    } catch (e) {
    }
    return ret;
  }
}

final _Http http = _Http();
