import 'package:flutter/material.dart';

Padding createTextFormField({
  String? labelText,
  String? hintText,
  bool? obscureText,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "$labelText를 입력해 주세요";
        }
        return null;
      },
    ),
  );
}

Padding createElevatedButton({
  String? text,
  dynamic function,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: function ?? () {},
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
