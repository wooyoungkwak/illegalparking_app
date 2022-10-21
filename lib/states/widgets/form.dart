import 'package:flutter/material.dart';

Padding createCustomText({
  String? text,
  String? family,
  double? size,
  double? height,
  FontWeight? weight,
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
        fontSize: size ?? 18.0,
        fontWeight: weight ?? FontWeight.bold,
        fontFamily: family,
      ),
    ),
  );
}

Padding createTextFormField({
  GlobalKey<FormState>? formFieldKey,
  String? labelText,
  String? hintText,
  String? helperText,
  double? padding,
  bool? obscureText,
  TextEditingController? controller,
  Function? validation,
}) {
  // final text = controller!.value.text;
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: TextFormField(
      key: formFieldKey,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
        helperText: (controller?.text != "") && (helperText != null) ? helperText : null,
        helperStyle: const TextStyle(
          color: Colors.blue,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validation != null ? (text) => validation(text) : null,
      onChanged: (text) {
        labelText = text;
      },
    ),
  );
}

Padding createElevatedButton({
  String? text,
  Color? color,
  double? padding,
  dynamic? function,
}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color ?? Colors.blue,
        ),
        onPressed: function,
        child: Text(text ?? ""),
      ),
    ),
  );
}

Card createMypageCard({List<Widget>? widgetList, dynamic route}) {
  return Card(
    elevation: 4,
    child: Material(
      child: Ink(
        child: InkWell(
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
      color = const Color(0xffd84315);
      break;
    case "신고제외":
      color = const Color(0xff9e9e9e);
      break;
    case "과태료 대상":
      color = const Color(0xffbf360c);
      break;
  }
  return color;
}

// 신고이력, 내차정보 관련
BoxConstraints addrTextWidthLimit(String state) {
  if (state.length > 5) {
    return const BoxConstraints(maxWidth: 198); // 4글자 : 218, 5글자 : 198
  }
  return const BoxConstraints(maxWidth: 218);
}
