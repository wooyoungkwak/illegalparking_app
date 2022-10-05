import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:illegalparking_app/utils/log_util.dart';
// import 'package:illegalparking_app/config/env.dart';
// import 'package:illegalparking_app/models/result_model.dart';
// import 'package:illegalparking_app/models/storage_model.dart';
// import 'package:illegalparking_app/utils/log_util.dart';
// import 'package:illegalparking_app/utils/time_util.dart';

Map<String, String> headers = {};

// 로그인
// Future<LoginInfo> login(String id, String pw) async {
//   var data = {"loginId": id, "password": pw};
//   var body = json.encode(data);

//   var response = await http.post(Uri.parse(Env.SERVER_LOGIN_URL), headers: {"Content-Type": "application/json"}, body: body);
//   if (response.statusCode == 200) {
//     String result = utf8.decode(response.bodyBytes);
//     Map<String, dynamic> resultMap = jsonDecode(result);

//     LoginInfo loginInfo;

//     if (resultMap.values.first) {
//       //로그인 성공 실패 체크해서 Model 다르게 설정
//       loginInfo = LoginInfo.fromJson(resultMap);
//     } else {
//       loginInfo = LoginInfo.fromJsonByFail(resultMap);
//     }

//     return loginInfo;
//   } else {
//     throw Exception('로그인 서버 오류');
//   }
// }

// 로그인
Future<bool> sendFile(String url, String filePath) async {
  Log.debug( " uri => ${Uri.parse(url)}");
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  try {
    List<String> temps = filePath.split("/");
    String fileName = temps.last + ".jpg";
    request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
    var response = await request.send();

    Log.debug("  response.statusCode = ${response.statusCode}");
    Log.debug("  resonse data length  = ${response.contentLength}");
    Log.debug("  resonse data length  = ${response.reasonPhrase}");
    Log.debug("  resonse data length  = ${response.request}");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('파일 전송 오류 1111 ');
    }
  } catch (e) {
    Log.debug(e.toString());
    throw Exception('파일 전송 오류 22222 ');
  }
}
