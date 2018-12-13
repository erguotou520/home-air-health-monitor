import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:convert/convert.dart';
// import 'package:crypto/crypto.dart';
import 'config.dart';

Options options = new Options(
  baseUrl: 'https://' + APP_ID.substring(0, 8) + 'api.lncld.net/1.1/classes/',
  contentType: ContentType.json
);
Dio dio = new Dio(options);
dio.interceptor.request.onSend = (Options options) {
  options.headers['X-LC-Id'] = APP_ID;
  options.headers['X-LC-Sign'] = sign();
  return options;
};

//Generate MD5 hash
String generateMd5(String data) {
  // var content = new Utf8Encoder().convert(data);
  // var digest = md5.convert(content);
  // // 这里其实就是 digest.toString()
  // return hex.encode(digest.bytes);
  return '';
}

String sign() {
  String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
  String sign = generateMd5(timestamp + APP_KEY);
  return sign + ',' + timestamp;
}

void getData() async {
  Response resp = await dio.get('daily');
  print(resp.data);
}
