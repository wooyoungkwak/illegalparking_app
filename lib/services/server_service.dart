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
  var data = {"userName": id, "password": pw};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_LOGIN_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);

    Log.debug("Login Info : ${resultMap["data"].toString()}");
    //로그인 성공 실패 체크해서 Model 다르게 설정
    return LoginInfo.fromJson(resultMap);
  } else {
    throw Exception('로그인 서버 오류');
  }
}

// 사용자 등록
Future<RegisterInfo> register(String id, String pw, String name, String phoneNumber, String photoName) async {
  var data = {"userName": id, "password": pw, "name": name, "phoneNumber": phoneNumber, "photoName": photoName};
  var body = json.encode(data);
  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_REGISTER_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);

    //로그인 성공 실패 체크해서 Model 다르게 설정
    return RegisterInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// ID 중복 체크
Future<dynamic> duplicate(String id) async {
  var data = {"userName": id};
  var body = json.encode(data);
  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_IS_EXIST_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);

    // resultMap.data
    // -- resultMap.data["isExist"]   :  존재 여부 ( true / false )
    // -- resultMap.data["msg"] : true 경우 - "존재하지 않는 사용자입니다."

    //로그인 성공 실패 체크해서 Model 다르게 설정
    return resultMap;
  } else {
    throw Exception('서버 오류');
  }
}

// 신고 전송
Future<ReportInfo> sendReport(int userSeq, String addr, String carNum, String time, String fileName, double latitude, double longitude) async {
  var data = {
    "userSeq": userSeq,
    "addr": addr, // 주소
    "carNum": carNum, // 차량번호
    "regDt": time, // 시간
    "fileName": fileName, //
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
    throw Exception('신고 전송 오류');
  }
}

// 신고 이력 정보 요청
Future<ReportHistoryInfo> requestReportHistory(int userSeq) async {
  var data = {"userSeq": userSeq};

  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_REPORT_GET_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return ReportHistoryInfo.fromJson(resultMap);
  } else {
    throw Exception('신고 이력 정보 요청 오류');
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

// 관리자 서버 이미지 전송
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

//  내정보 기본 페이지 정보 요청
Future<MyPageInfo> requestMyPage(int userSeq) async {
  var data = {"userSeq": userSeq};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_MY_PAGE_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return MyPageInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 추가 공지 정보
Future<NoticeListInfo> requestNotice(int userSeq, int offset, int count) async {
  var data = {"userSeq": userSeq, "offset": offset, "count": count};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_NOTICE_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return NoticeListInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 포인트 정보 요청
Future<PointListInfo> requestPoint(int userSeq) async {
  var data = {"userSeq": userSeq};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_POINT_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return PointListInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 제품 정보 리스트 요청
Future<ProductListInfo> requestProductList(int userSeq) async {
  var data = {"userSeq": userSeq};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_PRODUCT_LIST_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return ProductListInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 상품 신청 요청
Future<ProductBuyInfo> requestProductBuy(int userSeq, int productSeq, int balancePointValue) async {
  var data = {"userSeq": userSeq, "productSeq": productSeq, "balancePointValue": balancePointValue};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_PRODUCT_BUY_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return ProductBuyInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 차량 이력 정보 요청
Future<AlarmHistoryListInfo> requestAlarmHistory(int userSeq, String carNum) async {
  var data = {"userSeq": userSeq, "carNum": carNum};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_CAR_ALARMHISTROY_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return AlarmHistoryListInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 차량 이력 정보 등록 요청
Future<DefaultInfo> requestCarRegister(int userSeq, String carNum, String carName, String carGrade) async {
  var data = {"userSeq": userSeq, "carNum": carNum, "carName": carName, "carGrade": carGrade};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_CAR_REGISTER_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return DefaultInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 내차 알림 설정 요청
Future<DefaultInfo> requestMyCarAlarm(int userSeq, String carNum, bool isAlarm) async {
  var data = {"userSeq": userSeq, "carNum": carNum, "isAlarm": isAlarm};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_CAR_ALARM_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return DefaultInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 패스워드 체크 요청
Future<DefaultInfo> requestUserPasswordCheck(int userSeq, String password) async {
  var data = {"userSeq": userSeq, "password": password};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_USER_PASSWORD_CHCEK_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return DefaultInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 패스워드 변경 요청
Future<DefaultInfo> requestUserPasswordChange(int userSeq, String password) async {
  var data = {"userSeq": userSeq, "password": password};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_USER_PASSWORD_CHANGE_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return DefaultInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}

// 프로 사진 변경 요청
Future<DefaultInfo> requestUserProfileChange(int userSeq, String photoName) async {
  var data = {"userSeq": userSeq, "photoName": photoName};
  var body = json.encode(data);

  var response = await http.post(Uri.parse(Env.SERVER_ADMIN_USER_PROFILE_URL), headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String result = utf8.decode(response.bodyBytes);
    Map<String, dynamic> resultMap = jsonDecode(result);
    return DefaultInfo.fromJson(resultMap);
  } else {
    throw Exception('서버 오류');
  }
}
