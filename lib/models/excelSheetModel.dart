import 'package:e9pass_manager/models/certModel.dart';
import 'package:e9pass_manager/models/pdfModel.dart';

class ZipResult {
  String applicationNumber;
  String arcNumber;
  String userName;
  String passStatu;
  DateTime dateTime;
  Certificate certificate;
  PdfFile pdfFile;
  bool ziped;

  ZipResult({
    this.applicationNumber,
    this.arcNumber,
    this.userName,
    this.passStatu,
    this.dateTime,
    this.certificate,
    this.pdfFile,
    this.ziped = false,
  });

  @override
  String toString() {
    return userName;
  }
}

class SheetColumn {
  String title;
  int index;

  SheetColumn({
    this.title,
    this.index
  });
}