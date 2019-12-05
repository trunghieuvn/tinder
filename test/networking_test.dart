import 'package:flutter_test/flutter_test.dart';
import 'package:tinder/app/networking/app_api_service.dart';
import 'package:tinder/app/utils.dart';

main() {
  group('test networking', () { 
    test('api', () async {
      AppApiService appApiService = AppApiService()
      ..create();
      var users = await appApiService.client.getUser();
      
      expect(true, users.users != null);
      printLog("[Test] users: ${users.toJson()}");
    });
  });
}