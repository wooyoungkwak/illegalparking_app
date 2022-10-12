import 'dart:convert';

import 'package:illegalparking_app/config/env.dart';

LoginInfo resultInfoFromJson(String str) => LoginInfo.fromJson(json.decode(str));

String resultInfoToJson(LoginInfo loginInfo) => json.encode(loginInfo.toJson());

class LoginInfo {
  LoginInfo(this.success, this.message, this.data);

  bool success;
  String? message;
  Map<String, dynamic>? data = {};

  static LoginInfo fromJson(Map<String, dynamic> json) {
    return LoginInfo(json["success"], json["msg"], json["user"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message,  "data": data};

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
