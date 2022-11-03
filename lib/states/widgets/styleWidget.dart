// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:illegalparking_app/config/style.dart';

// 신고이력, 내차정보 관련
Color reportColors(String state) {
  Color color = const Color(0xffffffff);
  switch (state) {
    case "신고발생":
      color = const Color(0xffffc107);
      break;
    case "신고대기":
      color = const Color(0xffffc107);
      break;
    case "신고접수":
      color = const Color(0xffD95321);
      break;
    case "신고제외":
      color = const Color(0xff888888);
      break;
    case "과태료 대상":
      color = const Color(0xffB12915);
      break;
  }
  return color;
}

Icon chevronRight() {
  return const Icon(
    color: AppColors.textGrey,
    size: 32,
    Icons.chevron_right,
  );
}

Icon chevronLeft() {
  return const Icon(
    color: AppColors.textGrey,
    size: 32,
    Icons.chevron_left,
  );
}

// 신고이력, 내차정보 관련
BoxConstraints addrTextWidthLimit(String state, BuildContext context) {
  double appWidthSize = MediaQuery.of(context).size.width;
  if (state.length > 5) {
    return BoxConstraints(maxWidth: appWidthSize - 220); // 5글자 : 216, 4글자 : 196,
  }
  return BoxConstraints(maxWidth: appWidthSize - 200);
}

// 차종별 이미지
ImageProvider<Object> carGradeImage(String? carGrade) {
  String imagePath = "assets/";
  switch (carGrade) {
    case "소형":
      return AssetImage("${imagePath}segment_subcompact.png");
    case "중형":
      return AssetImage("${imagePath}segment_mid.png");
    case "SUV":
      return AssetImage("${imagePath}segment_suv.png");
    case "트럭":
      return AssetImage("${imagePath}segment_truck.png");
    case "중장비":
      return AssetImage("${imagePath}segment_equipment.png");
  }

  return const AssetImage("assets/testVehicle.jpg");
}
