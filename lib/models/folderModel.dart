
import 'package:e9pass_manager/models/enums.dart';

class MyFolder {
  final String path;
  final String name;
  bool selected;

  // Wheather File or Directory

  final FileType type;

  MyFolder({this.path, this.name, this.type, this.selected: false});

  @override
  String toString() {
    return this.name != null ? this.name : 'Not Found';
  }
}