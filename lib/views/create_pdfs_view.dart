import 'package:cool_alert/cool_alert.dart';
import 'package:e9pass_manager/service/file_service.dart';
import 'package:e9pass_manager/service/image_servise.dart';
import 'package:e9pass_manager/service/pdf_service.dart';
import 'package:e9pass_manager/service/settings_Service.dart';
import 'package:e9pass_manager/utils/hexConverter.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/image_edit_view.dart';
import 'package:e9pass_manager/widgets/get_files_ui.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart ' as pw;

class CreatePDFs extends StatefulWidget {
  @override
  _CreatePDFsState createState() => _CreatePDFsState();
}

class _CreatePDFsState extends State<CreatePDFs> {
  FileService _fileService;
  PdfFactory _pdfFactory = PdfFactory();
  bool loading = false;
  bool converting = false;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width - 200;
    double devHeight = MediaQuery.of(context).size.height;
    _fileService = Provider.of<FileService>(context);
    return Container(
      width: devWidth,
      height: devHeight,
      child: _fileService.pickedImages.isEmpty ? GetFilesUI(
        onPressed: () {
          _fileService.getImageFiles(false);
        }
      ) : Column(
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
                  'PDF File Create',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                    color: AppColors.textColor
                  ),
                ),
                Spacer(),
                Container(
                  child: InkWell(
                    onTap: () {
                      _getPdfSettings(devWidth, devHeight);
                    },
                    customBorder: CircleBorder(),
                    child: Image.asset('assets/icons/043-settings.png', scale: 14,),
                  ),
                ),
                SizedBox(
                  width: 35,
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
                      'Selected Images',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                        color: AppColors.textColor
                      ),
                    ),
                    Text(
                      '${_fileService.pickedImages.length} Image Selected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: AppColors.textColor
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Text(
                  'Ascending',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                    color: AppColors.secondTextColor
                  ),
                ),
                Switch(
                  value: _fileService.isAscending,
                  onChanged: (value) {
                    setState(() {
                      _fileService.ascending(value);
                    });
                  },
                  activeTrackColor: AppColors.selectedBtColor.withAlpha(80),
                  activeColor: AppColors.selectedBtColor,
                ),
                Transform.scale(
                  scale: 0.8,
                  child: KButton(
                    text: 'Add More',
                    onPressed: () {
                      _fileService.getImageFiles(true);
                    },
                    selected: false,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: KButton(
                    text: 'Select Again',
                    onPressed: () {
                      _fileService.getImageFiles(false);
                    },
                    selected: false,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: KButton(
                    text: 'Export',
                    onPressed: _fileService.pickedImages.isNotEmpty ? () async {
                      setState(() {
                        converting = true;
                      });
                      pw.Document document;
                      try {
                        document = await _pdfFactory.getPdfFileWithStatement(
                          _fileService.pickedImages,
                          Provider.of<SettingsService>(context, listen: false),
                        );
                      } catch (e) {
                        print(e);
                        //TODO : Change Animation
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          flareAsset: 'assets/flare/error_check.flr',
                          title: 'Something went wrong!',
                          text: e.toString(),
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                      String fileName = DateFormat("yyyyMMddhhmmss").format(DateTime.now());
                      if (document != null) {
                        _fileService.savePdf(document.save(), '$fileName-${_fileService.pickedImages.length}').then((value) => {
                          if (value) {
                            //TODO : Change Animation
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              flareAsset: 'assets/flare/success_check.flr',
                              title: 'Successfully Saved!',
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          } else {
                            //TODO : Change Animation
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              flareAsset: 'assets/flare/error_check.flr',
                              title: 'Failed to save PDF',
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          }
                        });
                      }
                      setState(() {
                        converting = false;
                      });
                    } : null,
                    selected: false,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.secondTextColor,),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.5,
              ),
              itemCount: _fileService.pickedImages.isNotEmpty ? _fileService.pickedImages.length : 0,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () async {
                      // Go to edit
                      setState(() {
                        loading = true;
                      });
                      try {
                        Provider.of<ImageService>(context, listen: false).clear();
                        await Provider.of<ImageService>(context, listen: false).setImage(_fileService.pickedImages[index]);
                        bool edited = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ImageEditView()),
                        );
                        if (edited) {
                          _fileService.pickedImages[index].bytes = Provider.of<ImageService>(context, listen: false).getImage();
                          _fileService.pickedImages[index].save();
                          _fileService.pickedImages[index].name = Provider.of<ImageService>(context, listen: false).name;
                          _fileService.pickedImages[index].arcNumber = Provider.of<ImageService>(context, listen: false).arc;
                          _fileService.pickedImages[index].raw = false;
                        } else {
                          _fileService.pickedImages[index].bytes = Provider.of<ImageService>(context, listen: false).getOriginal();
                        }
                      } catch (e) {
                        print(e);
                        //TODO : Change Animation
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          flareAsset: 'assets/flare/error_check.flr',
                          title: 'Something went wrong!',
                          text: e.toString(),
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 2,
                                color: _fileService.pickedImages[index].raw ? AppColors.secondTextColor : Colors.red
                              )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory(_fileService.pickedImages[index].bytes, fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _fileService.pickedImages[index].name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _fileService.pickedImages[index].arcNumber,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform.scale(
                            scale: 0.6,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                              child: IconButton(
                                icon: Icon(Icons.close, color: AppColors.selectedBtColor),
                                onPressed: () {
                                  _fileService.removeImage(_fileService.pickedImages[index]);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _getPdfSettings(double devWidth, double devHeight) async {
    SettingsService _settingsService = await Provider.of<SettingsService>(context, listen: false).getData();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        SettingsService _settings = _settingsService;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'PDF Settings',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Footer Margin : ${_settings.footerMargin}',
                        style: TextStyle(
                          color: AppColors.textColor,
                        ),
                      ),
                      Spacer(),
                      NumberPicker.integer(
                        itemExtent: 30,
                        scrollDirection: Axis.horizontal,
                        highlightSelectedValue: true,
                        initialValue: _settings.footerMargin, 
                        minValue: 0, 
                        maxValue: 40,
                        step: 2,
                        onChanged: (value) => setState(() => _settings.footerMargin = value)
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Footer Thikness : ${_settings.footerThikness}',
                        style: TextStyle(
                          color: AppColors.textColor,
                        ),
                      ),
                      Spacer(),
                      NumberPicker.integer(
                        itemExtent: 30,
                        scrollDirection: Axis.horizontal,
                        highlightSelectedValue: true,
                        initialValue: _settings.footerThikness, 
                        minValue: 0, 
                        maxValue: 60,
                        step: 5,
                        onChanged: (value) => setState(() => _settings.footerThikness = value)
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Footer Color : ${_settings.footerColor.toUpperCase()}',
                        style: TextStyle(
                          color: AppColors.textColor,
                        ),
                      ),
                      Spacer(),
                      NumberPicker.integer(
                        scrollDirection: Axis.horizontal,
                        highlightSelectedValue: true,
                        initialValue: HexColor(_settings.footerColor).red, 
                        minValue: 0, 
                        maxValue: 255,
                        step: 2,
                        onChanged: (value) => setState(() => _settings.footerColor = Color.fromRGBO(value.toInt(), value.toInt(), value.toInt(), 1).value.toRadixString(16))
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Footer : ${_settings.addFooter ? 'Enabled' : 'Disabled'}',
                        style: TextStyle(
                          color: AppColors.textColor,
                        ),
                      ),
                      Spacer(),
                      Switch(
                        value: _settings.addFooter,
                        onChanged: (value) => setState(() => _settings.addFooter = value),
                        activeTrackColor: AppColors.selectedBtColor.withAlpha(80),
                        activeColor: AppColors.selectedBtColor,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                KButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(false),
                  selected: true,
                ),
                KButton(
                  text: 'Done',
                  onPressed: () async {
                    await Provider.of<SettingsService>(context, listen: false).setData(_settings.footerMargin, _settings.footerThikness, _settings.footerColor, _settings.addFooter);
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
}