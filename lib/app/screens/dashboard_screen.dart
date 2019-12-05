import 'package:flutter/material.dart';

import 'package:tinder/app/screens/profile_card/profile_card_page.dart';
import 'package:tinder/app/styles.dart';
import 'package:tinder/app/ui/widgets/bottom_bar_icon.dart';
import 'package:tinder/app/utils.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AppBar appBar = AppBar(      
    centerTitle: true,
    elevation: 0.0,
    leading: IconButton(
      icon: Icon(
        Icons.person, 
        color: Colors.grey,
        size: 30.0,
      ),
      onPressed: (){
        // TODO:
      }
    ),
    title: IconButton(
      icon: FlutterLogo(
        size: 30.0,
        colors: Colors.blue,
      ),
      alignment: Alignment.center,
      onPressed: (){
        // TODO:
      }
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.message, 
          color: Colors.grey
        ),
        onPressed: (){
          // TODO:
        }
      )
    ],
  );


  @override
  Widget build(BuildContext context) {
    Dimension.height = MediaQuery.of(context).size.height;
    Dimension.width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildAppBar(),
                _buildBottomBar()
              ]
            ),
            ProfilCardPage(appbarHeigh: appBar.preferredSize.height)
          ]
        )
      )
    );
  }

  Widget _buildAppBar() => appBar;

  Widget _buildBottomBar() => BottomAppBar(
    elevation: 0.0,
    child: Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,        
        children: <Widget>[
          ButtomBarIcon.small(
            icon: Icons.refresh,
            iconColor: Colors.orange,
            onPressed: (){
              //TODO:
            },
          ),
          ButtomBarIcon.large(
            icon: Icons.clear,
            iconColor: Colors.black,
            onPressed: (){
              // TODO:
            },
          ),
          ButtomBarIcon.small(
            icon: Icons.star,
            iconColor: Colors.blue,
            onPressed: (){
              // TODO:
            },
          ),
          ButtomBarIcon.large(
            icon: Icons.favorite,
            iconColor: Colors.pinkAccent,
            onPressed: (){
              // TODO:
            },
          ),
          ButtomBarIcon.small(
            icon: Icons.lock,
            iconColor: Colors.orange,
            onPressed: (){
              // TODO:
            },
          )
        ],
      ),
    )
  );
  
}   