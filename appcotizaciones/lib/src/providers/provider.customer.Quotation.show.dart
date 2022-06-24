import 'dart:convert';
import 'dart:io' as io2;

import 'package:appcotizaciones/src/constants/RepQuotation.dart';
import 'package:appcotizaciones/src/constants/listController.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/delivery_time_model.dart';
import 'package:appcotizaciones/src/models/delivery_type_model.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/pay_condition_model.dart';
import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/models/report_quotation.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryTime_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryType_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paycondition_crt.dart';
import 'package:appcotizaciones/src/modelscrud/product_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotationProduct_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/screens/product_add_form.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/utils/size_config.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:appcotizaciones/src/widgets/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/company.dart';
import '../modelscrud/company_crt.dart';

class CustomerQuotationShow extends StatefulWidget {
  CustomerQuotationShow({Key? key}) : super(key: key);
  //final Map data;
  //CustomerQuotationShow({required this.data});

  @override
  _CustomerQuotationShowState createState() => _CustomerQuotationShowState();
}

class _CustomerQuotationShowState extends State<CustomerQuotationShow> {
  String _LoginUser = '';
  int _CodUser = 0;
  String _Company = '';
  String _CodCompany = '';

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;

  /*Integration */

  DateTime selectedDate = DateTime.now();
  final DateFormat format = DateFormat("yyyy-MM-dd");
  late String dropdownvalue;

  bool loading = true, loader = false;

  late Quotation _quotat_final;
  List<QuotationProduct> _listproduct_final = [];
  late Customer _cust;
  String _salesperson = "";

  List<PayCondition> _out_paycondition = [];
  List<DeliveryTime> _out_deliverytime = [];
  List<DeliveryType> _out_deliverytype = [];
  List<Currency> _out_currency = [];

  List<Product> products = <Product>[];
  List<Currency> currency = <Currency>[];
  List<DeliveryType> deliveryTypes = <DeliveryType>[];
  List<DeliveryTime> deliveryTimes = <DeliveryTime>[];
  List<PayCondition> payConditions = <PayCondition>[];

  late Currency selectedCurrency;
  late DeliveryType selectedDeliveryType;
  late DeliveryTime selectedDeliveryTimes;
  late PayCondition selectedPayConditions;

  // CONTROLLERS
  TextEditingController customerController = TextEditingController();
  TextEditingController vendedorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController socialController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController lgvController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  /*Integration */
  @override
  void initState() {
    super.initState();

    //_quotation0 = widget.data['quotation'];
    //_quotationproducts0 = widget.data['quotationproducts'];

    dateController.text = format.format(DateTime.now());
    //customerController.text = "3453453";

    SharedPreferences.getInstance().then((res) {
      if (!mounted) return;

      setState(() {
        _LoginUser = res.getString("usuario") ?? '';
        _Company = res.getString("empresa") ?? '';
        _CodUser = res.getInt("codigo") ?? 0;
        _CodCompany = res.getString("codcompany") ?? '';
      });
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (!mounted) return;

      setState(() => _source = source);
    });

    getValues();
  }

