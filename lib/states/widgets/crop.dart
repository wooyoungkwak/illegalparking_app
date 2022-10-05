import 'dart:io';

import 'package:camera/camera.dart';
// ignore: depend_on_referenced_packages
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_camera_description.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_inside_line_direction.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_inside_line_position.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_border_type.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_inside_line.dart';
import 'package:mask_for_camera_view/crop_image.dart';

CameraController? _cameraController;
List<CameraDescription>? _cameras;
// GlobalKey _stickyKey = GlobalKey();
double? _screenWidth;
double? _screenHeight;
double? _boxWidthForCrop;
double? _boxHeightForCrop;

FlashMode _flashMode = FlashMode.off;

// ignore: must_be_immutable
class MaskForCameraCustomView extends StatefulWidget {
  MaskForCameraCustomView({
    super.key,
    this.boxWidth = 300.0,
    this.boxHeight = 168.0,
    this.boxBorderWidth = 1.8,
    this.boxBorderRadius = 3.2,
    required this.onTake,
    this.cameraDescription = MaskForCameraViewCameraDescription.rear,
    this.borderType = MaskForCameraViewBorderType.solid,
    this.insideLine,
    this.appBarColor = Colors.black,
    this.boxBorderColor = Colors.white,
    this.takeButtonColor = Colors.white,
    this.takeButtonActionColor = Colors.black,
    this.backColor = Colors.black54,
  });

  double boxWidth;
  double boxHeight;
  double boxBorderWidth;
  double boxBorderRadius;

  MaskForCameraViewCameraDescription cameraDescription;
  MaskForCameraViewInsideLine? insideLine;
  Color appBarColor;
  Color boxBorderColor;
  Color takeButtonColor;
  Color takeButtonActionColor;
  Color backColor;
  ValueSetter<MaskForCameraViewResult> onTake;
  MaskForCameraViewBorderType borderType;
  @override
  State<StatefulWidget> createState() => _MaskForCameraCustomViewState();

  static Future<void> initialize() async {
    _cameras = await availableCameras();
  }
}

class _MaskForCameraCustomViewState extends State<MaskForCameraCustomView> {
  bool isRunning = false;

  @override
  void initState() {
    _cameraController = CameraController(
      widget.cameraDescription == MaskForCameraViewCameraDescription.rear ? _cameras!.first : _cameras!.last,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _cameraController?.setFlashMode(_flashMode);
    super.initState();
    _cameraController!.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    _boxWidthForCrop = widget.boxWidth;
    _boxHeightForCrop = widget.boxHeight;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: !_cameraController!.value.isInitialized
                  ? Container()
                  : SizedBox(
                      child: CameraPreview(
                        _cameraController!,
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
              bottom: widget.boxHeight > 150 ? 80 : 145,
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
                                widget.onTake(res);
                                setState(() {
                                  isRunning = false;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(1.8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2.0,
                                    color: widget.takeButtonActionColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: widget.takeButtonActionColor,
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
          ],
        ),
      ),
    );
  }
}

Future<MaskForCameraViewResult?> _cropPicture(MaskForCameraViewInsideLine? insideLine) async {
  XFile xFile = await _cameraController!.takePicture();
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

///
///
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

///
///
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

///
///
// To get position index for crop

int _position(MaskForCameraViewInsideLinePosition? position) {
  int p = 5;
  if (position != null) {
    p = position.index + 1;
  }
  return p;
}
