import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinder/app/screens/dashboard_screen.dart';
import 'package:tinder/app/styles.dart';
import 'package:tinder/app/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    appSetup();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
      )
    );
  
    super.initState();
  }
  
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinder :: Swipe Card',
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        bottomAppBarColor: MyColors.primaryColor
      ),
      home: DashboardScreen()
    );
  }
}