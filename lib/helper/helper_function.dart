import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
//Keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
//saving data to SF
  static Future<bool> saveUserLoginStatus(bool isUserLoggedIn)async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUserEmail(String userEmail)async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, userEmail);
  }
  static Future<bool> saveUserName(String userName)async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

//getting data from SF
static Future<bool?> getUserLoggedInStatus()async{
SharedPreferences sf= await SharedPreferences.getInstance();
return sf.getBool(userLoggedInKey);

}
  static Future<String?> getUserEmail()async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);

  }
  static Future<String?> getUserName()async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.getString(userNameKey);

  }
}