//import 'package:appcotizaciones/src/pages/page.customer.new.dart';
//import 'package:appcotizaciones/src/pages/page.home.dart';
//import 'package:appcotizaciones/src/pages/main_page.dart';
//import 'package:appcotizaciones/src/providers/bottom_navigation.text';
//import 'package:appcotizaciones/src/preferences/MyPreferences.dart';

import 'package:appcotizaciones/src/preferences/sharedpreferencestest.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/providers/customer_provider.dart';
import 'package:appcotizaciones/src/routes/routes.dart';
import 'package:appcotizaciones/src/screens/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/*
Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
*/
void main() {
  //print("entrando aqui primero");
  //getImageFileFromAssets('files/user.png');

  runApp(AppState());
}

//void main() => runApp(AppState());

class AppState extends StatelessWidget {
  //Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  SharedPreferencesTest sh = new SharedPreferencesTest();

  @override
  Widget build(BuildContext context) {
    bool conectividad = false;

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          conectividad = true;
          break;
        case ConnectivityResult.wifi:
          conectividad = true;
          break;
        case ConnectivityResult.none:
        default:
          conectividad = false;
      }

      // print(source);
      sh.setInternet(conectividad);
    });
    //print(sh.getInternet());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider(), lazy: false),
      ],
      child: MyApp(),
    );
  }
}

/*void main() {
  runApp(MyApp());
}
*/

//@override
//void initState() {
//UserSimplePreferences pref = new UserSimplePreferences();
//pref.init();
//}

class MyApp extends StatelessWidget {
  SharedPreferencesTest sh = new SharedPreferencesTest();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //sh.getInternet().then((value) => print(value));

    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        /*Cuando no esta definida la ruta, se dispara este comando generateroute*/
        //print('Ruta llamada : ${settings.name}');
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: Nav(),
      //home: MainPage(),
    );
  }
}
