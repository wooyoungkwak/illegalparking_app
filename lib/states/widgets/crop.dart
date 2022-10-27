import 'dart:io';

import 'package:camera/camera.dart';
// ignore: depend_on_referenced_packages
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/services/save_image_service.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_camera_description.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_inside_line_direction.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_inside_line_position.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_border_type.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_inside_line.dart';
import 'package:mask_for_camera_view/crop_image.dart';

CameraController? controller;
List<CameraDescription>? _cameras = Env.CAMERA_SETTING;
// GlobalKey _stickyKey = GlobalKey();
double? _screenWidth;
double? _screenHeight;
double? _boxWidthForCrop;
double? _boxHeightForCrop;

// ignore: must_be_immutable
class MaskForCameraCustomView extends StatefulWidget {
  MaskForCameraCustomView(
      {super.key,
      this.boxWidth = 300.0,
      this.boxHeight = 168.0,
      this.boxBorderWidth = 5,
      this.boxBorderRadius = 7,
      required this.onTake,
      this.cameraDescription = MaskForCameraViewCameraDescription.rear,
      this.borderType = MaskForCameraViewBorderType.solid,
      this.insideLine,
      this.appBarColor = Colors.black,
      this.boxBorderColor = Colors.black,
      this.takeButtonColor = Colors.white,
      this.takeButtonActionColor = Colors.black,
      this.backColor = Colors.black54,
      this.type = true, // 카메라 타입 [true:번호판,false:차량]
      this.btomhighbtn = 80});

  double boxWidth;
  double boxHeight;
  double boxBorderWidth;
  double boxBorderRadius;
  double btomhighbtn;

  MaskForCameraViewCameraDescription cameraDescription;
  MaskForCameraViewInsideLine? insideLine;
  Color appBarColor;
  Color boxBorderColor;
  Color takeButtonColor;
  Color takeButtonActionColor;
  Color backColor;
  ValueSetter<MaskForCameraViewResult> onTake;
  MaskForCameraViewBorderType borderType;
  bool type;
  @override
  State<StatefulWidget> createState() => _MaskForCameraCustomViewState();

  // static Future<void> initialize() async {
  //   _cameras = await availableCameras();
  // }
}

class _MaskForCameraCustomViewState extends State<MaskForCameraCustomView> with WidgetsBindingObserver {
  bool isRunning = false;

