
import 'dart:io';
import 'package:e9pass_manager/models/certModel.dart';
import 'package:e9pass_manager/models/enums.dart';
import 'package:e9pass_manager/models/excelSheetModel.dart';
import 'package:e9pass_manager/models/fileModel.dart';
import 'package:e9pass_manager/models/pdfModel.dart';
import 'package:excel/excel.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

Excel readExcelFile(String path) {
  final bytes = File(path).readAsBytesSync();
  Excel excel = Excel.decodeBytes(bytes);
  return excel;
}

List<PdfFile> processPdf(String path) {
  List<FileSystemEntity> fileSystemEntityList = Directory(path).listSync(recursive: true).toList();
  List<PdfFile> pdfFiles = List();
  fileSystemEntityList.forEach((FileSystemEntity fileSystemEntity) {
    if (FileSystemEntity.isFileSync(fileSystemEntity.path)) {
      if (p.split(fileSystemEntity.absolute.path).last.split('.').last == 'pdf') {
        pdfFiles.add(
          PdfFile(
            appNumber: getAppNumber(p.split(fileSystemEntity.absolute.path).last),
            path: fileSystemEntity.absolute.path,
          )
        );
      }
    }
  });
}

String getAppNumber(String fileName) {
  String name = fileName.split('.').first;
  
}

List<FileSystemEntity> readDir(String path) {
  return Directory(path).listSync(recursive: true).toList();
}

List<Certificate> processCertificate(List<FileSystemEntity> fileSystemEntityList) {
  List<Certificate> certificateFiles = List();
  fileSystemEntityList.forEach((FileSystemEntity fileSystemEntity) {
    if (FileSystemEntity.isDirectorySync(fileSystemEntity.path)) {
      if (p.split(fileSystemEntity.absolute.path).last.contains('ou=RA센터,ou=e9pay,ou=등록기관,ou=licensedCA,o=KICA,c=KR')) {
        final certFiles = Directory(fileSystemEntity.absolute.path).listSync(recursive: true).toList();
        final files = certFiles.map((element) => MyFile(
          name: p.split(element.absolute.path).last,
          path: element.absolute.path,
          type: FileType.File,
        )).toList();
        certificateFiles.add(
          Certificate(
            name: getCertName(p.split(fileSystemEntity.absolute.path).last),
            path: fileSystemEntity.absolute.path,
            files: files
          )
        );
      }
    }
  });
  return certificateFiles;
}

String getCertName(String folderName) {
  return folderName.split(',').first.split('=').elementAt(1);
}

class ZipService with ChangeNotifier {
  String excelFilePath;
  String certificateFolder;
  String pdfFolder;
  bool readingFile = false;
  Excel excelFile;
  List<SheetColumn> columnToSelect = List();
  SheetMap sheetMap;
  List<Certificate> certificateFiles = List();
  List<PdfFile> pdfFiles = List();

  Future<bool> getCertificateFiles() async {
    certificateFiles.clear();
    try {
      final fileSystemEntityList = await compute(readDir, certificateFolder);
      certificateFiles.addAll(await compute(processCertificate, fileSystemEntityList));
      return true;
    } on FileSystemException catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> getPdfFiles() async {
    pdfFiles.clear();

  }

  void setSheetMap(int value, SheetColumn sheetColumn) {
    if (value == 1) {
      sheetMap.applicationNumber = sheetColumn;
    } else if (value == 2) {
      sheetMap.arcNumber = sheetColumn;
    } else if (value == 3) {
      sheetMap.userName = sheetColumn;
    }
    notifyListeners();
  }

  Future<bool> getFolderPath(bool pdfPath) async {
    FileChooserResult fileChooserResult = await showOpenPanel(
      canSelectDirectories: true,
    );
    if (fileChooserResult.canceled != true) {
      print(fileChooserResult.paths);
      if (pdfPath) {
        pdfFolder = fileChooserResult.paths[0];
      } else {
        certificateFolder = fileChooserResult.paths[0];
      }
      notifyListeners();
      return true;
    } else {
      if (pdfPath) {
        pdfFolder = null;
      } else {
        certificateFolder = null;
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> getExcelFilePath() async {
    clearExcelData();
    FileChooserResult fileChooserResult = await showOpenPanel(
      allowsMultipleSelection: false,
      allowedFileTypes: <FileTypeFilterGroup> [
        FileTypeFilterGroup(
          label: 'Excel',
          fileExtensions: <String> [
            'xlsx',
          ]
        )
      ]
    );
    if (fileChooserResult.canceled != true) {
      excelFilePath = fileChooserResult.paths[0];
      excelFile = await compute(readExcelFile, excelFilePath);
      Sheet sheet = excelFile.sheets['${excelFile.sheets.keys.first}'];
      sheet.rows.first.forEach((element) {
        columnToSelect.add(
          SheetColumn(
            index: sheet.rows.first.indexOf(element),
            title: element.toString(),
          )
        );
      });
      sheetMap = SheetMap(
        applicationNumber: columnToSelect.first,
        arcNumber: columnToSelect.first,
        userName: columnToSelect.first
      );
      notifyListeners();
      return true;
    } else {
      print('File Not Selected');
      notifyListeners();
      return false;
    }
  }

  void clearExcelData() {
    excelFilePath = null;
    certificateFolder = null;
    pdfFolder = null;
    excelFile = null;
    columnToSelect.clear();
    sheetMap = null;
    notifyListeners();
  }
}

class SheetMap {
  SheetColumn applicationNumber;
  SheetColumn arcNumber;
  SheetColumn userName;

  SheetMap({
    this.applicationNumber,
    this.arcNumber,
    this.userName
  });
}