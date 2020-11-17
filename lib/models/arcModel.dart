import 'dart:io';

import 'dart:typed_data';

class ArcImage {
  Uint8List bytes;
  bool raw;
  String name;
  String arcNumber;

  ArcImage({
    this.bytes,
    this.raw,
    this.arcNumber,
    this.name
  });
}