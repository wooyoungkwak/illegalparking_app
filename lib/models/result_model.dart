import 'dart:convert';

import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/utils/log_util.dart';

LoginInfo resultInfoFromJson(String str) => LoginInfo.fromJson(json.decode(str));

String resultInfoToJson(LoginInfo loginInfo) => json.encode(loginInfo.toJson());

class DefaultInfo {
  DefaultInfo(this.success, this.message, this.data);
  bool success;
  String? message;
  String? data;

  static DefaultInfo fromJson(Map<String, dynamic> json) {
    return DefaultInfo(json["success"], json["msg"], json["data"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data};
}

class LoginInfo {
  LoginInfo(this.success, this.message, this.data);

  bool success;
  String? message;
  Map<String, dynamic> data = {};

  // - user-
  // userSeq
  // name   - 사용자 이름
  // username - id
  // role - 권한 ( "user" )
  // photoName - 아이콘 이름
  // phoneNumber - 전화 번호
  // userCode - 의미 없음

  static LoginInfo fromJson(Map<String, dynamic> json) {
    if (json["data"].runtimeType.toString() == 'String') {
      return LoginInfo(json["success"], json["msg"], {});
    } else {
      return LoginInfo(json["success"], json["msg"], json["data"]);
    }
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data};

  int getUserSeq() {
    return data[Env.KEY_USER_SEQ];
  }

  String getPhotoName() {
    return data[Env.KEY_PHOTO_NAME];
  }

  String getKrName() {
    return data[Env.KEY_KR_NAME];
  }

  String getPhoneNumber() {
    return data[Env.KEY_PHONE_NUMBER];
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

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data};
}

class ReportInfo {
  ReportInfo(this.success, this.message, this.data);
  bool success;
  String? message;
  String? data;

  static ReportInfo fromJson(Map<String, dynamic> json) {
    return ReportInfo(json["success"], json["msg"], json["data"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data};
}

class ReportHistoryInfo {
  ReportHistoryInfo(this.success, this.message, this.reportResultInfos);
  bool success;
  String? message;
  List<ReportResultInfo> reportResultInfos;

  static ReportHistoryInfo fromJson(Map<String, dynamic> json) {
    List<ReportResultInfo> reportResultInfos = [];
    List<dynamic> list = json["data"];
    for (int i = 0; i < list.length; i++) {
      reportResultInfos.add(ReportResultInfo.fromJson(list[i]));
    }
    return ReportHistoryInfo(json["success"], json["msg"], reportResultInfos);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "reportResultInfos": reportResultInfos};
}

class ReportResultInfo {
  ReportResultInfo(this.carNum, this.addr, this.firstRegDt, this.secondRegDt, this.reportState, this.firstFileName, this.secondFileName, this.comments);
  String carNum;
  String addr;
  String firstRegDt;
  String? secondRegDt;
  String reportState;
  String firstFileName;
  String? secondFileName;
  List<dynamic> comments;

  static ReportResultInfo fromJson(Map<String, dynamic> json) {
    return ReportResultInfo(json["carNum"], json["addr"], json["firstRegDt"], json["secondRegDt"], json["reportState"], json["firstFileName"], json["secondFileName"], json["comments"]);
  }
}

class MyPageInfo {
  MyPageInfo(this.success, this.message, this.carNum, this.carLevel, this.carName, this.isAlarm, this.reportCount, this.currentPoint, this.notices);
  bool success;
  String? message;
  String? carNum;
  String carLevel;
  String carName;
  bool isAlarm;
  int reportCount;
  int currentPoint;
  List<NoticeInfo> notices;

  static MyPageInfo fromJson(Map<String, dynamic> json) {
    if (json["data"].runtimeType.toString() == 'String') {
      return MyPageInfo(json["success"], json["msg"], "", "", "", false, 0, 0, []);
    } else {
      List<NoticeInfo> notices = [];
      List<dynamic> noticeList = json["data"]["notices"];
      for (int i = 0; i < noticeList.length; i++) {
        notices.add(NoticeInfo.fromJson(noticeList[i]));
      }
      return MyPageInfo(json["success"], json["msg"], json["data"]["carNum"], json["data"]["carLevel"], json["data"]["carName"], json["data"]["isAlarm"], json["data"]["reportCount"],
          json["data"]["currentPoint"], notices);
    }
  }

  Map<String, dynamic> toJson() =>
      {"success": success, "carNum": carNum, "carLevel": carLevel, "carName": carName, "isAlarm": isAlarm, "reportCount": reportCount, "currentPoint": currentPoint, "notices": notices};
}

class NoticeListInfo {
  NoticeListInfo(this.success, this.message, this.noticeInfos);
  bool success;
  String? message;
  List<NoticeInfo> noticeInfos;

  static NoticeListInfo fromJson(Map<String, dynamic> json) {
    List<NoticeInfo> noticeInfos = [];
    List<dynamic> noticeList = json["data"];
    for (int i = 0; i < noticeList.length; i++) {
      noticeInfos.add(NoticeInfo.fromJson(noticeList[i]));
    }

    return NoticeListInfo(json["success"], json["msg"], noticeInfos);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "notices": noticeInfos};
}

class NoticeInfo {
  NoticeInfo(this.noticeType, this.subject, this.content, this.regDt);
  String noticeType;
  String subject;
  String? content;
  String regDt;

  static NoticeInfo fromJson(Map<String, dynamic> json) {
    return NoticeInfo(json["noticeType"], json["subject"], json["content"], json["regDt"]);
  }

  // noticeType
  //  DISTRIBUTION("공지"),
  //  ANNOUNCEMENT("소식")

  Map<String, dynamic> toJson() => {"noticeType": noticeType, "subject": subject, "content": content, "regDt": regDt};
}

class PointListInfo {
  PointListInfo(this.success, this.message, this.pointInfos);

  bool success;
  String? message;
  List<PointInfo> pointInfos;

  // pointType : PLUS / MINUS

  static PointListInfo fromJson(Map<String, dynamic> json) {
    List<PointInfo> pointInfos = [];
    List<dynamic> pointList = json["data"];
    for (int i = 0; i < pointList.length; i++) {
      pointInfos.add(PointInfo.fromJson(pointList[i]));
    }
    return PointListInfo(json["success"], json["msg"], pointInfos);
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "pointInfos": pointInfos};
}

class PointInfo {
  PointInfo(this.value, this.locationType, this.productName, this.pointType, this.regDt);

  int value;
  String? locationType;
  String? productName;
  String pointType;
  String regDt; // 등록 일자 ( yyyy-MM-dd HH:mm)

  // pointType : PLUS / MINUS
  static PointInfo fromJson(Map<String, dynamic> json) {
    // 정보가 제대로면 이건 필요 없음...
    if (json["locationType"] == null) {
      return PointInfo(json["value"], "", json["productName"], json["pointType"], json["regDt"]);
    } else if (json["productName"] == null) {
      return PointInfo(json["value"], json["locationType"], "", json["pointType"], json["regDt"]);
    }
    return PointInfo(json["value"], json["locationType"], json["productName"], json["pointType"], json["regDt"]);
  }

  Map<String, dynamic> toJson() => {"value": value, "locationType": locationType, "productName": productName, "pointType": pointType, "regDt": regDt};
}

class ProductListInfo {
  ProductListInfo(this.success, this.message, this.productInfos);
  bool success;
  String? message;
  List<ProductInfo> productInfos;

  static ProductListInfo fromJson(Map<String, dynamic> json) {
    bool success = json["success"];
    String? message = json["msg"];
    List<dynamic> productInfoList = json["data"];
    List<ProductInfo> productInfos = [];

    for (int i = 0; i < productInfoList.length; i++) {
      productInfos.add(ProductInfo.fromJson(productInfoList[i]));
    }

    return ProductListInfo(success, message, productInfos);
  }
}

class ProductInfo {
  ProductInfo(this.productSeq, this.brandType, this.productName, this.pointValue, this.thumbnail);
  int productSeq;
  String brandType;
  String productName;
  int pointValue;
  String thumbnail;

  static ProductInfo fromJson(Map<String, dynamic> json) {
    Log.debug("thumbnail : ${json['thumbnail']}");
    return ProductInfo(json["productSeq"], json["brandType"], json["productName"], json["pointValue"], json["thumbnail"]);
  }

  Map<String, dynamic> toJson() => {"productSeq": productSeq, "brandType": brandType, "productName": productName, "pointValue": pointValue, "thumbnail": thumbnail};
}

class ProductBuyInfo {
  ProductBuyInfo(this.success, this.message, this.data);
  bool success;
  String? message;
  String? data;

  static fromJson(Map<String, dynamic> json) {
    return ProductBuyInfo(json["success"], json["msg"], json["data"]);
  }
}

class AlarmHistoryListInfo {
  AlarmHistoryListInfo(this.success, this.message, this.alarmHistoryInfos);
  bool success;
  String? message;
  List<AlarmHistoryInfo>? alarmHistoryInfos;

  static fromJson(Map<String, dynamic> json) {
    bool success = json["success"];
    String? message = json["msg"];
    List<dynamic>? alarmHistoryInfoList = json["data"];
    List<AlarmHistoryInfo> alarmHistoryInfo = [];

    for (int i = 0; i < alarmHistoryInfoList!.length; i++) {
      alarmHistoryInfo.add(AlarmHistoryInfo.fromJson(alarmHistoryInfoList[i]));
    }

    if (alarmHistoryInfoList == null || alarmHistoryInfoList == "") {
      return AlarmHistoryListInfo(success, message, []);
    } else {
      return AlarmHistoryListInfo(success, message, alarmHistoryInfo);
    }
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "alarmHistoryInfos": alarmHistoryInfos};
}

class AlarmHistoryInfo {
  AlarmHistoryInfo(this.addr, this.regDt, this.stateType, this.fileName);
  String addr;
  String regDt;
  String stateType;
  String fileName;

  // statType;
  // OCCUR("신고대기")
  // NOTHING("신고불가")
  // REPORT("신고접수")
  // FORGET("신고종료")
  // EXCEPTION("신고제외")
  // PENALTY("과태료 대상")

  static fromJson(Map<String, dynamic> json) {
    return AlarmHistoryInfo(json["addr"], json["regDt"], json["stateType"], json["fileName"]);
  }

  Map<String, dynamic> toJson() => {"addr": addr, "regDt": regDt, "stateType": stateType, "fileName": fileName};
}
