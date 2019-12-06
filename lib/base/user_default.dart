import 'package:shared_preferences/shared_preferences.dart';

class UserDefault {
  // private contructor
  UserDefault._();
  static UserDefault _instance;
  static UserDefault getInstance() {
    if(_instance == null) {
      _instance = UserDefault._();
    }
     return _instance;
   }

  SharedPreferences _prefs;

  Future<void> init() async{
    _prefs = await SharedPreferences.getInstance(); 
    
  }

  // -- GET -- //
  String        getString(String key)   => _prefs.getString(key) ?? null;

  int           getInt(String key)      => _prefs.getInt(key) ?? null;

  double        getDouble(String key)   => _prefs.getDouble(key) ?? null;

  bool          getBoolean(String key)  => _prefs.getBool(key) ?? null;

  List<String>  getStrings(String key)  => _prefs.getStringList(key) ?? null;

  Set<String>   getKeys(String key)     => _prefs.getKeys() ?? null;

  // -- SET -- //
  Future<bool> setString(String key, String value) async  => await _prefs.setString(key, value);

  Future<bool> setInt(String key, int value) async     => await _prefs.setInt(key, value);

  Future<bool> setDouble(String key, double value) async  => await _prefs.setDouble(key, value);

  Future<bool> setBoolean(String key, bool value) async => await _prefs.setBool(key, value);

  Future<bool> setStrings(String key, List<String> strings) async => await _prefs.setStringList(key, strings);

}