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
}

final _Http http = _Http();
