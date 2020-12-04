import 'dart:typed_data';
import 'package:e9pass_manager/models/arcModel.dart';
import 'package:e9pass_manager/models/erroeModel.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as im;
import 'package:flutter/material.dart';

im.Image readImage(ArcImage arcImage) {
  im.Image image = im.decodeImage(arcImage.bytes);
  image = im.bakeOrientation(image);
  return image;
}

im.Image rotateEngin(Map<String, dynamic> data) {
  im.Image image = data['image'];
  num angle = data['angle'];
  image = im.bakeOrientation(im.copyRotate(image, angle));
  return image;
}

im.Image resizeEngin(Map<String, dynamic> data) {
  im.Image image = im.copyResize(data['image'], width: data['width'], height: data['height']);
  return im.bakeOrientation(image);
}

class ImageService with ChangeNotifier {
  im.Image _image;
  im.Image _original;
  String _name;
  String _arc;
  int _width;
  int _height;
  bool _loading = false;

  Future<bool> setImage(ArcImage arcImage) async {
    try {
      _original = await compute(readImage, arcImage);
      _original = _original.width > 1000 ? await compute(resizeEngin, {'image' : _original, 'width' : 1000, 'height' : null}) : _original;
      _name = arcImage.name;
      _arc = arcImage.arcNumber;
      _image = _original;
      _width = _image.width;
      _height = _image.height;
      notifyListeners();
      return true;
    } catch (e) {
      throw ErrorMsg(e: e, eMsg: 'Unable to open image ${arcImage.toString()}');
    }
  }

  int get width => _width == null ? 0 : _width;
  int get height => _height == null ? 0 : _height;
  bool get loading => _loading;
  String get name => _name == null ? '' : _name;
  String get arc => _arc == null ? '' : _arc;

  void onNameChange(String name) {
    _name = name;
    notifyListeners();
  }

  void onArcChange(String arc) {
    _arc = arc;
    notifyListeners();
  }

  Uint8List getImage() {
    return im.encodeJpg(_image);
  }

  Uint8List getOriginal() {
    return im.encodeJpg(_original);
  }

  void resetEdits() {
    working(true);
    _image = _original;
    _image = im.bakeOrientation(_image);
    working(false);
  }

  void clear() {
    working(true);
    _image = null;
    _image = null;
    _name = null;
    _arc = null;
    working(false);
  }

  Future<Map<String, dynamic>> resize(int width, int height) async {
    working(true);
    _image = await compute(resizeEngin, {'image' : _image, 'width' : width, 'height' : height});
    _width = _image.width;
    _height = _image.height;
    working(false);
    return { "width" : _width.toDouble(), "height" : _height.toDouble()};
  }

  void rotate(num angle) async {
    working(true);
    _image = await compute(rotateEngin, {'image': _image, 'angle' : angle});
    _width = _image.width;
    _height = _image.height;
    working(false);
  }

  void crop(int x, int y, int width, int height) {
    working(true);
    _image = im.copyCrop(_image, x, y, width, height);
    _image = im.bakeOrientation(_image);
    _width = _image.width;
    _height = _image.height;
    working(false);
  }

  void working(bool value) {
    if (value == true) {
      _loading = true;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

}