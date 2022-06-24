import 'dart:io' as io2;

import 'package:appcotizaciones/src/models/printBilling.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
import 'package:appcotizaciones/src/modelscrud/bank_crt.dart';
import 'package:appcotizaciones/src/modelscrud/billing_crt.dart';
import 'package:appcotizaciones/src/modelscrud/billingtype.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paymentmethod_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';

class CustomerBillingConfirm extends StatefulWidget {
  CustomerBillingConfirm({Key? key}) : super(key: key);

  @override
  _CustomerBillingConfirmState createState() => _CustomerBillingConfirmState();
}

class _CustomerBillingConfirmState extends State<CustomerBillingConfirm> {
  int _selectedIndex = 1;
  String _LoginUser = '';
  String _Company = '';
  String _CodCompany = '';
  bool _isInternet = true;

  PrintBilling _imprimir = new PrintBilling(
      nombreCliente: "",
      direccion: "",
      monto: "",
      numRecibo: "",
      tipoCobro: "",
      metodoPago: "",
      nroOperacion: "",
      banco: "",
      observaciones: "",
      vendedor: "",
      fecha: "",
      ruc: "");

  AuthenticationCtr authcrt = new AuthenticationCtr();
  CustomerCtr custcrt = new CustomerCtr();
  List<PaymentMethod> _metodospago = [];
  List<BillingType> _tipocobro = [];
  List<Currency> _currency = [];
  List<Bank> _bank = [];
  String _auth = "";
  String _cust = "";
  Customer _customer = new Customer();

  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();

    PaymentMethodCtr crt1 = new PaymentMethodCtr();
    BillingTypeCtr ctr2 = new BillingTypeCtr();
    CurrencyCtr ctr3 = new CurrencyCtr();
    BankCtr ctr4 = new BankCtr();

    SharedPreferences.getInstance().then((res) {
      setState(() {
        _LoginUser = res.getString("usuario") ?? '';
        _Company = res.getString("empresa") ?? '';
        _CodCompany = res.getString("codcompany") ?? '';
      });
    });

    setState(() {
      ctr4.getDataBanks().then((value) {
        _bank = value;
      });
    });

    setState(() {
      ctr3.getDataCurrency().then((value1) {
        _currency = value1;
        print(_currency.length);
      });
    });

    setState(() {
      ctr2.getDataBillingType().then((value) {
        _tipocobro = value;
        print(_tipocobro.length);
      });
    });

