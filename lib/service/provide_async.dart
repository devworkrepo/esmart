import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> provideSharePreference() async{
  return  await SharedPreferences.getInstance();
}