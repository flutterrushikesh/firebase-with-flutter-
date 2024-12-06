import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  static bool? isLogin;

  static setSessionData({required bool setLogin}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("isLogin", setLogin);
  }

  static getSessionData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isLogin = pref.getBool("isLogin") ?? false;
  }
}
