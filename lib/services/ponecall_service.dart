import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

//전화걸기
Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