  @override
  void initState() {
    try {
      controller = CameraController(
        widget.cameraDescription == MaskForCameraViewCameraDescription.rear ? _cameras!.first : _cameras!.last,
        ResolutionPreset.high,
        enableAudio: false,
      );

      controller!.initialize().then((_) async {
        if (!mounted) {
          return;
        }
        // await controller!.setFlashMode(FlashMode.off);
        setState(() {});
      });
    } catch (e) {
      throw Exception("카메라 에러");
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    // MaskForCameraCustomView.initialize();
    // Log.debug("카메라종료###########");
    // controller!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // controller!.setFlashMode(FlashMode.auto);
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    _boxWidthForCrop = widget.boxWidth;
    _boxHeightForCrop = widget.boxHeight;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Container(
          //   child: !controller!.value.isInitialized
          //       ? Container()
          //       : SizedBox(
          //           height: 600,
          //           child: CameraPreview(
          //             controller!,
          //           ),
          //         ),
          // ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: !controller!.value.isInitialized
                ? Container()
                : SizedBox(
                    child: CameraPreview(
                      controller!,
                    ),
                  ),
          ),
          ColorFiltered(
            colorFilter: ColorFilter.mode(widget.backColor, BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxWidth + widget.boxBorderWidth * 2 : widget.boxWidth,
                      height: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxHeight + widget.boxBorderWidth * 2 : widget.boxHeight,
                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: DottedBorder(
                borderType: BorderType.RRect,
                strokeWidth: widget.borderType == MaskForCameraViewBorderType.dotted ? widget.boxBorderWidth : 0.0,
                color: widget.borderType == MaskForCameraViewBorderType.dotted ? widget.boxBorderColor : Colors.transparent,
                dashPattern: const [4, 3],
                radius: Radius.circular(
                  widget.boxBorderRadius,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isRunning ? Colors.white60 : Colors.transparent,
                    borderRadius: BorderRadius.circular(widget.boxBorderRadius),
                  ),
                  child: Container(
                    width: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxWidth + widget.boxBorderWidth * 2 : widget.boxWidth,
                    height: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxHeight + widget.boxBorderWidth * 2 : widget.boxHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxBorderWidth : 0.0,
                        // color: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxBorderColor : Colors.transparent,
                        color: widget.borderType == MaskForCameraViewBorderType.solid ? widget.boxBorderColor : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(
                        widget.boxBorderRadius,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: widget.insideLine != null && widget.insideLine!.direction == null ||
                                  widget.insideLine != null && widget.insideLine!.direction == MaskForCameraViewInsideLineDirection.horizontal
                              ? ((widget.boxHeight / 10) * _position(widget.insideLine!.position))
                              : 0.0,
                          left: widget.insideLine != null && widget.insideLine!.direction == MaskForCameraViewInsideLineDirection.vertical
                              ? ((widget.boxWidth / 10) * _position(widget.insideLine!.position))
                              : 0.0,
                          child: widget.insideLine != null ? _Line(widget) : Container(),
                        ),
                        Positioned(
                          child: _IsCropping(isRunning: isRunning, widget: widget),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            // bottom: widget.boxHeight > 150 ? 80 : 145,
            top: widget.btomhighbtn,
            // bottom: widget.boxHeight > 150 ? 80 : 145,
            left: 0,
            right: 0,

            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: widget.appBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.takeButtonColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: widget.takeButtonActionColor.withOpacity(0.26),
                            onTap: () async {
                              if (isRunning) {
                                return;
                              }
                              setState(() {
                                isRunning = true;
                              });
                              MaskForCameraViewResult? res = await _cropPicture(widget.insideLine);
                              if (res == null) {
                                throw "Camera expansion is very small";
                              }
                              await saveImageDirectory(res, widget.type).then((value) => widget.onTake(res)); // 저장 type 값에 따라 저장하는 변수가 바뀜

                              setState(() {
                                isRunning = false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: widget.takeButtonActionColor,
                                ),
                              ),
                              // child: Icon(
                              //   Icons.camera_alt_outlined,
                              //   color: widget.takeButtonActionColor,
                              // ),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 2,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      Env.CAMERA_SETTING!.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    // await cameraController.setFlashMode(FlashMode.off);

    controller = cameraController;

    //중요... 컨트롤러 업데이트 되면 화면 변경해주는 기능..
    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        alertDialogByonebutton("카메라에러", "'Camera error ${cameraController.value.errorDescription}'");
      }
    });
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          alertDialogByonebutton("카메라에러", "You have denied camera access.");

          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          alertDialogByonebutton("카메라에러", "Please go to Settings app to enable camera access.");

          break;
        case 'CameraAccessRestricted':
          // iOS only
          alertDialogByonebutton("카메라에러", "Camera access is restricted.");
          break;
        case 'AudioAccessDenied':
          alertDialogByonebutton("카메라에러", "You have denied audio access.");
          ('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          alertDialogByonebutton("카메라에러", "Please go to Settings app to enable audio access.");
          break;
        case 'AudioAccessRestricted':
          // iOS only
          alertDialogByonebutton("카메라에러", "Audio access is restricted.");
          break;
        default:
          alertDialogByonebutton("카메라에러", "Camera error $e");

          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }
}

Future<MaskForCameraViewResult?> _cropPicture(MaskForCameraViewInsideLine? insideLine) async {
  XFile xFile = await controller!.takePicture();
  File imageFile = File(xFile.path);
  // 원래 위 아래  appbar 사이즈 계산하던 변수
  // RenderBox box =  _stickyKey.currentContext!.findRenderObject() as RenderBox: ;
  // double size = box.size.height * 2;
  MaskForCameraViewResult? result = await cropImage(
    imageFile.path,
    _boxHeightForCrop!.toInt(),
    _boxWidthForCrop!.toInt(),
    // _screenHeight! - size,
    _screenHeight!,
    _screenWidth!,
    insideLine,
  );
  return result;
}

// Line inside box

class _Line extends StatelessWidget {
  const _Line(this.widget, {Key? key}) : super(key: key);
  final MaskForCameraCustomView widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.insideLine!.direction == null || widget.insideLine!.direction == MaskForCameraViewInsideLineDirection.horizontal ? widget.boxWidth : widget.boxBorderWidth,
      height: widget.insideLine!.direction != null && widget.insideLine!.direction == MaskForCameraViewInsideLineDirection.vertical ? widget.boxHeight : widget.boxBorderWidth,
      color: widget.boxBorderColor,
    );
  }
}

// Progress widget. Used during cropping.

class _IsCropping extends StatelessWidget {
  const _IsCropping({Key? key, required this.isRunning, required this.widget}) : super(key: key);
  final bool isRunning;
  final MaskForCameraCustomView widget;

  @override
  Widget build(BuildContext context) {
    return isRunning && widget.boxWidth >= 50.0 && widget.boxHeight >= 50.0
        ? const Center(
            child: CupertinoActivityIndicator(
              radius: 12.8,
            ),
          )
        : Container();
  }
}

// To get position index for crop

int _position(MaskForCameraViewInsideLinePosition? position) {
  int p = 5;
  if (position != null) {
    p = position.index + 1;
  }
  return p;
}

void cameradispose() {
  controller!.dispose();
}
