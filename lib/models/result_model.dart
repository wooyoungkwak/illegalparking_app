import 'dart:convert';

import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/utils/log_util.dart';

LoginInfo resultInfoFromJson(String str) => LoginInfo.fromJson(json.decode(str));

String resultInfoToJson(LoginInfo loginInfo) => json.encode(loginInfo.toJson());

class LoginInfo {
  LoginInfo(this.success, this.message, this.data);

  bool success;
  String? message;
  Map<String, dynamic>? data = {};

  // - user-
  // userSeq
  // name   - 사용자 이름
  // username - id
  // role - 권한 ( "user" )
  // photoName - 아이콘 이름
  // phoneNumber - 전화 번호
  // userCode - 의미 없음

  static LoginInfo fromJson(Map<String, dynamic> json) {
    return LoginInfo(json["success"], json["msg"], json["data"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message,  "data": data};

  int getUserSeq() {
    return data![Env.KEY_USER_SEQ];
  }

  String getPhotoPath() {
    return data![Env.KEY_PHOTO_NAME];
  }

  String getKrName() {
    return data![Env.KEY_KR_NAME];
  }

  String getCompanyName() {
    return data![Env.KEY_PHONE_NUMBER];
  }

}


class RegisterInfo {
  RegisterInfo(this.success, this.message, this.data);

  bool success;
  String? message;
  Map<String, dynamic>? data = {};

  // - user-
  // userSeq
  // name   - 사용자 이름
  // username - id
  // role - 권한 ( "user" )
  // photoName - 아이콘 이름
  // phoneNumber - 전화 번호
  // userCode - 의미 없음

  static RegisterInfo fromJson(Map<String, dynamic> json) {
    if (json["data"] == null || json["data"] == "") {
      return RegisterInfo(json["success"], json["msg"], null);
    } else {
      return RegisterInfo(json["success"], json["msg"], json["data"]);
    }
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message,  "data": data};

}

class ReportInfo {
  
  ReportInfo(this.success, this.message);
  bool success;
  String? message;

  static ReportInfo fromJson(Map<String, dynamic> json) {
    return ReportInfo(json["success"], json["msg"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message};
  
}