import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/modelscrud/billing_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/providers/provider.home.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderCustomerBilling extends StatefulWidget {
  ProviderCustomerBilling({Key? key}) : super(key: key);

  @override
  _ProviderCustomerBillingState createState() =>
      _ProviderCustomerBillingState();
}

class _ProviderCustomerBillingState extends State<ProviderCustomerBilling> {
  String _LoginUser = '';
  String _Company = '';
  String _Positon = '';
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;

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
      if (mounted) {
        setState(() => _source = source);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    BillingCrt crt = new BillingCrt();
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
                const SizedBox(height: 5),
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
                                context, 'BillingNew', (route) => false,
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
                                    'Nuevo Registro Recibo',
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
                      future: crt.getSelectBillingByCustomer(
                          customer.codCustomer.toString()),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return _ListBilling(
                              snapshot.data, _Positon, customer);
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

class _ListBilling extends StatelessWidget {
  final List<SelectBilling> listbilling;
  final String position;
  final Customer customer;
  const _ListBilling(this.listbilling, this.position, this.customer);

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
                    horizontalMargin: 0,

                    //header: Text('Header Text'),
                    rowsPerPage: 8,
                    headingRowHeight: widthbetweenrows,
                    columnSpacing: widthbetweencolumns,
                    // dataRowHeight: widthbetweencolumns,
                    columns: [
                      DataColumn(
                          label: Text('Id'),
                          numeric: true,
                          onSort: (colIndex, asc) {}),
                      DataColumn(label: Text('Doc. Fiscal')),
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('Vendedor')),
                      DataColumn(label: Text('Est')),
                      DataColumn(
                          label: Text(
                        'Act',
                      )),
                    ],
                    source:
                        _DataSource(context, listbilling, position, customer),
                  ),
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
  final List<SelectBilling> listBilling;
  BillingCrt crt = new BillingCrt();
  String position;
  Customer customer;
  _DataSource(this.context, this.listBilling, this.position, this.customer) {
    _rows = listBilling;
  }

  //_DataSource(this.context, this.customer, this.crt) {
  //  _rows = crt.getSelectQuotationByCustomer(customer.codCustomer) as List<SelectQuotation>;
  // }

  final BuildContext context;
  List<SelectBilling> _rows = [];
  // _rows.add(_Row('Cell A1', 'CellB1', 'CellC1', 1));

  int _selectedCount = 0;
  var change = 0;
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      //color: MaterialStateProperty.all(Color(0xFF5D5F6E)) ,
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
        DataCell(Text("_")),
        DataCell(Text(row.ruc.toString())),
        // DataCell(Text(row.date)),
        DataCell(Text(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(row.date.toString())))),
        DataCell(Text(row.salesperson.toString())),
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
                      List<Billing> data =
                          await crt.getDataBillingsperCode(row.id);

                      Billingandflag billingandflag =
                          new Billingandflag(billingdata: data[0], switch1: 0);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'BillingShow', (route) => false,
                          arguments: billingandflag);
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
                            List<Billing> data =
                                await crt.getDataBillingsperCode(row.id);
                            Billing bill1 = data[0];
                            bill1.flgState = 5;

                            crt.updateBilling(bill1);

                            Navigator.pushNamedAndRemoveUntil(
                                context, 'listBilling', (route) => false,
                                arguments: customer);
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
                        color: Colors.blue, size: 30),
                    tooltip: 'Increase volume by 10',
                    onPressed: () async {
                      List<Billing> data =
                          await crt.getDataBillingsperCode(row.id);

                      Billingandflag billingandflag =
                          new Billingandflag(billingdata: data[0], switch1: 0);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'BillingEdit', (route) => false,
                          arguments: billingandflag);
                    },
                  ),
                ],
              ),
            )
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
  final Customer customer;
  final String position;

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
