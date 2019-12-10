import 'dart:async';
import 'dart:convert';

import 'package:tinder/app/ui/components/profile_card_item.dart';
import 'package:tinder/app/utils.dart';
import 'package:tinder/base/bloc_base.dart';
import 'package:tinder/app/models/user.dart';
import 'package:tinder/base/user_default.dart';

enum ProfileCardState { INITIAL, LOADING, NONE}
class ProfileCardBloc extends BlocBase implements CardSwipeListenr {
  static bool isFavourite = false;

  // ---------------- STREAM ----------------
  final StreamController<ProfileCardState> _controller;

  ProfileCardBloc() : _controller = StreamController<ProfileCardState>.broadcast();
  Stream<ProfileCardState> get itemStream => _controller.stream;

  // ---------------- properties ----------------
  List<User> users = [];
  ProfileCardState defaultItem = ProfileCardState.INITIAL;
  int currentFavourite = 0;
  
  Future<void> getUser() async{
    changeListState(ProfileCardState.LOADING);

    if(ProfileCardBloc.isFavourite == true) {
      printLog("[ProfileCardBLoc] get data with FAVOURITE $currentFavourite");
      var result = await getDataFavourite();

      if(result != null) {
        for (var i = 1; i <= 3; i++) {
          currentFavourite = (currentFavourite+1 < result.users.length) ? ++currentFavourite : 0;
          users.add(result.users[currentFavourite].user);  
        }
      } 
      changeListState(ProfileCardState.NONE);
    }else { 
      printLog("[ProfileCardBLoc] get data with API");

      Future.wait([
        appApiService.client.getUser(), 
        appApiService.client.getUser(), 
        appApiService.client.getUser()
      ])
      .then((List results) {
        results.forEach((result) {
          users.add(result.users[0].user);
        });
        changeListState(ProfileCardState.NONE);
      })
      .catchError((onError) {
        changeListState(ProfileCardState.LOADING);
      });
    }

  }
  
  Future<void> addUser({Function(User user) onResponse}) async{
    if(ProfileCardBloc.isFavourite == true){
      printLog("[ProfileCardBLoc] addUser with FAVOURITE $currentFavourite");
      var result = await getDataFavourite();

      if(result != null) {
        if(result != null && result.users.length > 0) {
          currentFavourite = (currentFavourite+1 < result.users.length) ? ++currentFavourite : 0;
          users.add(result.users[currentFavourite].user);
          onResponse(result.users[currentFavourite].user);
        }
      } 

    } else {
      printLog("[ProfileCardBLoc] addUser with API ${ProfileCardBloc.isFavourite} $currentFavourite");
      var result = await appApiService.client.getUser();

      if(result != null && result.users.length > 0) {
        users.add(result.users[0].user);
        onResponse(result.users[0].user);
      }
    }
  }

  Future<ResultUser> getDataFavourite() async{
    var data = UserDefault.getInstance().getString("KEY");

    if(data == null || data.isEmpty) {
      return null;
    }
    return ResultUser.fromJson(json.decode(data));
  }

  void changeListState(ProfileCardState state) {
    if (!_controller.isClosed) {
      _controller?.sink?.add(state);
    }
  }

  @override
  void dispose() {
    _controller?.close();
  }

  @override
  void moveToLeft({User user}) {
    printLog("[ProfileCardBLoc] moveToLeft currentFavourite: $currentFavourite");
  }

  @override
  void moveToRight({User user}) {
    printLog("[ProfileCardBLoc] moveToRight currentFavourite: $currentFavourite ${user.toJson()}");

    if(ProfileCardBloc.isFavourite == true) return;
    
    UserData userData = UserData(
      user,
      "1ae1fa01b3701f60",
      "0.4"
    );
    List<UserData> list = List();
    list.add(userData);
    ResultUser resultUser = ResultUser(list);

    String datas = json.encode(resultUser);
    printLog("data user: $datas");

    var data = UserDefault.getInstance().getString("KEY");
    if(data == null || data.isEmpty) {
      UserDefault.getInstance().setString("KEY", datas);
    } else {
      var result  = ResultUser.fromJson(json.decode(data));
      result.users.addAll(resultUser.users);

      datas = json.encode(result);
      UserDefault.getInstance().setString("KEY", datas);

      printLog("new data: $datas");
    }
  }

  @override
  void switchModeData() {
    printLog("[ProfileCardBloc] change mode data");
    ProfileCardBloc.isFavourite = !ProfileCardBloc.isFavourite;
    getUser();
  }
}
