import 'package:e9pass_manager/service/file_service.dart';
import 'package:e9pass_manager/service/image_servise.dart';
import 'package:e9pass_manager/service/zip_service.dart';
import 'package:e9pass_manager/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart' as window_size;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  window_size.getWindowInfo().then((window) {
    if (window.screen != null) {
      window_size.setWindowMinSize(Size(1200, 600));
      window_size.setWindowTitle('E9pass Manager');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FileService()),
        ChangeNotifierProvider(create: (_) => ImageService(),),
        ChangeNotifierProvider(create: (_) => ZipService(),),
      ],
      child: MaterialApp(
        title: 'E9pass Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplasView(),
      ),
    );
  }
}
