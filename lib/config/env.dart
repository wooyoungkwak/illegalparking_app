// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';

class Env {
  static bool isDebug = true; // 배포시 false

  static const String AI_SERVER = "http://teraenergy.iptime.org"; // AI 서버
  static const String ADMIN_SERVER = "http://teraenergy.iptime.org"; // 관리자 서버

  static const String SERVER_AI_URL = "$AI_SERVER:18091";
  static const String SERVER_ADMIN_URL = "$ADMIN_SERVER:18090";

  static const String SERVER_AI_FILE_UPLOAD_URL = '$SERVER_AI_URL/';
  static const String SERVER_LOGIN_URL = '$SERVER_AI_URL/api/login';

  static const String SERVER_ADMIN_FILE_UPLOAD_URL = '$SERVER_ADMIN_URL/files/image/set';
  static const String SERVER_ADMIN_REPORT_UPLOAD_URL = '$SERVER_ADMIN_URL/api/receipt/set';

  static const String MAP_TEST_SERVER = "http://220.95.46.211:18090/area/map";
  static const String MAP_REAL_SERVER = "http://49.50.166.205/area/map";

  static const String MAP_REAL_URL = MAP_REAL_SERVER;

  static const String USER_NICK_NAME = 'USER_NICK_NAME';
  static const String LOGIN_ID = 'LOGIN_ID';
  static const String LOGIN_PW = 'LOGIN_PW';

  static const String WORK_TYPE_TODAY = "today";
  static const String WORK_TYPE_WEEK = "week";

  static bool WORK_PLACE_CHANGE_STATE = false;
  static String? WORK_KR_NAME;
  static String? WORK_POSITION_NAME;
  static String? WORK_PHOTO_PATH;
  static String? WORK_COMPANY_NAME;
  static int? USER_SEQ;

  static const String LOGIN_STATE = "LOGIN_STATE";
  static const String KEY_USER_ID = "USER_ID"; // Login 후에 서버로부터 부여 받은 사용자 ID 값
  static const String KEY_ID_CHECK = 'KEY_ID_CHECK';
  static const String KEY_ACCESS_TOKEN = "accessToken";
  static const String KEY_REFRESH_TOKEN = "refreshToken";
  static const String KEY_SETTING_UUID = "uuid";
  static const String KEY_SETTING_VIBRATE = "VIBRATE";
  static const String KEY_SETTING_SOUND = "SOUND";
  static const String KEY_SETTING_ALARM = "ALARM";
  static const String KEY_LOGIN_SUCCESS = "success";
  static const String KEY_PHOTO_NAME = "photoName";
  static const String KEY_PHONE_NUMBER = "phoneNumber";

  static const String KEY_PHOTO_PATH = "photo_path";
  static const String KEY_KR_NAME = "krName";
  static const String KEY_POSITION_NAME = "positionName";
  static const String KEY_COMPANY_NAME = "companyName";
  static const String KEY_SHARE_UUID = "share_uuid";
  static const String KEY_BACKGROUND_PATH = 'background_path';

  static const String MSG_NOT_TOKEN = "로그인 후 사용 해주세요.";

  static const String NAVER_SERVICE_ID = "ncp:sms:kr:294175196378:sms_auth_test";
  static const String NAVER_ACCESS_KEY = "4VqjVzPCbUUnTO9nDy92";
  static const String NAVER_SECRET_KEY = "6Pm4jOKBTTtAYDR3rWQhdSnwXFzk6xxuNx7JJYWJ";
}
