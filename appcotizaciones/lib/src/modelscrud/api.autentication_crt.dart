import 'package:appcotizaciones/src/api/api.autentication.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

class ApiAutentication {
  Future<int> syncAwaitingfromApi() async {
    Future.delayed(Duration(seconds: 0));
    return 3;
  }

  Future<int> syncAuthenticationfromApi(int company) async {
    AutenticationApiProvider api = new AutenticationApiProvider();
    AuthenticationCtr crt = new AuthenticationCtr();
    List<int> devol = [];

    // Obtenemos los usuarios de autenticacion

    List<Authentication> data = await api.getAllAutentication(company);
    int contador = await data.length;

    if (contador > 0) {
      await crt.deleteAllAutentication();
    }

    for (var i = 0; i < contador; i++) {
      Authentication auth = data[i];
      devol.add(await crt.insertAutentication(auth));
    }
    return devol.length;
  }
}
