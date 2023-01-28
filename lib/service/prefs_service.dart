import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {


  static void storeCategory(List<String> category) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    await preferences.setStringList("category", category);
  }



  static Future<List<String>?> loadCategory() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    return preferences.getStringList("category");
  }
}