  Future getValues() async {
    CurrencyCtr currencycrt = new CurrencyCtr();
    DeliveryTypeCtr deliverytypecrt = new DeliveryTypeCtr();
    DeliveryTimeCrt deliverytimecrt = new DeliveryTimeCrt();
    PayConditionCtr payConditionCtr = new PayConditionCtr();
    ProductCtr productcrt = new ProductCtr();

    List<Currency> resCurrency = await currencycrt.getDataCurrency();
    List<DeliveryType> resDeliveryTypes =
        await deliverytypecrt.getDataDeliveryTipe();
    List<DeliveryTime> resDeliveryTimes =
        await deliverytimecrt.getDataDeliveryTime();
    List<PayCondition> resPaymentConditions =
        await payConditionCtr.getDataPayCondition();
    List<Product> allProducts = await productcrt.getDataProduct();
    // List<QuotationProduct> quotaionProducts = await DBProvider.db.getQuotationProducts();
    try {
      setState(() {
        currency = resCurrency;
        deliveryTypes = resDeliveryTypes;
        deliveryTimes = resDeliveryTimes;
        payConditions = resPaymentConditions;
        products = allProducts;
        loading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<int> fordelayed() async {
    return await Future.delayed(Duration(seconds: 1), () => 1);
  }

  @override
  Widget build(BuildContext context) {
    final datamap =
        ModalRoute.of(context)!.settings.arguments as QuotationPlusProducts;
    Quotation quotat = datamap.quotat;
    List<QuotationProduct> listproduct = datamap.listproduct;
    Customer cust = datamap.customer;
    String salesperson = datamap.salesperson;
    int? main_switch = datamap.main_switch;

    _cust = cust;
    _quotat_final = quotat;
    _listproduct_final = listproduct;
    _salesperson = salesperson;

    //quotat.

    QuotationCrt crt = new QuotationCrt();

    //List<SelectQuotation> listQuotations =
    //  crt.getSelectQuotationByCustomer(customer.codCustomer.toString())
    //    as List<SelectQuotation>;

    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;

    _out_paycondition =
        payConditions.where((o) => o.codPayCondition == quotat.payId).toList();

    _out_deliverytime =
        deliveryTimes.where((o) => o.id == quotat.deliveryTimeId).toList();

    _out_deliverytype =
        deliveryTypes.where((o) => o.id == quotat.deliveryTypeId).toList();

    _out_currency =
        currency.where((o) => o.codCurrency == quotat.currencyId).toList();

    return WillPopScope(
      onWillPop: () async {
        //bool? showpopup = await showWarning(context);
        //if (showpopup == true) {
        String route_main = "";
        if (main_switch == 1) {
          route_main = "home";
        } else {
          route_main = "listQuotas";
        }
        Navigator.pushNamedAndRemoveUntil(context, route_main, (route) => false,
            arguments: cust);

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
        body: FutureBuilder(
            future: fordelayed(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.center,
                        child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "CONFIRMACION DE COTIZACIÓN",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 12.0, right: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: quotat.state == 1
                                      ? Colors.green
                                      : Colors.green,
                                ),
                                height: 20,
                                child: Container(
                                  child: Text(
                                    "Visualización",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = quotat.dateQuotation.toString(),
                                decoration: InputDecoration(labelText: "Fecha"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = cust.numRucCustomer.toString(),
                                decoration:
                                    InputDecoration(labelText: "Doc. Fiscal"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = quotat.nameBusiness.toString(),
                                decoration:
                                    InputDecoration(labelText: "Razon Social"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = salesperson,
                                decoration:
                                    InputDecoration(labelText: "Vendedor"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_paycondition[0].strDescription!,
                                decoration: InputDecoration(
                                    labelText: "Condicion de Pago"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_deliverytype[0].description,
                                decoration: InputDecoration(
                                    labelText: "Tipo de Entrega"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_deliverytime[0].description,
                                decoration: InputDecoration(
                                    labelText: "Tiempo de Entrega"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 20),
                              Text("Listado de Productos "),
                              if (listproduct.isNotEmpty)
                                Container(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 200, minHeight: 200),
                                    child: Scrollbar(
                                      // isAlwaysShown: true,
                                      child: ListView.separated(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: listproduct.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: Text(
                                                    listproduct[index]
                                                        .product_name
                                                        .toString()
                                                        .trimRight()
                                                        .trimLeft(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                      listproduct[index]
                                                          .sub_total
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                          height: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = quotat.observation.toString(),
                                decoration:
                                    InputDecoration(labelText: "Observaciones"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_currency[0]
                                      .strDescription
                                      .toString(),
                                decoration:
                                    InputDecoration(labelText: "Moneda"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = quotat.subTotal.toString(),
                                decoration:
                                    InputDecoration(labelText: "Sub Total"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = quotat.lgv.toString(),
                                decoration: InputDecoration(labelText: "IGV"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = quotat.total.toString(),
                                decoration: InputDecoration(labelText: "Total"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 30),
                              OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                                onPressed: () async {
                                  /********************** Generamos PDF ******************/
                                  final directory =
                                      await getExternalStorageDirectory();
                                  CompanyCtr comp = new CompanyCtr();
                                  List<Company> arrCompany =
                                      await comp.getCompany(_CodCompany);

                                  ReportDataQuotation dataquotation =
                                      new ReportDataQuotation(
                                          path: directory!.path,
                                          codCompany: _CodCompany,
                                          quotationfin: _quotat_final,
                                          listprodquotationfin:
                                              _listproduct_final,
                                          customer: _cust,
                                          salesperson: _salesperson,
                                          paycondition: _out_paycondition[0]
                                              .strDescription
                                              .toString(),
                                          deliverytype: _out_deliverytype[0]
                                              .description
                                              .toString(),
                                          deliverytime: _out_deliverytime[0]
                                              .description
                                              .toString(),
                                          currency:
                                              _out_currency[0].codCurrency!,
                                          currencyName:
                                              _out_currency[0].strName!,
                                          company: arrCompany[0]);

                                  Reports reports = new Reports();
                                  reports.reportsEnableds(dataquotation);
                                  // if (_CodCompany == "1") {
                                  //   reports.reportsQuotation_refermat(
                                  //       dataquotation);
                                  // } else {
                                  //   reports.reportsQuotation(dataquotation);
                                  // }

                                  // _createPDF();
                                  /********************** Generamos PDF ******************/
                                },
                                child: Row(
                                  textBaseline: TextBaseline.ideographic,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Icon(
                                      Icons.local_print_shop_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Reimprimir Cotización",
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                style: quotat.state == 0
                                    ? ElevatedButton.styleFrom(
                                        primary: Colors.orange,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      )
                                    : ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                // style: wi,
                                onPressed: () async {
                                  final msg_confirm = SnackBar(
                                      content: Text(
                                          ' La Cotización se registro con exito !'));
                                  final msg_wait = SnackBar(
                                      content: Text('Espere un momento....'));
                                  final msg_err = SnackBar(
                                      content: Text(
                                          'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                                  FocusScope.of(context).unfocus();
                                  try {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(msg_confirm);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, 'listQuotas', (route) => false,
                                        arguments: cust);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
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
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Regresar al Listado",
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }),
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

  Future<void> _createPDF() async {
    // Create a new PDF document.
    //Get external storage directory
    final controller = new MoneyMaskedTextController();
    final directory = await getExternalStorageDirectory();
    io2.Directory appDocDirtTemp = await getTemporaryDirectory();
    String tempDirectory = appDocDirtTemp.path;
    //print(tempDirectory);

//Get directory path
    final path = directory!.path;

    //Create a new PDF document
    PdfDocument document = PdfDocument();

    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 10;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    print("tamaños ");
    print(page.getClientSize().width);
    print(page.getClientSize().height);

    //PdfBrush solidBrush = PdfSolidBrush(PdfColor(150, 148, 148));
    Rect bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    //  graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.helvetica, 14);

//Creates a text element to add the invoice number
    PdfTextElement element = PdfTextElement(text: '', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
    //String currentDate = ''; //'DATE ________';

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont timesRomanBold =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    PdfFont timesRomanDet = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont timesRomanBoldDet =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    String empresa = "";
    if (_CodCompany == "1") {
      page.graphics.drawImage(
          PdfBitmap(io2.File('$tempDirectory/refermat.png').readAsBytesSync()),
          Rect.fromLTWH(10, -5, 80, 80));
      empresa = 'Refermat S.A.C. ';
    } else {
      page.graphics.drawImage(
          PdfBitmap(io2.File('$tempDirectory/suminox.png').readAsBytesSync()),
          Rect.fromLTWH(10, -27, 120, 120));
      empresa = 'Suminox Aceros S.A.C. ';
    }

    element = PdfTextElement(
        text: empresa,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 10, 0, 0))!;

    element =
        PdfTextElement(text: 'Doc. Fiscal.: 20603430248', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(
        text: 'Av. Maquinarias 1891 - Lima - Peru', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: 'Tlf: 5030204 ', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    int separacion_inicio = 15;
    int separacion_todos_cab = 2;
    int separacion_todos_det = 10;

    // fecha

    element = PdfTextElement(text: 'Fecha', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds:
            Rect.fromLTWH(15, result.bounds.bottom + separacion_inicio, 0, 0))!;

    element = PdfTextElement(
        text: _quotat_final.dateQuotation.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // cotizacion

    element = PdfTextElement(text: 'Nro Cotización', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: _quotat_final.id.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // ruc cliente

    element = PdfTextElement(text: 'Doc. Fiscal', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: _cust.numRucCustomer.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // razon social

    element = PdfTextElement(text: 'Razon Social', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: _cust.strName.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // vendedor

    element = PdfTextElement(text: 'Vendedor', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(text: _salesperson, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //condicion de pago

    element =
        PdfTextElement(text: 'Condicion de Pago', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: _out_paycondition[0].strDescription.toString(),
        font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //tipo de entrega

    element = PdfTextElement(text: 'Tipo de Entrega', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: _out_deliverytype[0].description.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //tiempo de entrega

    element =
        PdfTextElement(text: 'Tiempo de Entrega', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: _out_deliverytime[0].description.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

// //CREAMOS UNA LINEA
//     graphics.drawLine(
//         PdfPen(PdfColor(126, 151, 173), width: 0.7),
//         Offset(0, result.bounds.bottom + 3),
//         Offset(graphics.clientSize.width, result.bounds.bottom + 3));

/* CREAMOS PDF  */

//Creates a PDF grid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 11);

//Add header to the grid
    grid.headers.add(1);

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Nro.';
    header.cells[1].value = 'Codigo';
    header.cells[2].value = 'Descripción de Producto';
    header.cells[3].value = 'Unidad';
    header.cells[4].value = 'Diametro \r\n (MM)';
    header.cells[5].value = 'Diametro Interno  \r\n(MM)';
    header.cells[6].value = 'Largo \r\n (MM)';
    header.cells[7].value = 'Cantidad \r\n';
    header.cells[8].value = 'Peso Teorico \r\n (KG)';
    header.cells[9].value = 'Precio Unit.';
    header.cells[10].value = 'Precio Final';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 11,
        style: PdfFontStyle.regular);

//Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      if (i == 0 || i == 1) {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      header.cells[i].style = headerStyle;
    }

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    int contador = 0;

    QuotationProduct quotproduct;

    _listproduct_final.forEach((quotprod) {
      quotproduct = quotprod;

      if (contador > 0) {
        row = grid.rows.add();
      }

      row.cells[0].value = (contador + 1).toString();
      row.cells[1].value =
          quotproduct.cod_TiProducts == null ? '' : quotproduct.cod_TiProducts;
      row.cells[2].value = quotproduct.product_name.toString();
      row.cells[3].value = quotproduct.unity_product;
      row.cells[4].value = (double.parse(quotproduct.diameter) % 1 != 0
              ? double.parse(quotproduct.diameter).toStringAsFixed(2)
              : double.parse(quotproduct.diameter).toStringAsFixed(0))
          .toString();
      row.cells[5].value =
          (double.parse(quotproduct.width_internal_diameter.toString()) % 1 != 0
                  ? double.parse(quotproduct.width_internal_diameter.toString())
                      .toStringAsFixed(2)
                  : double.parse(quotproduct.width_internal_diameter.toString())
                      .toStringAsFixed(0))
              .toString(); //quotproduct.width_internal_diameter;
      row.cells[6].value = quotproduct.long;
      row.cells[7].value = quotproduct.quantity;
      row.cells[8].value =
          double.parse(quotproduct.theoretical_weight).toStringAsFixed(2);
      row.cells[9].value =
          (double.parse(quotproduct.unity_price.toString()) % 1 != 0
                  ? double.parse(quotproduct.unity_price.toString())
                      .toStringAsFixed(2)
                  : double.parse(quotproduct.unity_price.toString())
                      .toStringAsFixed(0))
              .toString();
      row.cells[10].value = quotproduct.sub_total;

      contador = contador + 1;
    });

//Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 11);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    final icon_mod = _out_currency[0].codCurrency == 1 ? "\$" : "S/";

    // print(_quotat_final.total.toString());

    controller.updateValue(double.parse(_quotat_final.subTotal.toString()));
    String subtotal = controller.numberValue.toString();

    controller.updateValue(double.parse(_quotat_final.lgv.toString()));
    String igv = controller.numberValue.toString();

    controller.updateValue(double.parse(_quotat_final.total.toString()));
    String total = controller.numberValue.toString();

    /* comenzamos a preveer desbordamiento */

    int valid = 0;
    int advance = 4;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Observaciones :  ${_quotat_final.observation.toString()}',
        subHeadingFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(15, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 6;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Sub Total :                            $icon_mod $subtotal',
        subHeadingFont,
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'IGV. 18% :                            $icon_mod $igv', subHeadingFont,
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Total :                                   $icon_mod $total',
        subHeadingFont,
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    final moneda_mod = _out_currency[0].codCurrency == 1
        ? "dolares americanos"
        : "soles peruanos";

    gridResult.page.graphics.drawString(
        '(1) Los Precios estan reflejados en $moneda_mod',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 10;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        '(2) Los pesos son en base al peso teorico.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 10;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        '(3) Las medidas que se encuentran en parentesis () hacen referencia a la conversion en pulgadas o milimetros de acuerdo al caso y son referenciales.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 10;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        '(4) Nuestras medidas cuenta con tolerancia de requerir medidas exactas por favor indicarlo y colocarlo en las observaciones. ',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 10;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        '(5) De requerir material de calibrado en toda la pieza o barra esto debe estar indicado en las observaciones.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 30;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    String parf0 = "";
    String parf1 = "";
    String parf2 = "";
    String parf3 = "";

    print(_CodCompany);

    if (_CodCompany == "1") {
      // refermat

      parf0 =
          "AGENTE DE RETENCIÓN, NO RETENER 3.00% R.S. NRO. 180-2016/SUNAT ** Cuentas Bancarias Refermat SAC:";
      parf1 =
          "BCP: Dólares: 193-2519755-1-79 / CCI 002-193-002519755179-16 ** Soles: 193-2532658-0-02 / CCI 002-193-002532658002-11 ** Yape: 923 758 962 ";
      parf2 =
          "BBVA Soles: 0011-0179-02-00530505 ** CAJA HUANCAYO Soles: 107038211002124427";
      parf3 =
          "LA CONFORMIDAD DE PAGO ES SOLO VALIDA CON EL RECIBO DE COBRO O VOUCHER DE DEPOSITO DE LA EMPRESA";
    } else {
      parf0 =
          "AGENTE DE RETENCIÓN, NO RETENER 3.00% R.S. NRO. 180-2016/SUNAT ** Cuentas Bancarias Suminox Aceros SAC:";
      parf1 =
          "BCP: Dólares: 193-2145443-1-50 / CCI 002-193-002145443150-19 ** Soles: 193-2144840-0-49 / CCI 002-193-002144840049-15 ** Yape: 981 110 607 ";
      parf2 =
          "Scotiabank: Dólares: 000-4110871 / CCI 009-024-000004110871-13 ** Soles: 000-9304592 / CCI 009-024-000009304592-10.";
      parf3 =
          "LA CONFORMIDAD DE PAGO ES SOLO VALIDA CON EL RECIBO DE COBRO O VOUCHER DE DEPOSITO DE LA EMPRESA";
    }

    print(parf0);

    gridResult.page.graphics.drawString(
        parf0, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 12;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        parf1, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 12;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        parf2, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 12;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        parf3, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    // element = PdfTextElement(
    //     text: 'DENTRO DE LAS PRIMERAS 24 HORAS', font: timesRomanDet);
    // element.brush = PdfBrushes.black;
    // result = element.draw(
    //     page: page,
    //     bounds: Rect.fromLTWH(
    //         135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // gridResult.page.graphics.drawString(
    //     'Thank you for your business !', subHeadingFont,
    //     brush: PdfBrushes.black,
    //     bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + 30, 0, 0));

/*
    //Add a new page and draw text
    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 50));
*/
    //Save the document
    List<int> bytes = document.save();

    //Dispose the document
    document.dispose();

    final name_pdf =
        _quotat_final.id == null ? 'temporal_name' : _quotat_final.id;

//Create an empty file to write PDF data
    final file = io2.File('$path/$name_pdf.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/$name_pdf.pdf');
  }
}
