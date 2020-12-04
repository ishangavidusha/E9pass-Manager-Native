import 'package:e9pass_manager/service/image_servise.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:provider/provider.dart';

class ImageEditView extends StatefulWidget {
  @override
  _ImageEditViewState createState() => _ImageEditViewState();
}

class _ImageEditViewState extends State<ImageEditView> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerArc = TextEditingController();
  ImageService _imageService;
  bool _cropping = false;
  double widthValue;
  int fistbuild = 1;

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    setState(() {
      _cropping = true;
    });
    Rect cropRect = editorKey.currentState.getCropRect();
    _imageService.crop(cropRect.left.toInt(), cropRect.top.toInt(), cropRect.width.toInt(), cropRect.height.toInt());
    setState(() {
      _cropping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    _imageService = Provider.of<ImageService>(context);
    widthValue ??= _imageService.width.toDouble() ?? 0.0;
    if (fistbuild == 1) {
      textEditingControllerName.value = TextEditingValue(text: _imageService.name);
      textEditingControllerArc.value = TextEditingValue(text: _imageService.arc);
      fistbuild++;
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: KeyBoardShortcuts(
          keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyR},
          onKeysPressed: () {
            _imageService.rotate(90);
          },
          child: Stack(
            children: [
              ExtendedImage.memory(
                _imageService.getImage(),
                fit: BoxFit.contain,
                mode: ExtendedImageMode.editor,
                enableLoadState: true,
                extendedImageEditorKey: editorKey,
                initEditorConfigHandler: (ExtendedImageState state) {
                  return EditorConfig(
                    maxScale: 8.0,
                    cropRectPadding: EdgeInsets.fromLTRB(20, 20, 20, 160),
                    hitTestSize: 20.0,
                    initCropRectType: InitCropRectType.imageRect,
                    cropAspectRatio: CropAspectRatios.custom,
                    cornerPainter: ExtendedImageCropLayerPainterCircleCorner(color: Colors.blue, radius: 10.0)
                  );
                },
              ),
              Positioned(
                bottom: 0,
                width: devWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: devWidth * 0.3,
                          padding: EdgeInsets.all(20),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.red[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                              thumbColor: Colors.redAccent,
                              overlayColor: Colors.red.withAlpha(32),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.red[700],
                              inactiveTickMarkColor: Colors.red[100],
                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.redAccent,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              min: 0.0,
                              max: _imageService.width.toDouble() * 2,
                              value: widthValue,
                              divisions: 50,
                              onChangeEnd: (value) async {
                                Map<String, dynamic> result = await _imageService.resize(value.toInt(), _imageService.height);
                                setState(() {
                                  widthValue = result['width'];
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  widthValue = value;
                                });
                              },
                              label: '${_imageService.width}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: devWidth * 0.3,
                          child: TextField(
                            controller: textEditingControllerArc,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.textColor, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.secondTextColor, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.textColor, width: 2.0),
                              ),
                              labelText: 'Arc Number',
                              labelStyle: TextStyle(
                                color: AppColors.secondTextColor
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: devWidth * 0.3,
                          child: TextField(
                            controller: textEditingControllerName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.textColor, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.secondTextColor, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.textColor, width: 2.0),
                              ),
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: AppColors.secondTextColor
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              _imageService.rotate(90);
                            },
                            color: AppColors.btColor,
                            child: Row(
                              children: [
                                Icon(Icons.rotate_right, color: Colors.white,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Rotate Right',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              _imageService.rotate(-90);
                            },
                            color: AppColors.btColor,
                            child: Row(
                              children: [
                                Icon(Icons.rotate_left, color: Colors.white,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Rotate Left',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              cropImage();
                            },
                            color: AppColors.btColor,
                            child: Row(
                              children: [
                                Icon(Icons.rotate_left, color: Colors.white,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Crop',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              _imageService.resetEdits();
                            },
                            color: AppColors.btColor,
                            child: Row(
                              children: [
                                Icon(Icons.restore, color: Colors.white,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Reset Image',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              _imageService.resetEdits();
                              Navigator.pop(context, false);
                            },
                            color: AppColors.btColor,
                            child: Row(
                              children: [
                                Icon(Icons.cancel, color: Colors.white,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _imageService.onNameChange(textEditingControllerName.text);
                              _imageService.onArcChange(textEditingControllerArc.text);
                              Navigator.pop(context, true);
                            },
                            color: AppColors.btColor,
                            child: Row(
                              children: [
                                Icon(Icons.save, color: Colors.white,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}