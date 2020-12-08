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
import 'package:string_validator/string_validator.dart';

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
    File file = File(element);
    data.add( 
      ArcImage(
        bytes: file.readAsBytesSync(),
        file: file,
        raw: true,
        fileName: p.split(file.path).last,
        arcNumber: getArc(element) ?? '',
        name: getName(element) ?? ''
      ),
    );
  });
  return data;
}

List<Certificate> processCertificate(List<FileSystemEntity> fileSystemEntityList) {
  List<Certificate> selectedDirCert = List();
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
    }
  });
  return selectedDirCert;
}

String getCertName(String folderName) {
  return folderName.split(',').first.split('=').elementAt(1);
}

String getArc(String path ) {
  try {
    String fileName = p.split(path).last.split('.').first;
    List<String> names = fileName.split('_');
    if (names.length > 0) {
      String checkArc = names.firstWhere((element) => isNumeric(element.replaceAll(' ', '').replaceAll('-', '')) && element.length == 13, orElse: () => null);
      if (checkArc == null) {
        String idNumber = names.firstWhere((element) => isAlphanumeric(element.replaceAll(' ', '')) && element.length == 8, orElse: () => null);
        if (idNumber != null) {
          return isNumeric(idNumber.substring(1)) && isAlpha(idNumber.substring(0, 1)) ? idNumber : null;
        } else {
          return idNumber;
        }
      } else {
        return checkArc;
      }
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

String getName(String path) {
  try {
    String fileName = p.split(path).last.split('.').first;
    // print(fileName);
    List<String> names = fileName.split('_');
    if (names.length > 0) {
      String name =  names.firstWhere((element) => isAlpha(element.replaceAll(' ', '')) && isUppercase(element), orElse: () => null,);
      name = name != null ? name.trim() : name;
      return name;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
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
            'jpg',
          ]
        )
      ]
    );
    if (result.canceled != true) {
      pickedImages.addAll(await compute(readImages, result));
      pickedImages.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void removeImage(ArcImage arcImageToRemove) {
    if (pickedImages.isNotEmpty || pickedImages != null) {
      pickedImages.remove(arcImageToRemove);
      notifyListeners();
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
    certFolderPath = await getFolderPath();
    notifyListeners();
    if (certFolderPath != null) {
      try {
        final fileSystemEntityList = await compute(readDir, certFolderPath);
        selectedDirCert.addAll(await compute(processCertificate, fileSystemEntityList));
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