    setState(() {
      crt1.getDataPaymentMethods().then((value) {
        _metodospago = value;
      });

      //  _metodospago = crt1.getDataPaymentMethods();
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

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(300, 72),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

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

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                'Cuidado : Se perderan los datos ingresados !! \n ¿ Desea Salir ?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Si'),
              ),
            ],
          ));

  Future<int> fordelayed() async {
    return await Future.delayed(Duration(seconds: 2), () => 2);
  }

  @override
  Widget build(BuildContext context) {
    final billing = ModalRoute.of(context)!.settings.arguments as Billing;

    //print(billing.dteCreateDate.toString() + "-------------");

    authcrt.getDataUserAutentication(billing.codUser).then((value) {
      if (this.mounted) {
        setState(() {});
      }
      _auth = value[0].strNameUser;
    });

    custcrt.getCustomerBycodUser(billing.codCustomer).then((value2) {
      if (this.mounted) {
        setState(() {});
      }
      _cust = value2[0].strName!;
      _customer = value2[0];
      //print(_cust.length);
    });

    return WillPopScope(
      onWillPop: () async {
        bool? showpopup = await showWarning(context);
        if (showpopup == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'listBilling', (route) => false,
              arguments: _customer);
        }
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
                //List<PaymentMethod> paymenth = snapshot.data;

                List<Currency> _out_currency = _currency
                    .where((o) => o.codCurrency == billing.codCurrency)
                    .toList();
                List<BillingType> _out_tipocobro = _tipocobro
                    .where((o) => o.codBillingType == billing.codBillingType)
                    .toList();
                List<PaymentMethod> _out_metodopago = _metodospago
                    .where(
                        (o) => o.codPaymentMethod == billing.codPaymentMethod)
                    .toList();
                List<Bank> _out_banco =
                    _bank.where((o) => o.codBank == billing.codBank).toList();

                //DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                //   int.parse(billing.dteBillingDate));

                _imprimir.numRecibo = billing.codBillingUniq.toString();
                _imprimir.nombreCliente = _customer.strName.toString();
                _imprimir.direccion = _customer.strAddress.toString();
                _imprimir.monto = billing.numAmountOperation.toString() +
                    " " +
                    _out_currency[0].strDescription!;
                _imprimir.banco = _out_banco[0].strDescription!;
                _imprimir.metodoPago = _out_metodopago[0].strDescription!;
                _imprimir.tipoCobro = _out_tipocobro[0].strDescription!;
                _imprimir.observaciones = billing.strComments.toString();
                _imprimir.nroOperacion = billing.strOperation;
                _imprimir.vendedor = _auth;

                _imprimir.banco = _out_banco[0].strDescription!;
                _imprimir.direccion = _customer.strAddress.toString();
                _imprimir.fecha = billing.dteBillingDate;
                _imprimir.metodoPago = _out_metodopago[0].strDescription!;
                _imprimir.monto = billing.numAmountOperation.toString() +
                    " " +
                    _out_currency[0].strDescription!;
                _imprimir.nombreCliente = _customer.strName.toString();
                _imprimir.nroOperacion = billing.strOperation;
                _imprimir.numRecibo = billing.codBillingUniq;
                _imprimir.observaciones = billing.strComments!;
                _imprimir.tipoCobro = _out_tipocobro[0].strDescription!;
                _imprimir.vendedor = _auth;
                _imprimir.ruc = _customer.numRut!;

                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.topLeft,
                        child: Form(
                          key: formGlobalKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "CONFIRMACION DE RECIBO",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 12.0, right: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: billing.flgState == 1
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                height: 20,
                                child: Container(
                                  child: Text(
                                    billing.flgState == 1
                                        ? "Procesado"
                                        : "Pre - Procesado",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = "N° Temporal de Recibo",
                                decoration:
                                    InputDecoration(labelText: "Recibo"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _cust,
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
                                  ..text = _auth,
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
                                  ..text = _out_tipocobro[0].strDescription!,
                                decoration:
                                    InputDecoration(labelText: "Tipo de Cobro"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_metodopago[0].strDescription!,
                                decoration: InputDecoration(
                                    labelText: "Metodo de Pago"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = billing.strOperation,
                                decoration:
                                    InputDecoration(labelText: "N° Operación"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = billing.dteBillingDate,
                                decoration:
                                    InputDecoration(labelText: "Fecha "),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_banco[0].strDescription!,
                                decoration: InputDecoration(labelText: "Banco"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_currency[0].strDescription!,
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
                                  ..text =
                                      billing.numAmountOperation.toString(),
                                decoration: InputDecoration(
                                    labelText: "Monto Operación"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = billing.strComments.toString(),
                                decoration: InputDecoration(
                                    labelText: "Observaciones "),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 30),
                              OutlinedButton(
                                style: billing.flgState == 0
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
                                          ' El recibo se registro con exito !'));
                                  final msg_wait = SnackBar(
                                      content: Text('Espere un momento....'));
                                  final msg_err = SnackBar(
                                      content: Text(
                                          'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                                  //final f = formGlobalKey;
                                  // customerProvider.isLoading = true;
                                  FocusScope.of(context).unfocus();
                                  if (formGlobalKey.currentState!.validate()) {
                                    // Process data.

                                    BillingCrt billingCrt = new BillingCrt();
                                    var val = 0;
                                    try {
                                      billingCrt
                                          .insertNewBilling(billing)
                                          .then((value) {
                                        val = value;

                                        if (val > 0) {
                                          print(_imprimir);
                                          //_createPDF();

                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(msg_confirm);

                                          // Navigator.pushNamedAndRemoveUntil(
                                          //     context,
                                          //     'listBilling',
                                          //     (route) => false,
                                          //     arguments: _customer);
                                        }
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  }
                                  //final f = customerProvider.formKey;
                                },
                                child: Row(
                                  textBaseline: TextBaseline.ideographic,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Icon(
                                      Icons.request_page_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      billing.flgState == 1
                                          ? 'Imprimir Procesado'
                                          : 'Imprimir Pre-Procesado',
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]));
              }
            }),
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

  Future<void> _createPDF() async {
    // Create a new PDF document.
    //Get external storage directory
    final directory = await getExternalStorageDirectory();
    io2.Directory appDocDirtTemp = await getTemporaryDirectory();
    String tempDirectory = appDocDirtTemp.path;
    //print(tempDirectory);

//Get directory path
    final path = directory!.path;

    //Create a new PDF document
    PdfDocument document = PdfDocument();

    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 100;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(150, 148, 148));
    Rect bounds = Rect.fromLTWH(0, 0, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.helvetica, 14);

//Creates a text element to add the invoice number
    PdfTextElement element = PdfTextElement(
        text: 'RECIBO #' + _imprimir.numRecibo, font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;
    String currentDate = ''; //'DATE ________';

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);
    //Offset textPosition = Offset(
    //  graphics.clientSize.width - textSize.width - 10, result.bounds.top);

//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

    page.graphics.drawImage(
        PdfBitmap(io2.File('$tempDirectory/user.png').readAsBytesSync()),
        Rect.fromLTWH(8, 215, 16, 16));

    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

    String icono_company = "";
    String name_company = "";
    String ruc = "";

    if (_CodCompany == "1") {
      icono_company = 'refermat.png';
      name_company = "Refermat S.A.C. ";
      ruc = "20603430248";
    }

    if (_CodCompany == "2") {
      icono_company = 'suminox.png';
      name_company = "Suminox S.A.C. ";
      ruc = "20548295239";
    }

    //print(icono_company + "------------------------------------");

    page.graphics.drawImage(
        PdfBitmap(io2.File('$tempDirectory/$icono_company').readAsBytesSync()),
        Rect.fromLTWH(130, 0, 100, 100));

    //Loads the image from base64 string
//PdfImage image = PdfBitmap.fromBase64String('/9j/4AAQSkZJRgABAQEAYABgAAD/4Q');

//Draws the image to the PDF page
//page.graphics.drawImage(image, Rect.fromLTWH(176, 0, 390, 130));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
        text: name_company,
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(130, result.bounds.bottom + 120, 0, 0))!;

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.helvetica, 10);

    element = PdfTextElement(
        text: 'Av. Maquinarias 1891 - Lima - Peru * RUC.$ruc \r\n \r\n ',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(70, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: '     ${_imprimir.nombreCliente} ',
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: '     Doc. Fiscal : ${_imprimir.ruc} ',
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(-10, result.bounds.bottom + 10, 0, 0))!;

    //'Av. Maquinarias 1891 - Lima - Peru * RUC.20603430248  \r\n\r\n\r\n\r\n       Abraham Swearegin ',

    element = PdfTextElement(text: _imprimir.direccion, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(text: '\r ', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    // element = PdfTextElement(text: '1 Item (Cdt.: 1)  ', font: timesRoman);
    // element.brush = PdfBrushes.black;
    // result = element.draw(
    //     page: page,
    //     bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text:
            '----------------------------------------------------------------------------------------------------------------------------------',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: _imprimir.tipoCobro,
        //'1x Abono                                                                                          150,00 PEN',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: _imprimir.monto,
        //'1x Abono                                                                                          150,00 PEN',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(280, result.bounds.bottom - 10, 0, 0))!;

    element = PdfTextElement(
        text: "Metodo de Pago :" + _imprimir.metodoPago,
        //'1x Abono                                                                                          150,00 PEN',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: "Nro. Operación :" +
            _imprimir.nroOperacion +
            "      Fecha : " +
            _imprimir.fecha,
        //'1x Abono                                                                                          150,00 PEN',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: "Banco :" + _imprimir.banco,
        //'1x Abono                                                                                          150,00 PEN',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    String totalefectivo = 'TOTAL : ' + _imprimir.monto;
    //Size totalefectivosize = subHeadingFont.measureString(totalefectivo);

    element = PdfTextElement(
        text: totalefectivo,
        //'1x Abono                                                                                          150,00 PEN',
        font: PdfStandardFont(PdfFontFamily.helvetica, 30,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            10, // 220 - double.parse(totalefectivo.length.toString()),
            result.bounds.bottom + 60,
            0,
            0))!;
    // 100 es del margin
    String efectivo = 'Observaciones : ' + _imprimir.observaciones;
    //Size efectivosize = subHeadingFont.measureString(efectivo);
    element = PdfTextElement(
        text: efectivo,
        //'1x Abono                                                                                          150,00 PEN',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            10,
            //graphics.clientSize.width - efectivo.length - 100,
            result.bounds.bottom + 20,
            0,
            0))!;

    element = PdfTextElement(
        text:
            '----------------------------------------------------------------------------------------------------------------------------------',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(
        text: "Vendedor : " + _imprimir.vendedor,
        //'1x Abono                                                                                          150,00 PEN',
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            10, // 220 - double.parse(totalefectivo.length.toString()),
            result.bounds.bottom + 5,
            0,
            0))!;

    element = PdfTextElement(
        text: 'Gracias por su compra sin derecho a crédito fiscal.',
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(25, result.bounds.bottom + 20, 0, 0))!;

    DateTime now = DateTime.now();
    String mes = DateFormat('MMMM', 'es_ES').format(now);
    String anio = DateFormat('yyyy').format(now);
    String dia = DateFormat('dd').format(now);
    String hora = DateFormat('kk:mm').format(now);
    String cadenafechas = "";
    cadenafechas = dia + " de " + mes + " de " + anio + " " + hora;

    element = PdfTextElement(
        text: cadenafechas,
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.regular));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(100, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: "",
        font: PdfStandardFont(PdfFontFamily.helvetica, 14,
            style: PdfFontStyle.regular));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(25, result.bounds.bottom + 20, 0, 0))!;

//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 3),
        Offset(graphics.clientSize.width, result.bounds.bottom + 3));
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

//Create an empty file to write PDF data
    final file = io2.File('$path/${_imprimir.numRecibo}.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/${_imprimir.numRecibo}.pdf');
  }
}
