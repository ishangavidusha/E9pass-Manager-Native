
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
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
        final appNumber = getAppNumber(p.split(fileSystemEntity.absolute.path).last);
        if (appNumber != null) {
          pdfFiles.add(
            PdfFile(
              appNumber: appNumber,
              path: fileSystemEntity.absolute.path,
            )
          );
        }
      }
    }
  });
  return pdfFiles;
}

String getAppNumber(String fileName) {
  String name = fileName.split('.').first;
  RegExp regExp = RegExp(r'(20\d{4})-(\d{4})-(\d{4})');
  if (regExp.hasMatch(name)) {
    Match match = regExp.firstMatch(name);
    return name.substring(match.start, match.end);
  } else {
    return null;
  }
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

bool addToArchive(Map<String, dynamic> data) {
  ZipFileEncoder zipFileEncoder = ZipFileEncoder();
  ZipResult zipResult = data['data'];
  String path = data['path'];
  zipFileEncoder.create(p.join(path, '${zipResult.arcNumber}.zip'));
  zipFileEncoder.addDirectory(Directory(zipResult.certificate.path)); // Problem is here
  if (zipResult.pdfFile != null) {
    zipFileEncoder.addFile(File(zipResult.pdfFile.path));
  }
  zipFileEncoder.close();
  return true;
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
  List<ZipResult> zipResult = List();
  bool loading = false;
  bool ziping = false;
  String zipingStatus = '';
  String loadingStatus = '';

  Future<bool> getCertificateFiles() async {
    certificateFiles.clear();
    pdfFiles.clear();
    loading = true;
    notifyListeners();
    try {
      loadingStatus = 'Searching Certificate Folder, Please Wait...';
      notifyListeners();
      final fileSystemEntityList = await compute(readDir, certificateFolder);
      certificateFiles.addAll(await compute(processCertificate, fileSystemEntityList));
      loadingStatus = '${certificateFiles.length} Certificates Found.\nSearching PDF Folder, Please Wait...';
      notifyListeners();
      pdfFiles.addAll(await compute(processPdf, pdfFolder));
      loadingStatus = '${pdfFiles.length} PDFs Found.\nMatching Data, Please Wait...';
      notifyListeners();
      await matchData();
      loadingStatus = '';
      loading = false;
      notifyListeners();
      return true;
    } on FileSystemException catch (e) {
      print(e);
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future zipAllFiles() async {
    ziping = true;
    notifyListeners();
    FileChooserResult fileChooserResult = await showOpenPanel(
      canSelectDirectories: true,
    );
    if (!fileChooserResult.canceled) {
      for (var i = 0; i < zipResult.length; i++) {
        if (zipResult[i].certificate != null) {
          Map<String, dynamic> data = {'path' : fileChooserResult.paths[0], 'data' : zipResult[i]};
          bool result = await compute(addToArchive, data);
          print(zipResult[i].userName);
          zipingStatus = zipResult[i].userName;
          notifyListeners();
        }
      }
    }
    ziping = false;
    zipingStatus = '';
    notifyListeners();
  }

  Future<bool> matchData() async {
    zipResult.clear();
    Sheet sheet = excelFile.sheets['${excelFile.sheets.keys.first}'];
    await Future.forEach(sheet.rows, (element) async {
      zipResult.add(ZipResult(
        applicationNumber: element[sheetMap.applicationNumber.index].toString(),
        arcNumber: element[sheetMap.arcNumber.index].toString(),
        userName: element[sheetMap.userName.index].toString(),
        certificate: await findCertificate(element[sheetMap.userName.index].toString()),
        pdfFile: await findPdf(element[sheetMap.applicationNumber.index].toString()),
      ));
    });
    if (zipResult.length > 0) {
      print(zipResult[0]);
      zipResult.removeAt(0);
    }
    return true;
  }

  Future<Certificate> findCertificate(String value) async {
    return certificateFiles.firstWhere((element) => element.name.compareTo(value) == 0, orElse: () => null);
  }

  Future<PdfFile> findPdf(String value) async {
    return pdfFiles.firstWhere((element) => element.appNumber.compareTo(value) == 0, orElse: () => null);
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