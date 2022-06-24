import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
import 'package:appcotizaciones/src/preferences/sharedpreferencestest.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';
  String company = '';
  // bool _isInternet = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // bool get isInternet => _isInternet;

  //set isInternet(bool value) {
  // _isInternet = value;
  // notifyListeners();
  // }

  bool isValidForm() {
    //  print(formKey.currentState?.validate());

    //print('$email - $password');

    return formKey.currentState?.validate() ?? false;
  }

  Future<int> searchUser(Authentication auth) async {
    AuthenticationCtr crt = new AuthenticationCtr();
    return crt.checkAutentication(
        auth.strNameUser, auth.strPassUser, auth.codCompany);
  }

  Future<Authentication> searchUserStr(
      String user, String pass, int empresa) async {
    AuthenticationCtr crt = new AuthenticationCtr();
    Authentication auth = new Authentication(
        codUser: 0, strNameUser: "", strPassUser: "", codCompany: 0);

    List<Authentication> listAuth =
        await crt.checkAutentication2(user, pass, empresa.toString());

    if (listAuth.length > 0) {
      auth = listAuth[0];
    }

    return auth;
  }

/*
  devolverUsuario() async {
    SharedPreferencesTest sh = await new SharedPreferencesTest();
    final usuario = await sh.getUser();
    return usuario;
  }

  */
}
