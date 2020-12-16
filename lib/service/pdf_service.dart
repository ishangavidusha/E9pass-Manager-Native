import 'package:e9pass_manager/models/arcModel.dart';
import 'package:e9pass_manager/models/erroeModel.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;

class PdfFactory {
  pw.Document pdf;
  

  Future<pw.Document> getPdfFileWithStatement(List<ArcImage> fileList) async {
    pdf = pw.Document();
    var data = await rootBundle.load("assets/fonts/OpenSans-SemiBold.ttf");
    var kFontData = await rootBundle.load("assets/fonts/GothicA1-Medium.ttf");
    var myFont = pw.Font.ttf(data);
    var kFont = pw.Font.ttf(kFontData);
    fileList.forEach((element) {
      PdfImage arcPdfImage;
      try {
        arcPdfImage = PdfImage.file(pdf.document, bytes: element.bytes);
      } catch (e) {
        throw ErrorMsg(e: e, eMsg: 'Unable to read image of ${element.name}');
      }
      String name = element.name;
      String phoneNumber = '';
      String appNumber = '';
      String arcNumber = element.arcNumber;
      name = name != null && name.length > 0 ? name : '';
      phoneNumber = phoneNumber != null && phoneNumber.length > 0 ? phoneNumber : '';
      appNumber = appNumber != null && appNumber.length > 0 ? appNumber : '';
      arcNumber = arcNumber != null && arcNumber.length > 0 ? arcNumber : '';
      double devHeight = PdfPageFormat.a4.availableHeight;
      double devWidth = PdfPageFormat.a4.availableWidth;

      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Stack(
                children: [
                  pw.Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: pw.Container(
                      height: 10,
                      width: PdfPageFormat.a4.width / 2,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#404040')
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: devWidth,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('E9pass Registration Document',
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: myFont,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#003366'),
                        ),
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Text('NAME : $name',
                        style: pw.TextStyle(
                          fontSize: 12,
                          font: myFont,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#1C1C1C'),
                        ),
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      // pw.Text('APPLICATION NO : $appNumber',
                      //   style: pw.TextStyle(
                      //     fontSize: 12,
                      //     font: myFont,
                      //     fontWeight: pw.FontWeight.bold,
                      //     color: PdfColor.fromHex('#1C1C1C'),
                      //   ),
                      // ),
                      // pw.SizedBox(
                      //   height: 5,
                      // ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('ARC NO : $arcNumber',
                            style: pw.TextStyle(
                              fontSize: 12,
                              font: myFont,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#1C1C1C'),
                            ),
                          ),
                          pw.SizedBox(
                            width: 10,
                          ),
                          // pw.Text('PH : $phoneNumber',
                          //   style: pw.TextStyle(
                          //     fontSize: 12,
                          //     font: myFont,
                          //     fontWeight: pw.FontWeight.bold,
                          //     color: PdfColor.fromHex('#1C1C1C'),
                          //   ),
                          // ),
                        ]
                      ),
                      pw.Divider(
                        thickness: 2.0,
                        color: PdfColor.fromHex('#1C1C1C'),
                      ),
                    ]
                  ),
                ),
                pw.Container(
                  height: devHeight * 0.4,
                  width: devWidth,
                  child: arcPdfImage != null ? pw.Image(arcPdfImage, fit: pw.BoxFit.contain) : pw.Container(),
                ),
                pw.SizedBox(
                  height: 20,
                ),
                pw.Container(
                  width: devWidth,
                  padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: pw.BoxDecoration(
                    border: pw.BoxBorder(
                      bottom: true,
                      top: true,
                      left: true,
                      right: true,
                      color: PdfColors.black,
                    )
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        '동의서',
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: kFont,
                        )
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Text(
                        '상기 본인은 E9PASS 가입 시 발급된 공인 인증서(개인범용)의 이용과 관련하여 해외, 국내 송금 목적의 ㈜이나인페이 즉시 출금 서비스(Auto debit) 사용을 위한 금융결제원 본인인증(CID)용으로 제한하는 ㈜이나인페이 목적에 동의하며, 금융결제원 본인 인증 절차 통과 후 각종 금융사고(보이스피싱 및 금융범죄) 예방차원으로 E9PASS(KICA) 폐기에 대하여 동의합니다.',
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: kFont,
                          lineSpacing: 3,
                          letterSpacing: 1.2,
                          fontWeight: pw.FontWeight.normal
                        ),
                        textAlign: pw.TextAlign.justify
                      ),
                      pw.SizedBox(
                        height: 15,
                      ),
                      pw.Text(
                        '          년        월        일',
                        style: pw.TextStyle(
                          fontSize: 12,
                          font: kFont,
                        )
                      ),
                      pw.SizedBox(
                        height: 25,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '이름 : ',
                            style: pw.TextStyle(
                              fontSize: 12,
                              font: kFont,
                            )
                          ),
                          pw.SizedBox(
                            width: devWidth * 0.3,
                            child: pw.Flexible(
                              child: pw.Text(
                                '$name',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  font: kFont,
                                  letterSpacing: 1.0,
                                  lineSpacing: 1.0,
                                ),
                                softWrap: true,
                                maxLines: 3,
                              ),
                            ),
                          ),
                          pw.SizedBox(
                            width: 10
                          ),
                          pw.Text(
                            '인 :           ',
                            style: pw.TextStyle(
                              fontSize: 12,
                              font: kFont,
                            )
                          ),
                        ]
                      )
                    ]
                  ),
                ),
              ]
            );
          },
        ),
      );
    });
    return pdf;
  }

}

