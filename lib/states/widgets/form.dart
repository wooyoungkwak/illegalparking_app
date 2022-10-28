import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/utils/log_util.dart';

Padding createCustomText({
  String? text,
  String? family,
  FontWeight? weight,
  FontStyle? style,
  double? size,
  double? height,
  Color? color,
  double? padding,
  double? top,
  double? bottom,
  double? left,
  double? right,
}) {
  return Padding(
    padding: EdgeInsets.only(top: padding ?? top ?? 8.0, bottom: padding ?? bottom ?? 8.0, left: padding ?? left ?? 8.0, right: padding ?? right ?? 8.0),
    child: Text(
      text ?? "",
      style: TextStyle(
        color: color ?? Colors.black,
        height: height,
        fontSize: size ?? 14.0,
        fontWeight: weight ?? FontWeight.w400,
        fontFamily: family ?? "NotoSansKR",
        fontStyle: style,
      ),
    ),
  );
}

Padding createTextFormField({
  GlobalKey<FormState>? formFieldKey,
  TextEditingController? controller,
  FocusNode? focusNode,
  Color? fillColor,
  double? padding,
  String? labelText,
  String? hintText,
  String? helperText,
  String? errorText,
  bool? obscureText,
  Function? validation,
  Function? onChanged,
  Function? onSaved,
}) {
  // final text = controller!.value.text;
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: TextFormField(
      key: formFieldKey,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText ?? false,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontFamily: "NotoSansKR", fontWeight: FontWeight.w500, fontSize: 12.0),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.black)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.blue)),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.black),
        floatingLabelStyle: const TextStyle(color: AppColors.black),
        hintText: hintText,
        helperText: (controller?.text != "") && (helperText != null) ? helperText : null,
        helperStyle: const TextStyle(color: AppColors.blue),
        errorText: errorText,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validation != null ? (text) => validation(text) : null,
      onChanged: onChanged != null ? (text) => onChanged(text) : null,
      onSaved: onSaved != null ? (text) => onSaved(text) : null,
    ),
  );
}

Padding createElevatedButton({
  Color? textColors,
  Color? color,
  String? text,
  double? width,
  double? padding,
  dynamic function,
}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: SizedBox(
      height: 40,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: color ?? AppColors.blue,
        ),
        onPressed: function,
        child: createCustomText(
          color: textColors ?? AppColors.white,
          weight: AppFontWeight.bold,
          text: text ?? "",
        ),
      ),
    ),
  );
}

Padding createButtonWithIcon({
  required IconData icon,
  Color? textColors,
  Color? color,
  String? text,
  double? width,
  double? padding,
  dynamic function,
}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: SizedBox(
      height: 40,
      width: width ?? double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          size: 18,
          color: textColors,
        ),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: color ?? AppColors.blue,
        ),
        onPressed: function,
        label: createCustomText(
          left: 0.0,
          color: textColors ?? AppColors.white,
          weight: AppFontWeight.bold,
          text: text ?? "",
        ),
      ),
    ),
  );
}

Container createMypageContainer({List<Widget>? widgetList, dynamic route}) {
  return Container(
    // Round 처리하는데 3개를 수정해야됨
    // 1
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18.0),
    ),
    child: Material(
      // 2
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: Ink(
        child: InkWell(
          // 3
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          onTap: route,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                children: widgetList ?? [],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

showCustomDialog({required BuildContext context, String? title, Widget? widget}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(title ?? ""),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.cancel_outlined))
          ],
        ),
        body: widget),
  );
}

// showNoticeDialog({required BuildContext context, required int index, Widget? widget}) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         int noticeIndex = index;
//         return StatefulBuilder(builder: (context, setState) {
//           return Scaffold(
//               appBar: AppBar(
//                 automaticallyImplyLeading: false,
//                 centerTitle: true,
//                 title: const Text("소식"),
//                 actions: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.cancel_outlined))
//                 ],
//               ),
//               body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             noticeIndex--;
//                           },
//                           icon: const Icon(Icons.chevron_left)),
//                       const Spacer(),
//                       IconButton(
//                           onPressed: () {
//                             noticeIndex++;
//                           },
//                           icon: const Icon(Icons.chevron_right)),
//                     ],
//                   ),
//                   // 공지/소식
//                   Row(
//                     children: [
//                       createCustomText(
//                         text: noticeList[index].noticeType,
//                       ),
//                       createCustomText(
//                         text: noticeList[index].subject,
//                       ),
//                     ],
//                   ),

//                   createCustomText(
//                     weight: FontWeight.w400,
//                     text: noticeList[index].regDt,
//                   ),
//                   // // 빈공간
//                   // Expanded(
//                   //   flex: 5,
//                   //   child: ConstrainedBox(
//                   //     constraints: const BoxConstraints(),
//                   //   ),
//                   // ),
//                   createCustomText(
//                     weight: FontWeight.w400,
//                     text: noticeList[index].content!,
//                   ),
//                   // 빈공간
//                   // Expanded(
//                   //   flex: 5,
//                   //   child: ConstrainedBox(
//                   //     constraints: const BoxConstraints(),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           );
//         });
//       });
// }

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

// 신고이력, 내차정보 관련
BoxConstraints addrTextWidthLimit(String state, BuildContext context) {
  double appWidthSize = MediaQuery.of(context).size.width;
  Log.debug("appWidthSize : $appWidthSize");
  if (state.length > 5) {
    return BoxConstraints(maxWidth: appWidthSize - 216); // 5글자 : 216, 4글자 : 196,
  }
  return BoxConstraints(maxWidth: appWidthSize - 196);
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

//바텀sheet 불법 주정차 기준 창
void widgetbottomsheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: Column(
            children: [
              const SizedBox(width: 50, child: Divider(color: Colors.blueGrey, thickness: 4.0)),
              const SizedBox(height: 15),
              const Expanded(
                flex: 1,
                child: CustomText(text: "불법주정차 법규", weight: FontWeight.w300, color: Colors.black),
              ),
              const SizedBox(height: 5),
              Expanded(
                  flex: 8,
                  child: Image.asset(
                    "assets/parking _rule.png",
                    filterQuality: FilterQuality.high,
                  )), //불법주정차에 대한 법규 이미지 넣을 부분
              const SizedBox(height: 10),
              Expanded(
                  flex: 1,
                  child: createElevatedButton(
                      color: AppColors.black,
                      text: "확인",
                      function: () {
                        Get.back();
                      })),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}
