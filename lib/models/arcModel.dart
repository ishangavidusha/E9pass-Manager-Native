import 'dart:io';
import 'dart:typed_data';

import 'package:e9pass_manager/models/erroeModel.dart';

class ArcImage {
  Uint8List bytes;
  File file;
  bool raw;
  String fileName;
  String name;
  String arcNumber;

  ArcImage({
    this.bytes,
    this.file,
    this.raw,
    this.fileName,
    this.arcNumber,
    this.name
  });

  Future<bool> save() async {
    try {
      await file.writeAsBytes(bytes);
    } catch (e) {
      throw ErrorMsg(e: e, eMsg: 'Unable to save image!');
    }
    return true;
  }

  @override
  String toString() {
    return this.fileName ?? 'File Name Not Found';
  }
}