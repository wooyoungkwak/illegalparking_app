import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/config/env.dart';

// device IP 확인
Future<Map<String, dynamic>> getIPAddressByWifi() async {
  final networkInfo = NetworkInfo();
  var ip = await networkInfo.getWifiIP();
  var ssid = await networkInfo.getWifiBSSID();

  Map<String, dynamic> map = {"ip": ip, "ssid": ssid};
  return map;
}

Future<Map<String, dynamic>> getIPAddressByMobile() async {
  final url = Uri.parse('https://api.ipify.org');
  final response = await http.get(url);
  var ip = response.body;
  Map<String, dynamic> map = {"ip": ip, "ssid": ""};
  return map;
}

// // ip 설정 ( wifi or mobile (lte, 5G 등 ) )
//   Future<StreamSubscription> initIp() async {
//     Connectivity().checkConnectivity().then((result) {
//       if (result == ConnectivityResult.mobile) {
//         getIPAddressByMobile().then((map) {
//           Env.DEVICE_IP = map["ip"];
//         });
//       } else if (result == ConnectivityResult.wifi) {
//         getIPAddressByWifi().then((map) {
//           Env.DEVICE_IP = map["ip"];
//         });
//       }
//     });

//     return Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.mobile) {
//         getIPAddressByMobile().then((map) {
//           Log.log(' mobile ip address = ${map["ip"]}');
//           Env.DEVICE_IP = map["ip"];
//         });
//       } else if (result == ConnectivityResult.wifi) {
//         getIPAddressByWifi().then((map) {
//           Log.log(' wifi ip address = ${map["ip"]}');
//           Env.DEVICE_IP = map["ip"];
//         });
//       }
//     });
//   }

String getSignature(String serviceId, String timeStamp, String accessKey, String secretKey) {
  var space = " "; // one space
  var newLine = "\n"; // new line
  var method = "POST"; // method
  var url = "/sms/v2/services/$serviceId/messages";

  var buffer = StringBuffer();
  buffer.write(method);
  buffer.write(space);
  buffer.write(url);
  buffer.write(newLine);
  buffer.write(timeStamp);
  buffer.write(newLine);
  buffer.write(accessKey);
  Log.debug("StringBuffer : ${buffer.toString()}");

  /// signing key
  var key = utf8.encode(secretKey);
  var signingKey = Hmac(sha256, key);

  var bytes = utf8.encode(buffer.toString());
  var digest = signingKey.convert(bytes);
  String signatureKey = base64.encode(digest.bytes);
  Log.debug(signatureKey);
  return signatureKey;
}

Future<int> sendSMS(String phoneNumber) async {
  var verifyNum = Random().nextInt(1000000);
  var timestamp = (DateTime.now().millisecondsSinceEpoch).toString();
  Log.debug("send SMS phone number : $phoneNumber");

  Map data = {
    "type": "SMS",
    "contentType": "COMM",
    "countryCode": "82",
    "from": "01079297878",
    "content": "ABCD",
    "messages": [
      {"to": phoneNumber, "content": "인증번호 [$verifyNum]를 입력해주세요."}
    ],
  };

  var url = Uri.https("sens.apigw.ntruss.com", '/sms/v2/services/${Env.NAVER_SERVICE_ID}/messages');
  Log.debug("url : $url");
  Log.debug("response : ${data.toString()}");

  var result = await http
      .post(url,
          headers: <String, String>{
            "accept": "application/json",
            'content-Type': 'application/json; charset=UTF-8',
            'x-ncp-apigw-timestamp': timestamp,
            'x-ncp-iam-access-key': Env.NAVER_ACCESS_KEY,
            'x-ncp-apigw-signature-v2': getSignature(Env.NAVER_SERVICE_ID, timestamp, Env.NAVER_ACCESS_KEY, Env.NAVER_SECRET_KEY)
          },
          body: json.encode(data))
      .then((res) {
    Log.debug("response : ${res.statusCode}");
  });
  // Log.debug("result : ${result.body}");
  return verifyNum;
}
