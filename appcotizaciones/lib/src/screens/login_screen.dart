//import 'package:appcotizaciones/src/api/api.autentication.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/lastCompany.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/models/tiperson.dart';
import 'package:appcotizaciones/src/modelscrud/api.autentication_crt.dart';
import 'package:appcotizaciones/src/modelscrud/api.company_crt.dart';
import 'package:appcotizaciones/src/modelscrud/api.configGeneral_crt.dart';
import 'package:appcotizaciones/src/modelscrud/company_crt.dart';
import 'package:appcotizaciones/src/modelscrud/lastCompany_crud.dart';
import 'package:appcotizaciones/src/modelscrud/tiperson_crt.dart';
import 'package:appcotizaciones/src/preferences/sharedpreferencestest.dart';
import 'package:appcotizaciones/src/providers/authentication_provider.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/ui/input_decoration.dart';
import 'package:appcotizaciones/src/widgets/auth_background.dart';
import 'package:appcotizaciones/src/widgets/card_container.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isInternet = false;
  String _mensaje = "";
  String _mensaje_Internet = "";

  late Future<int> _usuarios_Sincronizados;
  late Future<List<Company>> _list_company;

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  List<Company> _company = [];
  List<LastCompany> _lastCompany = [];

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  void initState() {
    super.initState();
    //print("entrando aqui primero");
    getImageFileFromAssets('user.png');
    // getImageFileFromAssets('refermat.png');
    // getImageFileFromAssets('suminox.png');

    ApiCompany apicompany = new ApiCompany();
    _list_company = apicompany.syncCompanyfromApi();
    //_usuarios_Sincronizados = api.syncAuthenticationfromApi();
    //apicompany.syncCompanyfromApi();

    setState(() {
      getlastCompany();
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (mounted) {
        setState(() => _source = source);
      }
    });
  }

  Future getlastCompany() async {
    LastCompanyCrt crt = new LastCompanyCrt();
    // crt.getLastCompany();

    try {
      // setState(() {

      crt.getLastCompany().then((value) {
        if (value.length == 0) {
          _lastCompany.add(new LastCompany(company: 0, lastDate: ''));
        } else {
          _lastCompany = value;
        }
      });

      // });
    } catch (err) {
      print(err);
    }
  }

  void _showAlert(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Estado de Sincronización : "),
              content: Text(mensaje),
            ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;

    _mensaje_Internet = _isInternet ? 'Online' : 'Modo offline';

    ApiAutentication api = new ApiAutentication();
    return Scaffold(
      body: FutureBuilder(
          future: _list_company,
          builder:
              (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              //if (_IsInternet) {
              // _mensaje = "Se sincronizaron :  " + snapshot.data.toString();

              return AuthBackground(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 250),
                      CardContainer(
                          child: Column(
                        children: [
                          //SizedBox(height: 10),
                          Text('AppVentas 3.4.4',
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 30),
                          ChangeNotifierProvider(
                              create: (_) => AuthenticationProvider(),
                              child: _LoginForm2(
                                  _isInternet, snapshot.data!, _lastCompany)),
                        ],
                      )),
                      SizedBox(height: 50),
                      // Text(_mensaje),
                      SizedBox(height: 5),
                      Text(_mensaje_Internet),

                      // Text(
                      // 'Crear una nueva cuenta',
                      //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              );
              //return Text("asa");
              //print("---------------");
              //   print(snapshot.data);
              // return Center(child: Text(snapshot.data!.length.toString()));
            }
          }),
    );
  }
}

class _LoginForm2 extends StatefulWidget {
  final bool connect;
  List<Company> companies;
  List<LastCompany> lastCompany;

  _LoginForm2(this.connect, this.companies, this.lastCompany);

  @override
  State<_LoginForm2> createState() =>
      __LoginForm2State(connect, companies, lastCompany);
}

class __LoginForm2State extends State<_LoginForm2> {
  final bool connect;
  List<Company> companies;
  List<LastCompany> lastCompany;

  __LoginForm2State(this.connect, this.companies, this.lastCompany);

  final MyConnectivity connect2 = MyConnectivity.instance;
  Map _source2 = {ConnectivityResult.none: false};
  bool _isInternet2 = false;

