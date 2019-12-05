import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tinder/app/models/user.dart';
import 'package:tinder/app/networking/rest_client.dart';

class RestClientDio implements RestClient {
  @override
  Future<ResultUser> getUser() async{
    Response _result = await Dio().get("https://randomuser.me/api/0.4/?randomapi=2");
    return Future.value(ResultUser.fromJson(jsonDecode(_result.data)));
  }
}