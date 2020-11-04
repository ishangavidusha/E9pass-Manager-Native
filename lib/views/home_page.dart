import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/cert_search_view.dart';
import 'package:e9pass_manager/views/create_pdfs_view.dart';
import 'package:e9pass_manager/views/zip_archive_create_view.dart';
import 'package:e9pass_manager/widgets/app_main_logo.dart';
import 'package:e9pass_manager/widgets/drower_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  double currentPageValue;
  List<bool> selectedPage = [false, false, false];

  @override
  void initState() {
    selectedPage[0] = true;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            height: devHeight,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.secondTextColor
                )
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                KLogo(),
                SizedBox(
                  height: 10,
                ),
                DrowerButton(
                  onPressed: () {
                    _pageController.jumpToPage(0);
                  },
                  text: 'Search Certificates',
                  selected: selectedPage[0],
                ),
                DrowerButton(
                  onPressed: () {
                    _pageController.jumpToPage(1);
                  },
                  text: 'Create PDFs',
                  selected: selectedPage[1],
                ),
                DrowerButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  text: 'Zip Maker',
                  selected: selectedPage[2],
                )
              ],
            )
          ),
          Container(
            height: devHeight,
            width: devWidth - 200,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  selectedPage[0] = false;
                  selectedPage[1] = false;
                  selectedPage[2] = false;
                  selectedPage[value] = true;
                });
              },
              children: [
                CertSearchView(),
                CreatePDFs(),
                ZipCreatView()
              ],
            ),
          ),
        ],
      ),
    );
  }
}