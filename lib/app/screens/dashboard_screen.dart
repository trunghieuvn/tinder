import 'package:flutter/material.dart';
import 'package:tinder/app/blocs/profile_card_page_bloc.dart';

import 'package:tinder/app/screens/profile_card/profile_card_page.dart';
import 'package:tinder/app/styles.dart';
import 'package:tinder/app/ui/widgets/bottom_bar_icon.dart';
import 'package:tinder/app/utils.dart';
import 'package:toast/toast.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ProfileCardBloc _profileCardBloc = ProfileCardBloc();
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
  void initState() {
    
    super.initState();
  }
  
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
              _switchmode();
            },
          ),
          ButtomBarIcon.large(
            icon: Icons.clear,
            iconColor: Colors.black,
            onPressed: (){
              _switchmode();
            },
          ),
          ButtomBarIcon.small(
            icon: Icons.star,
            iconColor: Colors.blue,
            onPressed: (){
              _switchmode();
            },
          ),
          ButtomBarIcon.large(
            icon: Icons.favorite,
            iconColor: ProfileCardBloc.isFavourite ? Colors.pinkAccent : Colors.pink[50],
            onPressed: (){
              _switchmode();
            },
          ),
          ButtomBarIcon.small(
            icon: Icons.lock,
            iconColor: Colors.orange,
            onPressed: (){
             _switchmode();
            }
          )
        ]
      )
    )
  );

  _switchmode() {
    _profileCardBloc.switchModeData();
    setState(() {});
    if(ProfileCardBloc.isFavourite) {
      Toast.show("7. My favourite list of people should be available offline also.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    else {
      Toast.show("4. If I swipe left I get the details of the next person from the API.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }
}   