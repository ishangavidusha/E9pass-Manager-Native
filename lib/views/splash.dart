import 'package:e9pass_manager/service/settings_Service.dart';
import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

class SplasView extends StatefulWidget {

  @override
  _SplasViewState createState() => _SplasViewState();
}

class _SplasViewState extends State<SplasView> {
  Future<Widget> loadFromFuture() async {
    await Provider.of<SettingsService>(context).getData();
    await Future.delayed(Duration(seconds: 1));
    return Future.value(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      routeName: "/",
      seconds: 2,
      navigateAfterFuture: loadFromFuture(),
      title: new Text(
        'Welcome To E9pass Manager',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: AppColors.textColor
        ),
      ),
      image: new Image.asset('assets/icons/splash.png'),
      backgroundColor: AppColors.bgColor,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 160.0,
      onClick: ()=>print("E9pass Manager"),
      loaderColor: AppColors.selectedBtColor,
      pageRoute: _createRoute(),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}