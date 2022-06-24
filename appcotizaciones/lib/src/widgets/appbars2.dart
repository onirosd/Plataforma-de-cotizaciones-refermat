import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/utils/connectionUtil.dart';
import 'package:flutter/material.dart';

class AppBars extends AppBar {
  // @override
  /*void initState() {
    final MyConnectivity _connectivity = MyConnectivity.instance;

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      print(source);
    });
    
    // super.initState();
  }
*/
  //AppBars({required this.loginuser});

  AppBars(
      {required this.loginuser,
      required this.company,
      required this.context,
      required this.isOnline})
      : super(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              customBorder: new CircleBorder(),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              splashColor: Colors.white,
              child: new Icon(
                Icons.logout,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          // title: Text('El usuario sera el sigueinte : $appBarTitleUser'),
          actions: [
            Container(
              // signal_wifi_off_sharp
              // signal_wifi_4_bar_sharp
              child: new Icon(
                isOnline
                    ? Icons.signal_wifi_4_bar_sharp
                    : Icons.signal_wifi_off_sharp,
                size: 35,
                color: Colors.lightGreen[900],
              ),
            ),
            SizedBox(width: 10),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    loginuser,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      new Icon(
                        Icons.business,
                        size: 14,
                        color: Colors.black,
                      ),
                      Text(
                        company,
                        style: TextStyle(
                            color: Colors.blueGrey[900], fontSize: 12.0),
                      ),
                    ],
                  )
                ]),
            SizedBox(width: 10),
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[700],
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
              alignment: Alignment.center,
            ),
            /*Container(
              margin: EdgeInsets.all(5.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://static.wikia.nocookie.net/marveldatabase/images/5/53/Stan_Lee.jpg/revision/latest/top-crop/width/360/height/450?cb=20070328161012'),
                  radius: 25.0),
            ),*/
            /* Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              child: Text('SL'),
              backgroundColor: Colors.brown,
            ),
          )*/
          ],
        );
  String loginuser;
  String company;
  BuildContext context;
  bool isOnline;
}
