import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'screens/homepage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.indigo,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Landmark Recognition',
      theme: ThemeData(
        appBarTheme: AppBarTheme(elevation: 0, color: Colors.transparent),
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}
