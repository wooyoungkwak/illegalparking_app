import 'package:intl/intl.dart';

String getDateToString(DateTime datetime, String formatStr) {
  DateFormat dateFormat = DateFormat(formatStr);
  return dateFormat.format(datetime);
}

DateTime getNow() {
  return DateTime.now();
}

String getDateToStringForMMDD(DateTime datetime) {
  return getDateToString(datetime, "MM-dd");
}

String getDateToStringForYYMMDD(DateTime datetime) {
  return getDateToString(datetime, "yyyy-MM-dd");
}

String getDateToStringForYYMMDDHHMM(DateTime datetime) {
  return getDateToString(datetime, "yyyy-MM-dd kk:mm");
}

String getDateToStringForAll(DateTime datetime) {
  return getDateToString(datetime, "yyyy-MM-dd kk:mm:ss");
}

String getDateToStringForMMDDInNow() {
  return getDateToString(getNow(), "MM-dd");
}

String getDateToStringForYYYYMMDDInNow() {
  return getDateToString(getNow(), "yyyy-MM-dd");
}

String getDateToStringForYYYYMMDDKORInNow() {
  return getDateToString(getNow(), "yyyy년 MM월 dd일");
}

String getDateToStringForYYYYMMDDHHMMKORInNow() {
  return getDateToString(getNow(), "yyyy년 MM월 dd일 kk:mm");
}

String getDateToStringForMMDDKORInNow() {
  return getDateToString(getNow(), "MM월 dd일");
}

String getDateToStringForAllInNow() {
  return getDateToStringForAll(getNow());
}

String getPickerTime(DateTime datetime) {
  return getDateToString(datetime, "kk:mm");
}

String getDateToStringForHHMMSSInNow() {
  return getDateToString(getNow(), "kk:mm:ss");
}

String getDateToStringForHHMMInNow() {
  return getDateToString(getNow(), "kk:mm");
}

String getDateToStringForHHInNow() {
  return getDateToString(getNow(), "kk");
}

String getDateToStringForMMInNow() {
  return getDateToString(getNow(), "mm");
}

String getDateToStringForNumber() {
  return getDateToString(getNow(), "yyyyMMddkkmmss");
}

String getMinorToDate() {
  String date = getDateToString(getNow(), "MMdd");
  if (date.substring(0, 1) == "0") {
    date = date.substring(1);
  }

  return date;
}

String getWeek() {
  return DateFormat('E', 'en_US').format(getNow());
}

String getWeekByKor() {
  String result = "";
  switch (getWeek()) {
    case 'Mon':
      result = "월요일";
      break;
    case 'Tue':
      result = "화요일";
      break;
    case 'Wed':
      result = "수요일";
      break;
    case 'Thu':
      result = "목요일";
      break;
    case 'Fri':
      result = "금요일";
      break;
    case 'Sat':
      result = "토요일";
      break;
    case 'Sun':
      result = "일요일";
      break;
  }
  return result;
}

String getWeekByOneKor() {
  String result = "";
  switch (getWeek()) {
    case 'Mon':
      result = "월";
      break;
    case 'Tue':
      result = "화";
      break;
    case 'Wed':
      result = "수";
      break;
    case 'Thu':
      result = "목";
      break;
    case 'Fri':
      result = "금";
      break;
    case 'Sat':
      result = "토";
      break;
    case 'Sun':
      result = "일";
      break;
  }
  return result;
}

DateTime getToDateTime(String date) {
  return DateTime.parse(date);
}
