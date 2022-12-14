import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/setting_controller.dart';
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
  TextOverflow? overflow,
}) {
  return Padding(
    padding: EdgeInsets.only(top: padding ?? top ?? 8.0, bottom: padding ?? bottom ?? 8.0, left: padding ?? left ?? 8.0, right: padding ?? right ?? 8.0),
    child: Text(
      text ?? "",
      overflow: overflow,
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
  required bool obscureText,
  bool? readOnly,
  Function? validation,
  Function? onChanged,
  Function? onSaved,
  bool? passwordswich,
  dynamic function,
}) {
  final settingController = Get.put(SettingController());
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: TextFormField(
      key: formFieldKey,
      focusNode: focusNode,
      controller: controller,
      readOnly: readOnly ?? false,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontFamily: "NotoSansKR", fontWeight: FontWeight.w500, fontSize: 12.0),
      decoration: passwordswich == true
          ? InputDecoration(
              suffixIcon: obscureText
                  ? IconButton(icon: const Icon(Icons.visibility_off_outlined), color: Colors.black, onPressed: function)
                  : IconButton(icon: const Icon(Icons.visibility_outlined), color: Colors.black, onPressed: function),
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
            )
          : InputDecoration(
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
        icon: Icon(icon, size: 18, color: textColors),
        style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: color ?? AppColors.blue),
        label: createCustomText(
          left: 0.0,
          color: textColors ?? AppColors.white,
          weight: AppFontWeight.bold,
          text: text ?? "",
        ),
        onPressed: function,
      ),
    ),
  );
}

Container createMypageContainer({List<Widget>? widgetList, dynamic route}) {
  return Container(
    // Round ??????????????? 3?????? ???????????????
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

//??????sheet ?????? ????????? ?????? ???
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
              const SizedBox(width: 50, child: Divider(color: Color(0xffCCCCCC), thickness: 4.0)),
              const SizedBox(height: 15),
              const Expanded(
                flex: 1,
                child: CustomText(
                  text: "??????????????? ??????",
                  weight: AppFontWeight.bold,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                  flex: 8,
                  child: Image.asset(
                    "assets/parking _rule.png",
                    filterQuality: FilterQuality.high,
                  )), //?????????????????? ?????? ?????? ????????? ?????? ??????
              const SizedBox(height: 10),
              Expanded(
                  flex: 1,
                  child: createElevatedButton(
                      color: AppColors.black,
                      text: "??????",
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

Row createContainerByTopWidget({String? text, dynamic function, Color color = const Color(0xff707070)}) {
  double widval = 8.0;
  double highval = Platform.isIOS ? 40.0 : 8.0;

  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Padding(
      //?????? ?????????
      padding: EdgeInsets.symmetric(horizontal: widval, vertical: highval),
      child: IconButton(onPressed: () {}, icon: const Icon(Icons.close_outlined), color: Colors.transparent),
    ),
    CustomText(text: text ?? "", weight: AppFontWeight.black, color: Colors.black),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: widval, vertical: highval),
      child: IconButton(onPressed: function, icon: const Icon(Icons.close_outlined), color: color),
    ),
  ]);
}

InkWell createBytapImage(BuildContext context, String path, double height, double width) {
  bool successimage = true;
  return InkWell(
    child: Image.network(
      height: height,
      width: width,
      fit: BoxFit.cover,
      path,
      errorBuilder: (context, error, stackTrace) {
        successimage = false;
        return Image.asset(
          height: height + 10,
          width: width + 10,
          fit: BoxFit.cover,
          "assets/noimage.jpg",
        );
      },
    ),
    onTap: () {
      if (successimage) {
        showDialog(
            barrierColor: AppColors.black,
            context: context,
            builder: (BuildContext context) => Dialog(
                  child: GestureDetector(
                    onTap: () {
                      navigator?.pop();
                    },
                    child: Image.network(
                      height: Env.MEDIA_SIZE_HEIGHT! / 2,
                      width: Env.MEDIA_SIZE_WIDTH! / 2,
                      fit: BoxFit.cover,
                      path,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        height: Env.MEDIA_SIZE_HEIGHT! / 2,
                        width: Env.MEDIA_SIZE_WIDTH! / 2,
                        fit: BoxFit.cover,
                        "assets/noimage.jpg",
                      ),
                    ),
                  ),
                ));
      }
    },
  );
}
