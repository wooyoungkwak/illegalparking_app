import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:illegalparking_app/utils/log_util.dart';

Padding createCustomText({
  String? text,
  String? family,
  double? size,
  double? height,
  FontWeight? weight,
  Color? color,
  double? padding,
}) {
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
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

String? _errorText(TextEditingController controller) {
  final text = controller.value.text;
  if (text.isEmpty) {
    return 'Can\t be empty';
  }

  return null;
}

Padding createTextFormField({
  GlobalKey<FormState>? formFieldKey,
  String? labelText,
  String? hintText,
  double? padding,
  bool? obscureText,
  TextEditingController? controller,
}) {
  // final text = controller!.value.text;
  return Padding(
    padding: EdgeInsets.all(padding ?? 8.0),
    child: TextFormField(
      key: formFieldKey,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
        errorText: controller != null ? _errorText(controller) : null,
      ),
      validator: (text) {
        Log.debug("validator Text: $text");
        if (text!.isEmpty) {
          return "$labelText를 입력해 주세요";
        } else if (text.length < 2) {
          return "필수 입력 사항입니다.";
        }
        return null;
      },
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
        style: ElevatedButton.styleFrom(primary: color ?? Colors.blue),
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
                  Navigator.pop(context);
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

Card createReportList(BuildContext context, List list) {
  return Card(
    child: Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        list.length,
        (index) => SizedBox(
          child: Wrap(
            children: [
              Column(
                children: [
                  //주 정보
                  Row(
                    children: [
                      // 이미지
                      Image(
                        height: 80,
                        width: 80,
                        image: AssetImage(
                          list[index]["image"],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //주소
                          createCustomText(
                            size: 16.0,
                            text: list[index]["address"],
                          ),
                          //시간
                          createCustomText(
                            size: 12.0,
                            text: list[index]["time"],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: reportColors(list[index]["state"]),
                          child: createCustomText(
                            weight: FontWeight.w400,
                            color: reportColors(list[index]["state"]) == const Color(0xffffffff) ? Colors.black : Colors.white,
                            text: list[index]["state"],
                          ),
                        ),
                      )
                      // 상태
                    ],
                  ),
                ],
              ),
              //메세지
              createCustomText(
                padding: 16.0,
                size: 12.0,
                text: "* ${list[index]["message"]}",
              ),
              if (list.length != (index + 1))
                Container(
                  color: Colors.grey,
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                )
            ],
          ),
        ),
      ),
    ),
  );
}

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
    case "과태료대상":
      color = const Color(0xffbf360c);
      break;
  }
  return color;
}
