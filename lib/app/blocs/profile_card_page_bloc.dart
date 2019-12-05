import 'dart:async';

import 'package:tinder/base/bloc_base.dart';
import 'package:tinder/app/models/user.dart';

enum ProfileCardState { INITIAL, LOADING, NONE}

class ProfileCardBloc extends BlocBase {
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
}
