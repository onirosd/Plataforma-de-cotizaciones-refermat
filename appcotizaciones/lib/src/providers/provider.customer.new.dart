import 'dart:math';

import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_provider.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

//import 'db_provider.dart';

class ProviderCustomerNew extends StatefulWidget {
  //Nav({Key? key}) : super(key: key);

  @override
  _ProviderCustomerNew createState() => _ProviderCustomerNew();
}

class _ProviderCustomerNew extends State<ProviderCustomerNew> {
  int _selectedIndex = 1;
  String _LoginUser = '';
  String _Company = '';
  String _CodCompany = '';
  bool _isInternet = true;

  Customer customer = new Customer();

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((res) {
      setState(() {
        _LoginUser = res.getString("usuario") ?? '';
        _Company = res.getString("empresa") ?? '';
        _CodCompany = res.getString("codcompany") ?? '';
        //_Company = res.getString("codCom") ?? '';
      });
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() {});
      }
      _source = source;
    });
  }

  _onItemTapped(int page) async {
    if (page == 2) {
      await showSearch(
        context: context,
        delegate: CustomerSearchDelegate(),
      );
    }
    if (page == 1) {
      Navigator.pushNamedAndRemoveUntil(
          context, 'customerNew', (route) => false);
    }
    if (page == 0) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: Size(300, 72),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;
    // print(conectividad);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, 'home');

        //  _moveToScreen2(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBars(
          loginuser: _LoginUser,
          company: _Company,
          context: context,
          isOnline: _isInternet,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: customerProvider.formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Doc. Fiscal"),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    keyboardType: TextInputType.number,
                    validator: (ruc) {
                      // final isDigitsOnly = int.tryParse(ruc!);
                      // if (isDigitsOnly == null) {
                      //   return 'Debes Ingresar solo numeros.';
                      // } else {

                      //  CustomerCtr crt = new CustomerCtr();
                      //  List<Customer> res =  crt.getCustomerByRUC(ruc, _CodCompany);

                      // }

                      final isDigitsOnly = int.tryParse(ruc!);
                      return isDigitsOnly == null
                          ? 'Debes Ingresar solo numeros.'
                          : null;
                    },
                    onChanged: (value) {
                      customer.numRucCustomer = value.toString();
                    },
                  ),
                  /*const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Rut. Cliente"),
                    validator: (rut) => rut == null || rut == ''
                        ? 'Este Campo no puede estar en blanco'
                        : null,
                    onSaved: (value) {
                      customer.numRut = value.toString();
                    },
                  ),*/
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nombre"),
                    validator: (name) => name == null || name == ''
                        ? 'Este Campo no puede estar en blanco'
                        : null,
                    onChanged: (value) {
                      customer.strName = value.toString();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Telefono"),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    keyboardType: TextInputType.number,
                    validator: (ruc) {
                      final isDigitsOnly = int.tryParse(ruc!);
                      return isDigitsOnly == null
                          ? 'Debes Ingresar solo numeros.'
                          : null;
                    },
                    onChanged: (value) {
                      customer.strCelphone = value.toString();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (email) => email == null || email == ''
                        ? 'Este Campo no puede estar en blanco'
                        : null,
                    onChanged: (value) {
                      customer.strMail = value.toString();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Dirección"),
                    validator: (dir) => dir == null || dir == ''
                        ? 'Este Campo no puede estar en blanco'
                        : null,
                    onChanged: (value) {
                      customer.strAddress = value.toString();
                    },
                  ),
                  const SizedBox(height: 50),
                  OutlinedButton(
                    style: raisedButtonStyle,
                    // style: wi,
                    onPressed: customerProvider.isLoading
                        ? null
                        : () async {
                            print("Impresion de los clientes !!");
                            print(customer);

                            final msg_success = SnackBar(
                                content: Text(
                                    'El cliente fue registrado con exito ! '));
                            final msg_wait = SnackBar(
                                content: Text('Espere un momento....'));
                            final msg_err = SnackBar(
                                content: Text(
                                    'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                            final f = customerProvider.formKey;
                            customerProvider.isLoading = true;
                            FocusScope.of(context).unfocus();
                            //final f = customerProvider.formKey;

                            if (f != null) {
                              final fcur = f.currentState;
                              if (fcur != null) {
                                if (fcur.validate()) {
                                  CustomerCtr crt = new CustomerCtr();

                                  List<Customer> listclientes =
                                      await crt.getCustomerByRUC(
                                          customer.numRucCustomer.toString(),
                                          _CodCompany);

                                  print(listclientes.length.toString() +
                                      "---->" +
                                      " cantidad clientes" +
                                      " -->" +
                                      customer.numRucCustomer.toString());

                                  if (listclientes.length == 0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(msg_wait);
                                    fcur.save();

                                    String latitude = "";
                                    String longitude = "";

                                    try {
                                      Position coordenadas =
                                          await _getGeoLocationPosition();
                                      latitude =
                                          coordenadas.latitude.toString();
                                      longitude =
                                          coordenadas.longitude.toString();
                                    } catch (e) {
                                      print(
                                          "Tenemos un error : " + e.toString());
                                    }

                                    //Random random = new Random();
                                    //int randomNumber = random.nextInt(1000);
                                    // customer.numRucCustomer =
                                    //     customer.numRucCustomer.toString();
                                    customer.codCustomer = _CodCompany +
                                        customer.numRucCustomer.toString();
                                    customer.numRut = '';
                                    customer.asyncFlag = 0;
                                    customer.codCompany =
                                        int.parse(_CodCompany);
                                    customer.latitude = latitude;
                                    customer.longitude = longitude;
                                    customer.flagForceMultimedia = 0;
                                    customer.flagTipoMultimedia = 0;

                                    final result = await customerProvider
                                        .insertCustomer(customer);

                                    try {
                                      if (result > 0) {
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        fcur.reset();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(msg_success);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(msg_err);
                                      }
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(msg_err);
                                    }
                                    customerProvider.isLoading = false;
                                  } else {
                                    final msg_err = SnackBar(
                                        content: Text(
                                            'Este RUC :  ${customer.numRucCustomer.toString()} ya existe en la BD.'));
                                    customerProvider.isLoading = false;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(msg_err);
                                  }
                                  //    await Future.delayed(Duration(seconds: 2));
                                  // print(result);
                                } else {
                                  customerProvider.isLoading = false;
                                }
                              } else {
                                customerProvider.isLoading = false;
                              }
                            } else {
                              customerProvider.isLoading = false;
                            }
                          },
                    child: Row(
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 30.0,
                        ),
                        Icon(
                          Icons.person_add_alt_1,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Agregar Cliente',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  child: CustomerNew(
          //    loginuser: _LoginUser, company: _Company, context: context),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1),
              label: 'Agregar',
              backgroundColor: Color.fromRGBO(0, 47, 80, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: 'Buscar',
              backgroundColor: Colors.green,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (int page) async {
            _onItemTapped(page);
          },
        ),
      ),
    );
  }
}
