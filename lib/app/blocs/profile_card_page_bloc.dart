import 'dart:async';
import 'dart:convert';

import 'package:tinder/app/ui/components/profile_card_item.dart';
import 'package:tinder/app/utils.dart';
import 'package:tinder/base/bloc_base.dart';
import 'package:tinder/app/models/user.dart';
import 'package:tinder/base/user_default.dart';

enum ProfileCardState { INITIAL, LOADING, NONE}

class ProfileCardBloc extends BlocBase implements CardSwipeListenr {
  // ---------------- STREAM ----------------
  final StreamController<ProfileCardState> _controller;
  ProfileCardBloc() : _controller = StreamController<ProfileCardState>.broadcast();
  Stream<ProfileCardState> get itemStream => _controller.stream;

  // ---------------- properties ----------------
  List<User> users = [];
  ProfileCardState defaultItem = ProfileCardState.INITIAL;

  Future<void> getUser() async{
    changeListState(ProfileCardState.LOADING);
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

  Future<void> addUser({Function(User user) onResponse}) async{
    var result = await appApiService.client.getUser();
    
    if(result != null && result.users.length > 0) {
      users.add(result.users[0].user);
      onResponse(result.users[0].user);
      changeListState(ProfileCardState.NONE);
    }
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
    printLog("[ProfileCardBLoc] moveToLeft");
  }

  @override
  void moveToRight({User user}) {
    printLog("[ProfileCardBLoc] moveToRight ${user.toJson()}");

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
      printLog("new data: ${result.users.length}");

      datas = json.encode(result);
      UserDefault.getInstance().setString("KEY", datas);

      printLog("new data: $datas");
    }
    
    

  }
}
