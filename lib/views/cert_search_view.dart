import 'package:cool_alert/cool_alert.dart';
import 'package:e9pass_manager/service/file_service.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/widgets/get_folder_path_ui.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CertSearchView extends StatefulWidget {
  @override
  _CertSearchViewState createState() => _CertSearchViewState();
}

class _CertSearchViewState extends State<CertSearchView> {
  FileService _fileService;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width - 200;
    double devHeight = MediaQuery.of(context).size.height;
    _fileService = Provider.of<FileService>(context);
    return Container(
      width: devWidth,
      height: devHeight,
      child: _fileService.certFolderPath == null ? GetFolderUI(
        onPressed: () {
          _fileService.selectFolderForSearch();
        },
      ) : GestureDetector(
        onTap: () {
          print('Taped');
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: devWidth,
          height: devHeight,
          color: Colors.white,
          child: Column(
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
                      'Search Certificates',
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Folder',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.2,
                                color: AppColors.textColor
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            _fileService.indexing ? Text(
                              'Indexing...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                color: AppColors.selectedBtColor,
                              ),
                            ): Text(
                              'Files : ${_fileService.selectedDirCert.length.toString()}',
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
                          width: 250,
                          child: Text(
                            _fileService.certFolderPath,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 1.2,
                              color: AppColors.textColor
                            ),
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
                        text: 'Change Folder',
                        onPressed: _fileService.indexing ? null : () {
                          _fileService.selectFolderForSearch();
                        },
                        selected: false,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: AppColors.secondTextColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.textColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.secondTextColor, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.textColor, width: 2.0),
                          ),
                          labelText: 'Search Name',
                          labelStyle: TextStyle(
                            color: AppColors.secondTextColor
                          ),
                        ),
                        onChanged: (value) {
                          if (!_fileService.indexing) {
                            _fileService.search(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.secondTextColor,),
              !_fileService.indexing ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _fileService.searchResult.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      selectedTileColor: Colors.black12,
                      selected: _fileService.searchResult[index].selected,
                      leading: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFC200).withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 4)
                            )
                          ]
                        ),
                        child: Image.asset('assets/icons/017-locked.png', scale: 16),
                      ),
                      title: Text(
                        _fileService.searchResult[index].name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _fileService.searchResult[index].path,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing:_fileService.searchResult[index].selected ? CircularProgressIndicator(
                          backgroundColor: AppColors.secondTextColor,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor) 
                        ) : Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFC200).withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 4)
                            )
                          ]
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _fileService.searchResult[index].selected = true;
                            });
                            bool result = await _fileService.downloadCertificate(_fileService.searchResult[index]);
                            //TODO : Beter Animation
                            CoolAlert.show(
                              context: context,
                              type: result ? CoolAlertType.success : CoolAlertType.error,
                              flareAsset: result ? 'assets/flare/success_check.flr' : 'assets/flare/error_check.flr',
                              title: result ?  'Successfully Copied!' : 'Failed to Copy',
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                              },
                            );
                            setState(() {
                              _fileService.searchResult[index].selected = false;
                            });
                          },
                          child: Image.asset('assets/icons/028-download.png', scale: 16),
                        ),
                      ),
                    );
                  },
                ),
              ) : Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: FlareActor(
                            'assets/animation/Penguin.flr',
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: 'walk',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}