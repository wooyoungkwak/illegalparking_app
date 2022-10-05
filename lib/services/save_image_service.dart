import 'dart:io';
import '../controllers/address_controller.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/time_util.dart';

final ReactiveController c = Get.put(ReactiveController());
String partImagename = "";
String wholeImagename = "";

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
    c.partImagewrite(myImagePath);
    c.partImageMemorywrit(res.croppedImage!);
    partImagename = nametime;
  } else {
    c.wholeImagewrite(myImagePath);
    c.wholeImageMemorywrit(res.croppedImage!);
    wholeImagename = nametime;
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
  ImageGallerySaver.saveImage(c.wholeImageMemory, name: wholeImagename);
  ImageGallerySaver.saveImage(c.partImageMemory, name: partImagename);
}
