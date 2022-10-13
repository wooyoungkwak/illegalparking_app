import 'dart:async';
import 'dart:convert';
// import 'dart:html';
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/models/result_model.dart';
// import 'package:illegalparking_app/models/storage_model.dart';
// import 'package:illegalparking_app/utils/log_util.dart';
// import 'package:illegalparking_app/utils/time_util.dart';

Map<String, String> headers = {};

// 로그인
Future<LoginInfo> login(String id, String pw) async {
  var data = {"loginId": id, "password": pw};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_LOGIN_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);

    LoginInfo loginInfo;

    //로그인 성공 실패 체크해서 Model 다르게 설정
    // if (resultMap.values.first) {
    loginInfo = LoginInfo.fromJson(resultMap);
    // }

    return loginInfo;
  } else {
    throw Exception('로그인 서버 오류');
  }
}

// 서버 이미지 저장
Future<bool> sendFile(String url, String filePath) async {
  final ReportController c = Get.put(ReportController());
  Log.debug(" uri => ${Uri.parse(url)}");
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  Log.debug(filePath);
  try {
    List<String> temps = filePath.split("/");
    String fileName = temps.last + ".jpg";
    request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
    var response = await request.send();
    final respStr = await response.stream.bytesToString(); //번호판 결과값 반환
    Log.debug("  numberText = ${respStr}");
    c.carNumberwrite(respStr); // 번호판 저장

    // Log.debug("  resonse data length  = ${response.contentLength}");
    // Log.debug("  resonse data length  = ${response.reasonPhrase}");
    // Log.debug("  resonse data length  = ${response.request}");

    if (response.statusCode == 200) {
      Log.debug(response.statusCode.toString());
      return true;
    } else {
      Log.debug(response.statusCode.toString());
      // return false;
      throw Exception('파일 전송 오류 1111 ');
    }
  } catch (e) {
    Log.debug(e.toString());
    // return false;
    throw Exception('파일 전송 오류 22222 ');
  }
}

// 서버 이미지 저장 수정
// Future<bool> sendFile(String url, List<String> filePath) async {
//   try {
//     final ReportController c = Get.put(ReportController());
//     Log.debug(" uri => ${Uri.parse(url)}");
//     var request = new http.MultipartRequest("POST", Uri.parse(url));

//     for (var image in filePath) {
//       Log.debug(image);
//       List<String> temps = image.split("/");
//       String fileName = temps.last + ".jpg";
//       request.files.add(await http.MultipartFile.fromPath('file', image, filename: fileName));
//     }

//     var response = await request.send();
//     final respStr = await response.stream.bytesToString(); //번호판 결과값 반환
//     Log.debug("  stream = ${respStr}");

//     if (filePath.length == 1) {
//       //번호판 사진
//       await c.carNumberwrite(respStr); //서버에서 받은 번호판 text 저장
//     }

//     // Log.debug("  resonse data length  = ${response.contentLength}");
//     // Log.debug("  resonse data length  = ${response.reasonPhrase}");
//     // Log.debug("  resonse data length  = ${response.request}");

//     if (response.statusCode == 200) {
//       Log.debug(response.statusCode.toString());
//       return true;
//     } else {
//       // return false;
//       throw Exception('파일 전송 오류 1111 ');
//     }
//   } catch (e) {
//     Log.debug(e.toString());
//     // return false;
//     throw Exception('파일 전송 오류 22222 ');
//   }
// }
