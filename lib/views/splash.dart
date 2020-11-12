import 'package:e9pass_manager/utils/my_colors.dart';
import 'package:e9pass_manager/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplasView extends StatelessWidget {

  Future<Widget> loadFromFuture() async {
    await Future.delayed(Duration(seconds: 2));
    return Future.value(HomePage());
  }
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      routeName: "/",
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      title: new Text(
        'Welcome In E9pass Manager',
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