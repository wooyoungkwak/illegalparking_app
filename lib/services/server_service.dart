import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
// import 'dart:html';
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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

    //로그인 성공 실패 체크해서 Model 다르게 설정
    return LoginInfo.fromJson(resultMap);
  } else {
    throw Exception('로그인 서버 오류');
  }
}

Future<ReportInfo> sendReport(String addr, String carNum, String time, String fileName, double latitude, double longitude) async {
  var data = {
    "addr": addr, // 주소
    "carNum": carNum, // 차량번호
    "regDt": time, // 시간
    "fileName" : fileName, // 
    "latitude": latitude, // 위도
    "longitude": longitude // 경도
  };

  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_REPORT_UPLOAD_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return ReportInfo.fromJson(resultMap);
  } else {
    throw Exception('로그인 서버 오류');
  }
}

// 서버 이미지 저장
Future<dynamic> _sendFile(String url, String filePath) async {
  var request = new http.MultipartRequest("POST", Uri.parse(url));
  try {
    List<String> temps = filePath.split("/");
    String fileName = temps.last + ".jpg";
    request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
    
    return await request.send();
  } catch (e) {
    Log.debug(e.toString());
    // return false;
    throw Exception('파일 전송 오류');
  }
}

// AI 서버 이미지 전송
Future<String> sendFileByAI(String url, String filePath) async {
  try {
    var response = await _sendFile(url, filePath);
    if (response.statusCode == 200) {
      return await response.stream.bytesToString(); //번호판 결과값 반환
    } else {
      return "";
    }
  } catch (e) {
    throw Exception('파일 전송 오류입니다.');
  }
}

// AI 서버 이미지 전송
Future<bool> sendFileByReport(String url, String filePath) async {
  try {
    var response = await _sendFile(url, filePath);
    if (response.statusCode == 200) {
      return true;
    } else {
      Log.debug(response.statusCode.toString());
      return false;
    }
  } catch (e) {
    Log.debug(e.toString());
    // return false;
    throw Exception('파일 전송 오류');
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
