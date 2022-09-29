import 'dart:io';
import '../controllers/address_controller.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:path_provider/path_provider.dart';

final ReactiveController c = Get.put(ReactiveController());

Future<void> saveImageDirectory(MaskForCameraViewResult res, bool part) async {
  var tempDir = await getTemporaryDirectory();
  final myImagePath = "${tempDir.path}/${DateTime.now()}";
  File imageFile = File(myImagePath);
  if (!await imageFile.exists()) {
    imageFile.create(recursive: true);
  }
  imageFile.writeAsBytes(res.croppedImage!);

  if (part) {
    c.part_Image_write(myImagePath);
    c.part_Image_Memory_writ(res.croppedImage!);
  } else {
    c.whole_Image_write(myImagePath);
    c.whole_Image_Memory_writ(res.croppedImage!);
  }
}

Future<void> saveImageGallery() async {
  ImageGallerySaver.saveImage(c.whole_Image_Memory);
  ImageGallerySaver.saveImage(c.part_Image_Memory);
}
