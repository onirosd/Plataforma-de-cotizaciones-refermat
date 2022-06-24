import 'package:appcotizaciones/src/api/api.autentication.dart';
import 'package:appcotizaciones/src/api/api.company.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/lastCompany.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
import 'package:appcotizaciones/src/modelscrud/company_crt.dart';
import 'package:appcotizaciones/src/modelscrud/lastCompany_crud.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

class ApiCompany {
  Future<int> syncAwaitingfromApi() async {
    Future.delayed(Duration(seconds: 0));
    return 3;
  }

  Future<List<Company>> syncCompanyfromApi() async {
    CompanyApiProvider api = new CompanyApiProvider();
    CompanyCtr crt = new CompanyCtr();
    List<int> devol = [];

    // Obtenemos los usuarios de autenticacion

    List<Company> data = await api.getAllCompanys();
    int contador = data.length;
    //print(contador);

    if (contador > 0) {
      await crt.deleteAllCompany();

      Company compa =
          new Company(codCompany: 0, strDesCompany: 'Elegir Empresa');
      crt.insertCompany(compa);

      for (var i = 0; i < contador; i++) {
        Company company = data[i];
        await crt.insertCompany(company);
      }
    }

    List<Company> companies = await crt.getAllCompany();

    return companies;
  }

  // Future<List<LastCompany>> getlastCompany() async {
  //   LastCompanyCrt crt = new LastCompanyCrt();
  //   crt.getLastCompany();
  //   try {
  //     crt.
  //   } catch (e) {
  //   }
  // }
}
