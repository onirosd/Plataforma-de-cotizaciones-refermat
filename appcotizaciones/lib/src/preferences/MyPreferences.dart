import 'package:shared_preferences/shared_preferences.dart';
/*
Future getPreferences() async {
  SharedPreferences _preferences = await SharedPreferences.getInstance();
}*/

class UserSimplePreferences {
  late SharedPreferences _preferences;

  static String _Username = '';
  static String _pass = '';
  //static String _keyBirthday = 'birthday';

  Future init() async => _preferences = await SharedPreferences.getInstance();

  Future setUsername(String username) async =>
      await _preferences.setString(_Username, username);

  String? getUsername() => _preferences.getString(_Username);

  Future setPassword(String pass) async =>
      await _preferences.setString(_pass, pass);

  String? getPassword() => _preferences.getString(_Username);
/*
  static Future setPets(List<String> pets) async =>
      await _preferences.setStringList(_keyPets, pets);

  static List<String> getPets() => _preferences.getStringList(_keyPets);

  static Future setBirthday(DateTime dateOfBirth) async {
    final birthday = dateOfBirth.toIso8601String();

    return await _preferences.setString(_keyBirthday, birthday);
  */
}

  // static DateTime getBirthday() {
  //   final birthday = _preferences.getString(_keyBirthday);

  //   return birthday == null ? null : DateTime.tryParse(birthday);
  // }
//}