  late Company selectcompa = new Company();
  int valdefault_selectcompa = 0;
  Future getUsuarios(int company) async {
    ApiAutentication api = new ApiAutentication();
    try {
      //setState(() {
      await api.syncAuthenticationfromApi(company);
      //});
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();

    connect2.initialise();
    connect2.myStream.listen((source) {
      if (mounted) {
        setState(() => _source2 = source);
      }
    });
  }

  SharedPreferencesTest sh = new SharedPreferencesTest();
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<AuthenticationProvider>(context);

    _isInternet2 =
        _source2.keys.toList()[0] == ConnectivityResult.none ? false : true;

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              DropdownButtonFormField(
                // decoration: textInputDecoration,
                onSaved: (val) async {
                  print(val.toString() + '_________');
                  //  setState(() {
                  loginForm.company = val.toString();
                  //});
                },
                value: lastCompany[0].company,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '',
                    labelText: 'Empresa',
                    prefixIcon: Icons.business),
                items: companies.map((company) {
                  return DropdownMenuItem(
                    value: company.codCompany!,
                    child: Text(company.strDesCompany!),
                  );
                }).toList(),
                onChanged: !_isInternet2
                    ? null
                    : (val) async {
                        print(">>> impresion de la conexion");
                        print(_isInternet2);

                        if (_isInternet2) {
                          EasyLoading.show(status: 'Cargando...');
                          loginForm.company = val.toString();

                          companies.forEach((element) {
                            if (element.codCompany.toString() ==
                                val.toString()) {
                              selectcompa = element;
                            }
                          });

                          await getUsuarios(
                              int.parse(selectcompa.codCompany.toString()));

                          EasyLoading.dismiss();
                          valdefault_selectcompa = 1;
                        } else {
                          print(">>> entramos aqui");
                          final msg_no_internet = SnackBar(
                              content: Text(
                                  'No hay Internet para cambiar de Empresa !!'));

                          ScaffoldMessenger.of(context)
                              .showSnackBar(msg_no_internet);
                        }
                      },
              ),
              TextFormField(
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '',
                    labelText: 'Usuario',
                    prefixIcon: Icons.verified_user),
                onChanged: (value) => loginForm.email = value,
                validator: (name) => name == null || name == ''
                    ? 'El usuario no puede estar en blanco'
                    : null,
                //onSaved: (value) {
                //  usuario = value.toString();
                // customer.numRut = value.toString();
                //},
              ),
              SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '*****',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                //onSaved: (value) {
                //  password = value.toString();
                // customer.numRut = value.toString();
                //},
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null || value != '')
                      ? null
                      : 'La contraseña no puede estar en blanco';
                },
              ),
              SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      child: Text(
                        loginForm.isLoading ? 'Espere' : 'Ingresar',
                        style: TextStyle(color: Colors.white),
                      )),
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          final msg_success = SnackBar(
                              content:
                                  Text('Usuario logueado correctamente !!'));
                          final msg_incorrect = SnackBar(
                              content: Text(
                                  'Credenciales incorrectas !! , intentelo de nuevo.'));
                          final msg_err = SnackBar(
                              content: Text(
                                  'Tuvimos un error en el registro !! , Intentelo de nuevo.'));
                          FocusScope.of(context).unfocus();

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          await Future.delayed(Duration(seconds: 1));
                          /* Obtenemos los datos de la empresa seleccionada*/

                          if (valdefault_selectcompa == 0) {
                            loginForm.company =
                                lastCompany[0].company.toString();
                          }

                          /* Obtenemos la información de la empresa para validar el logueo
                             del usuario , se supone que ya hubo internet para descargar esta tabla */

                          late Company selectcompa = new Company();
                          companies.forEach((element) {
                            if (loginForm.company == '') {
                              selectcompa = companies[0];
                            } else {
                              if (element.codCompany.toString() ==
                                  loginForm.company) {
                                selectcompa = element;
                              }
                            }
                          });

                          /* validamos al usuario por logueo y empresa seleccionada*/
                          Authentication authResult =
                              await loginForm.searchUserStr(loginForm.email,
                                  loginForm.password, selectcompa.codCompany!);

                          final f = loginForm.formKey;
                          String msg = "";
                          // print(">>> llegamos");
                          try {
                            if (authResult.codUser > 0) {
                              /* Se logueo correctamente */
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(msg_success);
                              /*#### ACTUALIZAMOS EL LASTCOMPANY SI SE LOGUEA CON EXITO ####*/
                              /* Se pudo loguear ya que la tabla empresas estaba descargada
                              , por ende esta parte va a funcionar */
                              LastCompanyCrt crt = new LastCompanyCrt();
                              LastCompany lastcompany = new LastCompany(
                                  company: int.parse(
                                      selectcompa.codCompany!.toString()),
                                  lastDate: '');
                              await crt.insLastCompany(lastcompany);

                              /*#### ACTUALIZAMOS EL LASTCOMPANY SI SE LOGUEA CON EXITO ####*/

                              /*#### TRAEMOS LA IMAGEN DE LA EMPRESA QUE SELECCIONAMOS  ####*/
                              /* Hacemos un try catch , para que recupera la imagen de la empresa 
                              si es que puede, si es que se tiene de internet */

                              try {
                                final ByteData byteData =
                                    await NetworkAssetBundle(Uri.parse(
                                            selectcompa.strLogo.toString()))
                                        .load("");
                                final Uint8List bytes =
                                    byteData.buffer.asUint8List();
                                String str_image =
                                    selectcompa.str_image.toString();
                                String dir =
                                    (await getTemporaryDirectory()).path;
                                String fullPath = '$dir/$str_image';
                                File file = File(fullPath);

                                await file.writeAsBytes(bytes);
                                // print(">>> entramos aqui3");
                                // print(file.path);

                              } catch (error) {
                                // print(">> salimos al catch");
                                print(error);
                              }

                              /*#### TRAEMOS LA IMAGEN DE LA EMPRESA QUE SELECCIONAMOS  ####*/

                              TiPersonCtr c1 = new TiPersonCtr();
                              TiPerson person = TiPerson();

                              if (_isInternet2) {
                                /* Obtenemos las reglas del usuario para la sesion actual */
                                ApiConfigGeneral configgeneral =
                                    new ApiConfigGeneral();

                                configgeneral
                                    .getConfigGeneraluser(authResult.codUser);
                                /* tenemos conexion a bd por ello consultamos mediante api rest la regla.
                                   del usuario a loguear */
                                int validar = await configgeneral
                                    .executionsGeneralUserRules(
                                        authResult.codUser);

                                if (validar == 0) {
                                  loginForm.isLoading = false;
                                  loginForm.email = '';
                                  loginForm.password = '';
                                  // f.currentState!.reset();
                                  //loginForm.formKey.currentState.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Usuario sin reglas !! , llamar a sistemas. ")));

                                  return null;
                                }

                                // /* rules 1 : Al inicio del logeuo debe preguntar si le ordenan a limpiar su bd */
                                // print("entrando rules clean");
                                // ResponseError resp = await configgeneral
                                //     .executionRuleCleanTables();

                                /* Revisamos si es el mismo usuario el que se esta logueando en este celular, si es un distinto o es primer loguep , se eliminan
                               las tablas principales y complementarias , y se carga informacion de quotation, billings y complementos  */

                                ResponseError resp = ResponseError(
                                    description: '', error: 0, success: 0);

                                ResponseError resp1 = ResponseError(
                                    description: '', error: 0, success: 0);

                                int cargamos_tablas_principales =
                                    await configgeneral
                                        .cleanUpdatePrincipaltables(
                                            authResult.codUser);

                                if (cargamos_tablas_principales == 1) {
                                  /* 1. Forzamos la carga de tablas complementarias */
                                  resp = await configgeneral
                                      .executionRuleLoadComplements(
                                          authResult.codUser,
                                          1,
                                          authResult.codCompany.toString());

                                  person = await c1.getdataPersonfromUser_V2(
                                      authResult.codUser);

                                  /* 2. sincronizamos las cotizaciones y recibos */
                                  resp1 = await configgeneral
                                      .executionRuleUploadSyncQuoBillLogueo(
                                          authResult.codUser,
                                          person.strPosition.toString(),
                                          authResult.codCompany.toString());
                                } else {
                                  person = await c1.getdataPersonfromUser_V2(
                                      authResult.codUser);
                                }

                                /* 2. sincronizar los clientes y la galeria */
                                /* Siempre que tengamos internet deberemos de intentar hacer sincronizacion
                                     de nuevos clientes  , deberiamos de crear un proceso para detectar nuevos clientes */

                                ResponseError resp2 = await configgeneral
                                    .executionRuleLoadClientsGallery(
                                        authResult.codUser,
                                        authResult.codCompany,
                                        0);

                                msg = resp.description +
                                    "\n\n" +
                                    resp1.description;

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(msg)));
                              } else {
                                /* Obtenemos las reglas del usuario para la sesion actual */
                                ApiConfigGeneral configgeneral =
                                    new ApiConfigGeneral();

                                /* Traemos las regloas de la BD , si es primer logueo necesita esta
                                regla , por ende si no la encuentra se cae o si intenta loguearse con otro 
                                usuario  */

                                int validar = await configgeneral
                                    .executionsGeneralUserRules(
                                        authResult.codUser);

                                if (validar == 0) {
                                  loginForm.isLoading = false;
                                  f.currentState!.reset();
                                  //loginForm.formKey.currentState.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Usuario no tiene cargado reglas!! , necesita conectarse a internet. ")));

                                  return null;
                                }

                                person = await c1.getdataPersonfromUser_V2(
                                    authResult.codUser);
                              }

                              /* Despues del segundo las reglas generales ya debieron de haber sido ejecutadas*/

                              // print(authResult.strPosition.toString() +
                              //     " -----------------------------  ");

                              sh.setPosition(person.strPosition.toString());
                              sh.setcodUser(authResult.codUser);
                              sh.setUser(authResult.strNameUser);
                              sh.setCompany(
                                  selectcompa.strDesCompany.toString());
                              sh.setCodCompany(
                                  authResult.codCompany.toString());
                              sh.setCodList(authResult.codList.toString());
                              sh.setAlmacen(authResult.codTiAlmacen.toString());

                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(msg_incorrect);
                            }
                          } catch (error) {
                            print(error);
                            ScaffoldMessenger.of(context).showSnackBar(msg_err);
                          }

                          loginForm.isLoading = false;
                        })
            ],
          )),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
