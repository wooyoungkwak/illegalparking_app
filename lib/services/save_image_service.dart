import 'dart:io';

import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:path_provider/path_provider.dart';

final ReportController c = Get.put(ReportController());
String carnumberImagename = "";
String carreportnumberImage = "";
final ReportController controller = Get.put(ReportController());

Future<void> saveImageDirectory(MaskForCameraViewResult res, bool part) async {
  String nametime = getDateToStringForNumber();
  var tempDir = await getTemporaryDirectory();
  final myImagePath = "${tempDir.path}/$nametime";
  File imageFile = File(myImagePath);
  if (!await imageFile.exists()) {
    imageFile.create(recursive: true);
  }
  imageFile.writeAsBytes(res.croppedImage!);

  if (part) {
    c.carnumberImagewrite(myImagePath);
    c.carnumberImageMemorywrit(res.croppedImage!);
    carnumberImagename = nametime;
    controller.carnumfileNamewrite("$carnumberImagename.jpg");
    Log.debug("$carnumberImagename.jpg");
  } else {
    c.carreportImagewrite(myImagePath);
    c.reportImageMemorywrit(res.croppedImage!);
    carreportnumberImage = nametime;
    controller.reportfileNamewrite("$carreportnumberImage.jpg");
    Log.debug("$carreportnumberImage.jpg");
  }
  //myImagePath
  //20221004152932789426 저장된 파일이름
  //res.croppedImage
  //1568496765 이름이 다름

  //이미지가 2개인 이유
  //한개는 상태관리하는 UI용 이미지
  //한개는 임시 저장했다가 갤러리에 저장하는 용도의 이미지
}

Future<void> saveImageGallery() async {
  ImageGallerySaver.saveImage(c.reportImageMemory, name: carreportnumberImage);
  ImageGallerySaver.saveImage(c.carnumberImageMemory, name: carnumberImagename);
}
