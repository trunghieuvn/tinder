import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinder/app/screens/dashboard_screen.dart';
import 'package:tinder/app/styles.dart';

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
      title: 'Random Profile Swipe Card',
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        bottomAppBarColor: MyColors.primaryColor
      ),
      home: DashboardScreen()
    );
  }
}