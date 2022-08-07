import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/galleriespluscustomer.dart';
import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_crt.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_detail_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class providercustomerGallery extends StatefulWidget {
  providercustomerGallery({Key? key}) : super(key: key);

  @override
  State<providercustomerGallery> createState() =>
      _providercustomerGalleryState();
}

class _providercustomerGalleryState extends State<providercustomerGallery> {
  //const customerQuotationScreen({Key? key}) : super(key: key);
  String _LoginUser = '';
  String _Company = '';
  String _Positon = '';
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;
  int _forzarfoto = 0;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((res) {
      setState(() {
        _LoginUser = res.getString("usuario") ?? '';
        _Company = res.getString("empresa") ?? '';
        _Positon = res.getString("posicion") ?? '';
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;

    GalleryCtr crt = new GalleryCtr();
    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;

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
        body: CustomScrollView(
          slivers: [
            SliverList(
              key: Key('001'),
              delegate: SliverChildListDelegate([
                _HeadQuotationList(customer, _Positon),
                Visibility(
                  visible: _forzarfoto == 1 ? true : false,
                  child: Text(
                    'ALERTA : Debe registrar una galeria para este cliente. !!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
                Container(
                  key: Key('00222'),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                'Gallery_new_customer', (route) => false,
                                arguments: customer);
                          },
                          //color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Nuevo Registro',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(width: 100),
                    ],
                  ),
                ),
                Container(
                  key: Key('00223'),
                  child: FutureBuilder(
                      future: crt
                          .getGalleryCustomers(customer.codCustomer.toString()),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        _forzarfoto = customer.flagForceMultimedia!;

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          final DataTableSource _data =
                              MyData(context, snapshot.data, customer);
                          const double widthbetweenrows = 25;
                          const double widthbetweencolumns = 3;
                          return Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 500,
                                  child: ListView(
                                    children: [
                                      //padding: const EdgeInsets.all(16),

                                      PaginatedDataTable(
                                        //header: Text('Header Text'),
                                        rowsPerPage: 7,
                                        headingRowHeight: widthbetweenrows,
                                        columnSpacing: widthbetweencolumns,
                                        showCheckboxColumn: false,
                                        // dataRowHeight: widthbetweencolumns,
                                        // header: const Text('Galeria de fotos'),
                                        columns: const [
                                          DataColumn(label: Text('Nro.')),
                                          DataColumn(
                                              label: Text('T.Multimedia')),
                                          DataColumn(label: Text('Fecha')),
                                          DataColumn(label: Text('Est')),
                                          DataColumn(label: Text('Act')),
                                        ],
                                        source: _data,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                )
              ]),
            )
            // _CustomAppBar()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.grey[600],
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
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: 'Buscar',
              backgroundColor: Colors.green,
            ),
          ],
          currentIndex: 1,
          // selectedItemColor: Colors.blue,
          onTap: (int page) async {
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
              Navigator.pushNamedAndRemoveUntil(
                  context, 'home', (route) => false);
            }
          },
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<SelectGallery> listGalleryinit;
  final Customer customer;

  MyData(this.context, this.listGalleryinit, this.customer) {
    listGallery = listGalleryinit;
    _customer2 = customer;
  }

  //_DataSource(this.context, this.customer, this.crt) {
  //  _rows = crt.getSelectQuotationByCustomer(customer.codCustomer) as List<SelectQuotation>;
  // }

  final BuildContext context;
  List<SelectGallery> listGallery = [];
  late Customer _customer2;

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => listGallery.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(listGallery[index].codGallery.toString())),
      DataCell(Text(listGallery[index].desTipomultimedia)),
      DataCell(Text(listGallery[index].fechaCreacion.toString())),
      DataCell(listGallery[index].flatEstado == 0
          ? Icon(
              Icons.cloud_off_sharp,
              color: Colors.red,
            )
          : (listGallery[index].flatEstado == 1
              ? Icon(
                  Icons.cloud_off_sharp,
                  color: Colors.red,
                )
              : Icon(
                  Icons.cloud_done_outlined,
                  color: Colors.green,
                ))),
      DataCell(Row(
        children: [
          Visibility(
            visible: listGallery[index].flatEstado == 0 ? true : false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: Colors.blue, size: 25),
                  tooltip: 'Increase volume by 10',
                  onPressed: () async {
                    GalleryCtr crt = new GalleryCtr();
                    GalleryDetailCtr crt1 = new GalleryDetailCtr();

                    List<Gallery> gallery1 = await crt
                        .getGallery(listGallery[index].codGallery.toString());

                    List<GalleryDetail> gallerydetail =
                        await crt1.getGalleryDetail(
                            listGallery[index].codGallery.toString());

                    // List<Authentication> dataSalesPerson =
                    //     await crt3.getDataUserAutentication(data[0].userId!);
                    GalleriesplusCustomer data = new GalleriesplusCustomer(
                        customer: _customer2,
                        gallery: gallery1.first,
                        galleriesdetail: gallerydetail);

                    Navigator.pushNamedAndRemoveUntil(
                        context, 'CustomerGalleryEdit', (route) => false,
                        arguments: data);
                  },
                ),
              ],
            ),
          ),
        ],
      )),
    ]);
  }
}

class _HeadQuotationList extends StatelessWidget {
  // const headQuotation({Key? key}) : super(key: key);
  final String position;
  final Customer customer;
  const _HeadQuotationList(this.customer, this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    image: AssetImage('assets/no-image.jpg'),
                    height: 50,
                  ),
                ),
              ),
              // SizedBox(width: 100),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cliente : " + customer.strName!),
                    Text("Doc. Fiscal : " + customer.numRucCustomer!),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text("Leyenda de Iconos Informativos"),
                    ],
                  ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  //flex: 2,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Pre - Procesado",
                          style: TextStyle(fontSize: 10),
                        ),
                        Icon(
                          Icons.error_rounded,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                ],
              )),
              Expanded(
                  //flex: 2,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Procesado - Sin Sincronizar",
                          style: TextStyle(fontSize: 10),
                        ),
                        Icon(
                          Icons.cloud_off_sharp,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              Expanded(
                  //flex: 2,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Procesado - Sincronizado",
                          style: TextStyle(fontSize: 10),
                        ),
                        Icon(
                          Icons.cloud_done_outlined,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              Expanded(
                  //flex: 2,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Edición - Permitida",
                          style: TextStyle(fontSize: 10),
                        ),
                        Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              Expanded(
                  //flex: 2,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Visualizar - Permitida",
                          style: TextStyle(fontSize: 10),
                        ),
                        Icon(Icons.manage_search, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              )),
              position == 'SUPERVISOR' || position == 'ADMIN'
                  ? Expanded(
                      //flex: 2,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "Habilitar Edición",
                                style: TextStyle(fontSize: 10),
                              ),
                              Icon(Icons.edit_notifications_rounded,
                                  color: Colors.blue),
                            ],
                          ),
                        ),
                      ],
                    ))
                  : Text(""),
            ],
          )
        ],
      ),
    );
  }
}
