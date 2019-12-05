import 'dart:convert';

import 'package:tinder/app/models/user.dart';
import 'package:tinder/app/networking/rest_client.dart';
import 'dart:math';

import '../../mocks/mock_data.dart';

class RestClientMock implements RestClient {
  var users = [
    user1,
    user2,
    user3,
    user4,
    user5,
  ];
  
  @override
  Future<ResultUser> getUser() {
    Random random = Random();
    int dataIdx = random.nextInt(users.length);

    return  Future.value(ResultUser.fromJson(json.decode(users[dataIdx])));
  }
}