class PdfFile {
  String appNumber;
  String path;

  PdfFile({
    this.appNumber,
    this.path,
  });

  @override
  String toString() {
    return appNumber ?? 'Not Found';
  }
}