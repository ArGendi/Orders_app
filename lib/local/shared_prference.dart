import 'package:shared_preferences/shared_preferences.dart';

class Cache{
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setEmail(String value) async{
    await sharedPreferences!.setString('email', value);
  }

  static String? getEmail(){
    return sharedPreferences!.getString('email');
  }

  static Future<void> setName(String value) async{
    await sharedPreferences!.setString('name', value);
  }

  static String? getName(){
    return sharedPreferences!.getString('name');
  }

  static Future<void> setPhone(String value) async{
    await sharedPreferences!.setString('phone', value);
  }

  static String? getPhone(){
    return sharedPreferences!.getString('phone');
  }

   static Future<void> setLanguage(String value) async{
    await sharedPreferences!.setString('language', value);
  }

  static String? getLanguage(){
    return sharedPreferences!.getString('language');
  }
}