import 'dart:io';
import 'package:dio/dio.dart';
import 'config.dart';
import 'dart:convert';
import 'model.dart';
import 'package:crypto/crypto.dart' as crypto;

final API_URL = 'https://${APP_ID.substring(0, 8)}.api.lncldapi.com/1.1/classes/';
final engineUrl = 'https://${APP_ID.substring(0, 8)}.engine.lncldapi.com/1.1/functions/';
class _Http {
  static Options options = new Options(
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

  Future<AirHealth> getTodayData() async {
    try {
      Response resp = await instance.get('Daily',
        options: new Options( baseUrl: engineUrl )
      );
      return AirHealth.fromJson(resp.data);
    } catch (e) {
      print(e);
      return new AirHealth.fromEmpty();
    }
  }
}

final _Http http = _Http();
