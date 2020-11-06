import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:e9pass_manager/service/zip_service.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/widgets/kbutton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZipResultView extends StatefulWidget {
  @override
  _ZipResultViewState createState() => _ZipResultViewState();
}

class _ZipResultViewState extends State<ZipResultView> {
  ScrollController _scrollController = ScrollController();
  ZipService _zipService;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    _zipService = Provider.of<ZipService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.btColor,
          ),
          onPressed: _zipService.loading ? null : () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'File Search Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.2,
            color: AppColors.textColor
          ),
        ),
      ),
      body: _zipService.loading ? Stack(
        children: [
          FlareActor(
            'assets/animation/Penguin.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'walk',
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              width: devWidth,
              child: Center(
                child: Text(
                  _zipService.loadingStatus,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.2,
                    color: AppColors.textColor
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ) : Stack(
        children: [
          Positioned(
            top: 0,
            width: devWidth,
            height: devHeight,
            child: DraggableScrollbar.arrows(
              controller: _scrollController,
              backgroundColor: AppColors.btColor,
              child: ListView.builder(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10),
                itemCount: _zipService.zipResult.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      leading: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 4)
                            )
                          ]
                        ),
                        child: Image.asset('assets/icons/001-info.png', scale: 16),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _zipService.zipResult[index].userName.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            _zipService.zipResult[index].applicationNumber,
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            _zipService.zipResult[index].arcNumber,
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: devWidth * 0.4,
                        child: Row(
                          children: [
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  'Certificate : ',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  _zipService.zipResult[index].certificate != null ? 'Cert Found' : 'Not Found',
                                  style: TextStyle(
                                    color: _zipService.zipResult[index].certificate != null ? Colors.blue : AppColors.selectedBtColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'PDF : ',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  _zipService.zipResult[index].pdfFile != null ? 'PDF Found' : 'Not Found',
                                  style: TextStyle(
                                    color: _zipService.zipResult[index].pdfFile != null ? Colors.blue : AppColors.selectedBtColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            _zipService.zipResult[index].ziped ? Icon(
                              Icons.done,
                              color: Colors.green,
                            ) : IconButton(
                              icon: Icon(
                                Icons.archive,
                                color: _zipService.zipResult[index].certificate != null ? AppColors.btColor : AppColors.secondTextColor,
                              ),
                              onPressed: _zipService.zipResult[index].certificate != null ? () {
                                print('Pressed!');
                              } : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: devWidth,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.3, 0.6],
                  colors: [
                    AppColors.bgColor,
                    AppColors.bgColor.withOpacity(0.2)
                  ]
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150,
                    child: _zipService.ziping ? FlareActor(
                      'assets/animation/Penguin.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: 'walk',
                    ) : Container(),
                  ),
                  _zipService.zipingStatus.length > 0 ? Container(
                    margin:EdgeInsets.only(bottom: 30),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.bgColor,
                      border: Border.all(
                        color: AppColors.selectedBtColor,
                      )
                    ),
                    child: Text(
                      _zipService.zipingStatus.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ) : Container(),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: KButton(
                      text: 'Create Zip',
                      onPressed: () {
                        _zipService.zipAllFiles();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}