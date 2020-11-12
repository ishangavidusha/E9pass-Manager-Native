import 'package:e9pass_manager/service/file_service.dart';
import 'package:e9pass_manager/service/zip_service.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/zip_result_view.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:e9pass_manager/widgets/open_file_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZipCreatView extends StatefulWidget {
  @override
  _ZipCreatViewState createState() => _ZipCreatViewState();
}

class _ZipCreatViewState extends State<ZipCreatView> {
  ZipService _zipService;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width - 200;
    double devHeight = MediaQuery.of(context).size.height;
    _zipService = Provider.of<ZipService>(context);
    return Container(
      width: devWidth,
      height: devHeight,
      child: _zipService.excelFile == null ? OpenFileUI(
        onPressed: () {
          _zipService.getExcelFilePath();
        },
      ) : Container(
        width: devWidth,
        height: devHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 29,
            ),
            Container(
              width: devWidth,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Certificate Bulk Search',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.2,
                      color: AppColors.textColor
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: devWidth,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 4,
                            offset: Offset(0, 4)
                          )
                        ]
                      ),
                      child: Image.asset('assets/icons/022-google sheets.png', scale: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected File',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                          color: AppColors.textColor
                        ),
                      ),
                      SizedBox(
                        width: devWidth * 0.4,
                        child: Text(
                          _zipService.excelFilePath,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: AppColors.textColor
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: KButton(
                      text: 'Change File',
                      onPressed: () {
                        _zipService.getExcelFilePath();
                      },
                      selected: false,
                    ),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 0.8,
                    child: KButton(
                      text: 'Next',
                      onPressed: () {
                        _zipService.getCertificateFiles();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ZipResultView()),
                        );
                      },
                      selected: false,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.secondTextColor,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Please select appropriate column for each value',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  color: AppColors.textColor
                ),
              ),
            ),
            SizedBox(
              height: 10, 
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: devWidth * 0.7,
              child: Row(
                children: [
                  Text(
                    'Application Number Column : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                      color: AppColors.textColor
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.btColor
                      )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _zipService.sheetMap.applicationNumber,
                        onChanged: (value) {
                          _zipService.setSheetMap(1, value);
                        },
                        items: _zipService.columnToSelect.map((e) => DropdownMenuItem(
                          child: Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          value: e,
                        )).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: devWidth * 0.7,
              child: Row(
                children: [
                  Text(
                    'ARC / Passport Number : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                      color: AppColors.textColor
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.btColor
                      )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _zipService.sheetMap.arcNumber,
                        onChanged: (value) {
                          _zipService.setSheetMap(2, value);
                        },
                        items: _zipService.columnToSelect.map((e) => DropdownMenuItem(
                          child: Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          value: e,
                        )).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: devWidth * 0.7,
              child: Row(
                children: [
                  Text(
                    'User Name : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                      color: AppColors.textColor
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.btColor
                      )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _zipService.sheetMap.userName,
                        onChanged: (value) {
                          _zipService.setSheetMap(3, value);
                        },
                        items: _zipService.columnToSelect.map((e) => DropdownMenuItem(
                          child: Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          value: e,
                        )).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: devWidth * 0.7,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFC200).withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 4,
                          offset: Offset(0, 4)
                        )
                      ]
                    ),
                    child: Image.asset('assets/icons/042-folder.png', scale: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Folder Containing Certificate Files',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                          color: AppColors.textColor
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          _zipService.certificateFolder ?? 'Not Selected',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: _zipService.certificateFolder != null ? AppColors.textColor : AppColors.selectedBtColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  KButton(
                    onPressed: () {
                      _zipService.getFolderPath(false);
                    },
                    text: 'Select Folder',
                    selected: false,
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   width: devWidth * 0.7,
            //   child: Row(
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //               color: Color(0xFFFFC200).withOpacity(0.2),
            //               blurRadius: 10,
            //               spreadRadius: 4,
            //               offset: Offset(0, 4)
            //             )
            //           ]
            //         ),
            //         child: Image.asset('assets/icons/042-folder.png', scale: 16),
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Folder Containing PDF Files',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16,
            //               letterSpacing: 1.2,
            //               color: AppColors.textColor
            //             ),
            //           ),
            //           SizedBox(
            //             width: 250,
            //             child: Text(
            //               _zipService.pdfFolder ?? 'Not Selected',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 10,
            //                 letterSpacing: 1.2,
            //                 color: _zipService.pdfFolder != null ? AppColors.textColor : AppColors.selectedBtColor
            //               ),
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ),
            //         ],
            //       ),
            //       Spacer(),
            //       KButton(
            //         onPressed: () {
            //           _zipService.getFolderPath(true);
            //         },
            //         text: 'Select Folder',
            //         selected: false,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}