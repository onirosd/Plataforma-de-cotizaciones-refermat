import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotationProduct_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderCustomerQuotation extends StatefulWidget {
  //Nav({Key? key}) : super(key: key);

  @override
  _ProviderCustomerQuotation createState() => _ProviderCustomerQuotation();
}

class _ProviderCustomerQuotation extends State<ProviderCustomerQuotation> {
  //const customerQuotationScreen({Key? key}) : super(key: key);
  String _LoginUser = '';
  String _Company = '';
  String _Positon = '';
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;

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
    QuotationCrt0 crt = new QuotationCrt0();
    //QuotationCrt     crt1  = new QuotationCrt();
    //List<SelectQuotation> listQuotations =
    //  crt.getSelectQuotationByCustomer(customer.codCustomer.toString())
    //    as List<SelectQuotation>;

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
              delegate: SliverChildListDelegate([
                _HeadQuotationList(customer, _Positon),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'QuotationNew', (route) => false,
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
                  child: FutureBuilder(
                      future: crt.getSelectQuotationByCustomer(
                          customer.codCustomer.toString()),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return _ListQuotation(
                              snapshot.data, customer, _Positon);
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

class _ListQuotation extends StatelessWidget {
  //final Customer customer;
  final List<SelectQuotation> listQuotations;
  final Customer customer;
  final String posit;
  const _ListQuotation(this.listQuotations, this.customer, this.posit);

  Widget build(BuildContext context) {
    //QuotationCrt crt = new QuotationCrt();
    //List<SelectQuotation> listQuotations =
    //  await crt.getSelectQuotationByCustomer(customer.codCustomer.toString());
    const double widthbetweenrows = 25;
    const double widthbetweencolumns = 3;
    return Container(
      child: Row(
        children: [
          Expanded(
            // height: 500,
            flex: 3,
            //  width: 20,
            child: SizedBox(
              height: 500,
              child: ListView(
                //padding: const EdgeInsets.all(16),
                children: [
                  PaginatedDataTable(
                      //header: Text('Header Text'),
                      rowsPerPage: 7,
                      headingRowHeight: widthbetweenrows,
                      columnSpacing: widthbetweencolumns,
                      // dataRowHeight: widthbetweencolumns,
                      columns: [
                        DataColumn(label: Text('Nro.')),
                        DataColumn(label: Text('Fecha')),
                        DataColumn(label: Text('Monto')),
                        DataColumn(label: Text('Prod')),
                        DataColumn(label: Text('Est')),
                        DataColumn(
                            label: Text(
                          'Act',
                        )),
                      ],
                      source: _DataSource(
                          context, listQuotations, customer, posit)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<SelectQuotation> listQuotations;
  final Customer customer;
  final String position;

  _DataSource(this.context, this.listQuotations, this.customer, this.position) {
    _rows = listQuotations;
    _customer2 = customer;
  }

  QuotationCrt crt1 = new QuotationCrt();
  QuotationProductCrt crt2 = new QuotationProductCrt();
  AuthenticationCtr crt3 = new AuthenticationCtr();

  //_DataSource(this.context, this.customer, this.crt) {
  //  _rows = crt.getSelectQuotationByCustomer(customer.codCustomer) as List<SelectQuotation>;
  // }

  final BuildContext context;
  List<SelectQuotation> _rows = [];
  late Customer _customer2;
  // _rows.add(_Row('Cell A1', 'CellB1', 'CellC1', 1));

  int _selectedCount = 0;
  var change = 0;
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      /*onSelectChanged: (value) {
        int change = value == true ? 1 : -1;
        //if (value != null) {
        //  change = value;
        //}
        //_selectedCount = value;
        if (row.selected != change) {
          _selectedCount += change;
          assert(_selectedCount >= 0);
          row.selected = change;
          notifyListeners();
        }
      },*/

      cells: [
        DataCell(Text(row.id.toString().substring(
            row.id.toString().length - 10, row.id.toString().length))),
        DataCell(Text(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(row.fec.toString())))),
        DataCell(Text(row.total.toString())),
        DataCell(Text(row.prods.toString())),
        DataCell(row.numstate == 0
            ? Icon(
                Icons.error_rounded,
                color: Colors.red,
              )
            : (row.numstate == 1
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
              visible: row.numstate == 1 || row.numstate == 2 ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.manage_search,
                        color: Colors.blue, size: 30),
                    tooltip: 'Increase volume by 10',
                    onPressed: () async {
                      List<Quotation> data =
                          await crt1.getDataQuotationsperCode(row.id);

                      List<QuotationProduct> dataProducts =
                          await crt2.getDataQuotationProductsperCode(row.id);

                      List<Authentication> dataSalesPerson =
                          await crt3.getDataUserAutentication(data[0].userId!);

                      QuotationPlusProducts concatdata =
                          new QuotationPlusProducts(
                              quotat: data[0],
                              listproduct: dataProducts,
                              customer: _customer2,
                              salesperson: dataSalesPerson[0].strNameUser);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'QuotationShow', (route) => false,
                          arguments: concatdata);
                    },
                  ),
                ],
              ),
            ),
            position == 'SUPERVISOR' || position == 'ADMIN'
                ? Visibility(
                    visible: row.numstate == 2 ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_notifications_rounded,
                              color: Colors.blue, size: 30),
                          tooltip: 'Increase volume by 10',
                          onPressed: () async {
                            List<Quotation> data =
                                await crt1.getDataQuotationsperCode(row.id);
                            Quotation quo = data[0];
                            quo.state = "5";
                            quo.updateflg = 1;

                            crt1.updateQuotation(quo);

                            Navigator.pushNamedAndRemoveUntil(
                                context, 'listQuotas', (route) => false,
                                arguments: _customer2);
                          },
                        ),
                      ],
                    ),
                  )
                : Text(""),
            Visibility(
              visible: row.numstate == 0 || row.numstate == 5 ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: Colors.blue, size: 25),
                    tooltip: 'Increase volume by 10',
                    onPressed: () async {
                      List<Quotation> data =
                          await crt1.getDataQuotationsperCode(row.id);

                      List<QuotationProduct> dataProducts =
                          await crt2.getDataQuotationProductsperCode(row.id);

                      List<Authentication> dataSalesPerson =
                          await crt3.getDataUserAutentication(data[0].userId!);

                      QuotationPlusProducts concatdata =
                          new QuotationPlusProducts(
                              quotat: data[0],
                              listproduct: dataProducts,
                              customer: _customer2,
                              salesperson: dataSalesPerson[0].strNameUser);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'QuotationEdit', (route) => false,
                          arguments: concatdata);
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible:
                  row.numstate == 1 || row.numstate == 2 || row.numstate == 0
                      ? true
                      : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded,
                        color: Colors.blue, size: 25),
                    tooltip: 'Increase volume by 10',
                    onPressed: () async {
                      List<Quotation> data =
                          await crt1.getDataQuotationsperCode(row.id);

                      List<QuotationProduct> dataProducts =
                          await crt2.getDataQuotationProductsperCode(row.id);

                      List<Authentication> dataSalesPerson =
                          await crt3.getDataUserAutentication(data[0].userId!);

                      QuotationPlusProducts concatdata =
                          new QuotationPlusProducts(
                              quotat: data[0],
                              listproduct: dataProducts,
                              customer: _customer2,
                              salesperson: dataSalesPerson[0].strNameUser);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'QuotationCopy', (route) => false,
                          arguments: concatdata);
                    },
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
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
