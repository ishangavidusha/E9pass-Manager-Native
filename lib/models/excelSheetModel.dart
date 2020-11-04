import 'package:e9pass_manager/models/certModel.dart';

class ExcelSheet {
  String sheetName;
  String sheetPath;
  List<SheetColumn> coloums;
  List<String> applicationNumbers;
  List<String> arcNumber;
  List<String> userNames;
  List<String> passStatus;
  List<DateTime> dateTimes;
  List<Certificate> certificates;
  List<String> pdfFilePaths;

  ExcelSheet({
    this.sheetName,
    this.sheetPath,
    this.applicationNumbers,
    this.arcNumber,
    this.userNames,
    this.passStatus,
    this.dateTimes,
    this.certificates,
    this.pdfFilePaths,
  });

  @override
  String toString() {
    return sheetName;
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