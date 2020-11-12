import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/cert_search_view.dart';
import 'package:e9pass_manager/views/create_pdfs_view.dart';
import 'package:e9pass_manager/views/zip_archive_create_view.dart';
import 'package:e9pass_manager/widgets/app_main_logo.dart';
import 'package:e9pass_manager/widgets/drower_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  double currentPageValue;
  List<bool> selectedPage = [false, false, false];

  launchURL() async {
    const url = 'https://github.com/ishangavidusha';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

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
              color: AppColors.bgColor,
              border: Border(
                right: BorderSide(
                  color: AppColors.textColor
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
                  text: 'Create PDFs', 
                  selected: selectedPage[0],
                ),
                DrowerButton(
                  onPressed: () {
                    _pageController.jumpToPage(1);
                  },
                  text: 'Search Certificates',
                  selected: selectedPage[1],
                ),
                DrowerButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  text: 'Bulk Search',
                  selected: selectedPage[2],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(20),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textColor,
                        letterSpacing: 1.2,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Developed by '),
                        TextSpan(
                          text: 'Ishanga',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.blue,
                            letterSpacing: 1.2,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL();
                            }
                          ),
                      ],
                    ),
                  ),
                ),
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
                CreatePDFs(),
                CertSearchView(),
                ZipCreatView()
              ],
            ),
          ),
        ],
      ),
    );
  }
}