import 'dart:io';
import 'dart:typed_data';
import 'package:e9pass_manager/models/arcModel.dart';
import 'package:e9pass_manager/models/certModel.dart';
import 'package:e9pass_manager/models/enums.dart';
import 'package:e9pass_manager/models/fileModel.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

List<FileSystemEntity> readDir(String path) {
  return Directory(path).listSync(recursive: true).toList();
}

bool copyCertificate(Map<String, dynamic> data) {
  final Certificate certificate = data['certificate'];
  final String destinationPath = p.join(data['destinationPath'], p.split(certificate.path).last);
  final Directory directory = Directory(destinationPath);
  try {
    if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    }
    certificate.files.forEach((element) {
      File(element.path).copySync(p.join(directory.path, element.name));
    });
    return true;
  } on FileSystemException catch (e) {
    print(e.toString());
    return false;
  }
}

List<ArcImage> readImages(FileChooserResult result) {
  List<ArcImage> data = List();
  result.paths.forEach((element) {
    String name = getName(element);
    File file = File(element);
    Uint8List bytes = file.readAsBytesSync();
    data.add(
      ArcImage(
        bytes: bytes,
        raw: true,
        arcNumber: '',
        name: name ?? ''
      ),
    );
  });
  return data;
}

String getName(String fileName) {
    try {
      return fileName.split('_').elementAt(1);
    } on RangeError {
      return null;
    }
  }

class FileService with ChangeNotifier {
  List<Certificate> selectedDirCert = List();
  List<Certificate> searchResult = List();
  String certFolderPath;
  bool indexing = false;
  List<ArcImage> pickedImages = List();

  Future<bool> getImageFiles(bool add) async {
    if (!add) {
      pickedImages = List();
    }
    FileChooserResult result = await showOpenPanel(
      allowsMultipleSelection: true,
      allowedFileTypes: <FileTypeFilterGroup> [
        FileTypeFilterGroup(
          label: 'Images',
          fileExtensions: <String> [
            'jpeg',
            'jpg',
            'png',
          ]
        )
      ]
    );
    if (result.canceled != true) {
      pickedImages = await compute(readImages, result);
      notifyListeners();
      return true;
    } else {
      // pickedImages = List();
      notifyListeners();
      return false;
    }
  }

  String getName(String fileName) {
    try {
      return fileName.split('_').elementAt(1);
    } on RangeError {
      return null;
    }
  }

  Future<bool> savePdf(Uint8List byteData, String fileName) async {
    FileChooserResult result = await showSavePanel(
      suggestedFileName: fileName + '.pdf',
      allowedFileTypes: <FileTypeFilterGroup> [
        FileTypeFilterGroup(
          label: 'Document',
          fileExtensions: <String> [
            'pdf',
          ]
        )
      ]
    );
    if (result.canceled != true) {
      File file = File(result.paths[0]);
      file.writeAsBytesSync(byteData);
      return true;
    } else {
      return false;
    }
  }

  Future<String> getFolderPath() async {
    FileChooserResult fileChooserResult = await showOpenPanel(
      canSelectDirectories: true,
    );
    if (fileChooserResult.canceled != true) {
      print(fileChooserResult.paths);
      return fileChooserResult.paths[0];
    } else {
      return null;
    }
  }

  Future search(String query) async {
    searchResult.clear();
    if (query.length < 1 || query == null) {
      notifyListeners();
      searchResult.clear();
    } else {
      searchResult = selectedDirCert.where((Certificate certificate) => certificate.name.contains(query.toLowerCase())).toList();
      notifyListeners();
    }
  }

  Future selectFolderForSearch() async {
    searchResult.clear();
    selectedDirCert.clear();
    indexing = true;
    notifyListeners();
    certFolderPath = await getFolderPath();
    notifyListeners();
    if (certFolderPath != null) {
      try {
        final fileSystemEntityList = await compute(readDir, certFolderPath);
        fileSystemEntityList.forEach((FileSystemEntity fileSystemEntity) {
          if (FileSystemEntity.isDirectorySync(fileSystemEntity.path)) {
            if (p.split(fileSystemEntity.absolute.path).last.contains('ou=RA센터,ou=e9pay,ou=등록기관,ou=licensedCA,o=KICA,c=KR')) {
              final certFiles = Directory(fileSystemEntity.absolute.path).listSync(recursive: true).toList();
              final files = certFiles.map((element) => MyFile(
                name: p.split(element.absolute.path).last,
                path: element.absolute.path,
                type: FileType.File,
              )).toList();
              selectedDirCert.add(
                Certificate(
                  name: getCertName(p.split(fileSystemEntity.absolute.path).last),
                  path: fileSystemEntity.absolute.path,
                  files: files
                )
              );
            }
            notifyListeners();
          }
        });
      } on FileSystemException catch (e) {
        print(e.toString());
        notifyListeners();
        return;
      }
    } else {
      indexing = false;
      notifyListeners();
      return;
    }
    
    indexing = false;
    notifyListeners();
  }

  Future<bool> downloadCertificate(Certificate certificate) async {
    String path = await getFolderPath();
    if (path != null) {
      final data = {"certificate" : certificate, "destinationPath" : path};
      return compute(copyCertificate, data);
    } else {
      return false;
    }
  }

  String getCertName(String folderName) {
    return folderName.split(',').first.split('=').elementAt(1);
  }
}