import 'package:e9pass_manager/models/fileModel.dart';

class Certificate {
  String name;
  String path;
  List<MyFile> files;
  bool selected;

  Certificate({
    this.name,
    this.path,
    this.files,
    this.selected = false
  });

  @override
  String toString() {
    return this.name != null ? this.name : 'Not Found';
  }
}