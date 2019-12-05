import 'package:flutter/material.dart';

import 'package:tinder/app/utils.dart';
import 'package:tinder/base/bloc_base.dart';
import 'package:tinder/base/state_base.dart';
import 'package:tinder/app/blocs/profile_card_page_bloc.dart';
import 'package:tinder/app/ui/components/card_section.dart';
import 'package:tinder/app/ui/extension.dart';

class ProfilCardPage extends StatefulWidget {
  final double appbarHeigh;

  const ProfilCardPage({
    Key key, 
    this.appbarHeigh
  }) : super(key: key);

  @override
  _ProfilCardPageState createState() => _ProfilCardPageState();
}

class _ProfilCardPageState extends StateBase<ProfilCardPage> {
  ProfileCardBloc _profileCardBloc;

  @override
  BlocBase getBloc() {
    return _profileCardBloc;
  }

  @override
  void initState() {
    _profileCardBloc = ProfileCardBloc();

    super.initState();
  }

  @override
  void dispose() {
    _profileCardBloc.dispose();

    super.dispose();
  }

  @override
  void showNoInternetDialog() {
    showDialog(
      context: context, 
      barrierDismissible: false, 
      builder: (context) {
        return errorInternet(
          width: Dimension.getWidth(0.9),
          height: Dimension.getWidth(0.9),
          onTap: () {
            Navigator.pop(context);
            _profileCardBloc.getUser();
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.appbarHeigh ?? 56, bottom: 80),
      child: StreamBuilder<ProfileCardState>(
        stream: _profileCardBloc.itemStream,
        initialData: _profileCardBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<ProfileCardState> snapshot) {
          if(snapshot.hasError) {
            return SizedBox();
          }
          
          switch (snapshot.data) {
            case ProfileCardState.INITIAL:
              _profileCardBloc.getUser();
              return buildLoading(); 
            case ProfileCardState.LOADING:
              return buildLoading(); 
              break;
            case ProfileCardState.NONE:
            default: 
              return CardSection(context, _profileCardBloc);
          }
        }
      )
    );
  }
  
}