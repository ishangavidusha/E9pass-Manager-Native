
import 'package:e9pass_manager/models/enums.dart';

class MyFile {
  final String path;
  final String name;
  bool selected;
  final extension;

  // Wheather it's a directory or a file.
  final FileType type;

  MyFile({this.path, this.name, this.type, this.selected: false, this.extension});

  @override
  String toString() {
    return this.name != null ? this.name : 'Not Found';
  }
}