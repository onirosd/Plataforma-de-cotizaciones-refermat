import 'dart:io' as io2;
import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:appcotizaciones/src/models/printBilling.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
import 'package:appcotizaciones/src/modelscrud/bank_crt.dart';
import 'package:appcotizaciones/src/modelscrud/billing_crt.dart';
import 'package:appcotizaciones/src/modelscrud/billingtype.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paymentmethod_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/providers/provider.home.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/company.dart';
import '../modelscrud/company_crt.dart';

class CustomerBillingEdit extends StatefulWidget {
  CustomerBillingEdit({Key? key}) : super(key: key);

  @override
  _CustomerBillingEditState createState() => _CustomerBillingEditState();
}

class _CustomerBillingEditState extends State<CustomerBillingEdit> {
  int _selectedIndex = 1;
  String _LoginUser = '';
  String _Company = '';
  String _CodCompany = '';
  bool _isInternet = true;

  AuthenticationCtr authcrt = new AuthenticationCtr();
  CustomerCtr custcrt = new CustomerCtr();
  late Future<List<PaymentMethod>> _metodospago;
  List<BillingType> _tipocobro = [];
  List<Currency> _currency = [];
  List<Bank> _bank = [];
  String _auth = "";
  String _cust = "";
  int _repitinbuild = 0;
  Customer _customer = new Customer();

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

  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  String _selectedDate = "";
  TextEditingController _editingController = new TextEditingController();

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

    if (this.mounted) {
      setState(() {
        ctr4.getDataBanks().then((value) {
          _bank = value;
        });
      });
    }

    if (this.mounted) {
      setState(() {
        ctr3.getDataCurrency().then((value1) {
          _currency = value1;
          //print(_currency.length);
        });
      });
    }

    if (this.mounted) {
      setState(() {
        ctr2.getDataBillingType().then((value) {
          _tipocobro = value;
          //print(_tipocobro.length);
        });
      });
    }

    if (this.mounted) {
      setState(() {
        _metodospago = crt1.getDataPaymentMethods();
      });
    }

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() => _source = source);
      }
    });
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                'Se perderan los cambios !! \n, ¿ Quieres salir de la edición ?'),
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

  @override
  Widget build(BuildContext context) {
    Billingandflag billingflag =
        ModalRoute.of(context)!.settings.arguments as Billingandflag;

    if (_repitinbuild == 0) {
      _editingController.text = billingflag.billingdata.dteBillingDate;
      _repitinbuild = _repitinbuild + 1;
    }

    authcrt
        .getDataUserAutentication(billingflag.billingdata.codUser)
        .then((value) {
      if (this.mounted) {
        setState(() {});
      }
      _auth = value[0].strNameUser;
    });

    custcrt
        .getCustomerBycodUser(billingflag.billingdata.codCustomer)
        .then((value2) {
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
            future: _metodospago,
            builder: (BuildContext context,
                AsyncSnapshot<List<PaymentMethod>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                //List<PaymentMethod> paymenth = snapshot.data;
/*
                List<Currency> _out_currency = _currency
                    .where((o) => o.codCurrency == billing.codCurrency)
                    .toList();

                      List<Bank> _out_banco =
                    _bank.where((o) => o.codBank == billing.codBank).toList();
                    */

                List<Currency> _out_currency = _currency
                    .where((o) =>
                        o.codCurrency == billingflag.billingdata.codCurrency)
                    .toList();

                List<BillingType> _out_tipocobro = _tipocobro
                    .where((o) =>
                        o.codBillingType ==
                        billingflag.billingdata.codBillingType)
                    .toList();
                List<PaymentMethod> _out_metodopago = snapshot.data!
                    .where((o) =>
                        o.codPaymentMethod ==
                        billingflag.billingdata.codPaymentMethod)
                    .toList();

                //DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                //  int.parse(billing.dteBillingDate));

                return CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.topLeft,
                        child: Form(
                          key: formGlobalKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "EDICIÓN DE RECIBO",
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
                                  color: billingflag.billingdata.flgState == 1
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                height: 20,
                                child: Container(
                                  child: Text(
                                    " Procesar Recibo ",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
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
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Recibo",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                              TextFormField(
                                //enabled: false,
                                style: TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Colors.grey),
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = billingflag
                                      .billingdata.codBillingUniq
                                      .toString(),

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
                                enabled: false,
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
                                enabled: false,
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
                                decoration: InputDecoration(
                                  labelText: "N° Operación",
                                  icon: Icon(Icons.confirmation_number),
                                ),

                                initialValue: billingflag
                                    .billingdata.strOperation
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],

                                //enabled: false,
                                validator: (dir) => dir == null || dir == ''
                                    ? 'Este Campo no puede estar en blanco'
                                    : null,
                                //enabled: false,

                                onSaved: (val) {
                                  billingflag.billingdata.strOperation =
                                      val.toString();
                                  //print('saved');
                                },
                                // decoration:
                                //   InputDecoration(labelText: "Vendedor"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              _crearFecha(context),

                              /*TextFormField(
                                //enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = billing.dteBillingDate,
                                decoration: InputDecoration(labelText: "Fecha "),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),*/
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: "banco"),
                                // decoration: textInputDecoration,
                                value: billingflag.billingdata.codBank,

                                items: _bank.map((emap) {
                                  return DropdownMenuItem(
                                    value:
                                        emap.codBank != null ? emap.codBank : 0,
                                    child: Text(emap.strDescription!),
                                  );
                                }).toList(),

                                onChanged: (val) async {
                                  print(val.toString() + '_________');
                                  //  setState(() {
                                  //   loginForm.company = val.toString();
                                  //});
                                },
                                onSaved: (val) {
                                  if (val != null) {
                                    billingflag.billingdata.codBank =
                                        val as int;
                                  } else {
                                    billingflag.billingdata.codBank = 0;
                                  }

                                  //print('saved');
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = _out_currency[0].strDescription!,
                                decoration:
                                    InputDecoration(labelText: "N° Moneda"),
                                // onSaved: (value) {
                                // customer.numRut = value.toString();
                                //},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "Monto Operación",
                                  icon: Icon(Icons.payments_outlined),
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true, signed: false),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    try {
                                      final text = newValue.text;
                                      if (text.isNotEmpty) double.parse(text);
                                      return newValue;
                                    } catch (e) {}
                                    return oldValue;
                                  }),
                                ],
                                initialValue: billingflag
                                    .billingdata.numAmountOperation
                                    .toString(),
                                //controller: TextEditingController()
                                //  ..text = billing.numAmountOperation.toString(),
                                validator: (dir) => dir == null || dir == ''
                                    ? 'Este Campo no puede estar en blanco'
                                    : null,
                                onSaved: (val) {
                                  if (val != null) {
                                    billingflag.billingdata.numAmountOperation =
                                        double.parse(val);
                                  } else {
                                    billingflag.billingdata.numAmountOperation =
                                        0;
                                  }

                                  //print('saved');
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                //enabled: false,
                                //readOnly: true,
                                // controller: TextEditingController(),
                                //  ..text = billing.strComments.toString(),
                                initialValue: billingflag
                                    .billingdata.strComments
                                    .toString(),
                                decoration: InputDecoration(
                                    labelText: "Observaciones "),
                                onSaved: (value) {
                                  billingflag.billingdata.strComments =
                                      value.toString();
                                },
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                                // style: wi,
                                onPressed: () async {
                                  /* final msg_confirm = SnackBar(
                                      content: Text(' Confirme Su perdido !'));
                                  final msg_wait = SnackBar(
                                      content: Text('Espere un momento....'));
                                  final msg_err = SnackBar(
                                      content: Text(
                                          'Tuvimos un error en el registro !! , Intentelo de nuevo.'));
                                  */
                                  //final f = formGlobalKey;
                                  // customerProvider.isLoading = true;
                                  FocusScope.of(context).unfocus();
                                  //final f = customerProvider.formKey;
                                  if (formGlobalKey.currentState!.validate()) {
                                    //setState(() {
                                    // this.isAbsorbing = !this.isAbsorbing;
                                    //});
                                    formGlobalKey.currentState!.save();
                                    billingflag.billingdata.dteBillingDate =
                                        _editingController.text;

                                    billingflag.billingdata.flgState =
                                        1; // estado procesado
                                    billingflag.billingdata.flgSync = -1;

                                    BillingCrt crt = BillingCrt();

                                    try {
                                      if (await crt.updateBilling(
                                              billingflag.billingdata) >
                                          0) {
                                        final list_banco = _bank
                                            .where((o) =>
                                                o.codBank ==
                                                billingflag.billingdata.codBank)
                                            .toList();

                                        final list_metodopago = snapshot.data!
                                            .where((o) =>
                                                o.codPaymentMethod ==
                                                billingflag.billingdata
                                                    .codPaymentMethod)
                                            .toList();

                                        final list_tipocobro = _tipocobro
                                            .where((o) =>
                                                o.codBillingType ==
                                                billingflag
                                                    .billingdata.codBillingType)
                                            .toList();

                                        final list_currency = _currency
                                            .where((o) =>
                                                o.codCurrency ==
                                                billingflag
                                                    .billingdata.codCurrency)
                                            .toList();

                                        _imprimir.banco =
                                            list_banco[0].strDescription!;

                                        _imprimir.direccion =
                                            _customer.strAddress.toString();

                                        _imprimir.ruc = _customer.numRut!;
                                        _imprimir.metodoPago =
                                            list_metodopago[0].strDescription!;
                                        _imprimir.monto = billingflag
                                                .billingdata.numAmountOperation
                                                .toString() +
                                            " " +
                                            list_currency[0]
                                                .strDescription
                                                .toString();
                                        _imprimir.nombreCliente =
                                            _customer.strName.toString();
                                        _imprimir.nroOperacion = billingflag
                                            .billingdata.strOperation;
                                        _imprimir.numRecibo = billingflag
                                            .billingdata.codBillingUniq;
                                        _imprimir.observaciones = billingflag
                                            .billingdata.strComments
                                            .toString();
                                        _imprimir.tipoCobro =
                                            list_tipocobro[0].strDescription!;
                                        _imprimir.vendedor = _auth;
                                        _imprimir.fecha = billingflag
                                            .billingdata.dteBillingDate;

                                        if (_customer.numRut != null) {
                                          String r = _customer.numRut!;
                                          _imprimir.ruc = r;
                                        } else {
                                          _imprimir.ruc = "";
                                        }

                                        CompanyCtr comp = new CompanyCtr();
                                        List<Company> arrCompany =
                                            await comp.getCompany(_CodCompany);

                                        //print(_imprimir);

                                        _createPDF(arrCompany[0]);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Se proceso el recibo con exito!.')),
                                        );

                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'listBilling',
                                            (route) => false,
                                            arguments: _customer);
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Se tuvo problemas al actualizar el registro!.')),
                                      );
                                    }
                                  }
                                },
                                child: Row(
                                  textBaseline: TextBaseline.ideographic,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(
                                      Icons.check_circle_outline_outlined,
                                      // color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Imprimir Procesado',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ]);
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

  _crearFecha(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 9,
                child: TextFormField(
                    //autofocus: true,
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: _editingController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today),
                    ),
                    /*decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      hintText: 'Fecha de Nacimiento',
                      labelText: 'Fecha de Nacimiento',
                      suffixIcon: Icon(Icons.perm_contact_calendar),
                      icon: Icon(Icons.calendar_today)),
                      */
                    validator: (dir) => dir == null || dir == ''
                        ? 'Este Campo no puede estar en blanco'
                        : null,
                    onTap: () {
                      //FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDate2(context, _editingController.text);
                    },
                    onSaved: (val) {
                      //_bill.dteBillingDate = val;
                      /*if (val != null) {
                        var parsedDate = DateTime.parse(val);
                        String milli =
                            parsedDate.millisecondsSinceEpoch.toString();
                        _bill.dteBillingDate = milli;
                      } else {
                        _bill.dteBillingDate = "";
                      }*/

                      //print('saved');
                    }),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      // setState(() {
                      _editingController.text = '';
                      //});
                    },
                    icon: Icon(Icons.clear),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void _selectDate2(BuildContext context, String fecha) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            fecha.trim() == '' ? DateTime.now() : DateTime.parse(fecha),
        firstDate: DateTime(2018),
        lastDate: DateTime.now(),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _selectedDate =
            DateFormat("yyyy-MM-dd").format(picked); //picked.toString();
        _editingController.text = _selectedDate;
      });
    }
  }

  Future<void> _createPDF(Company company) async {
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
    document.pageSettings.margins.top = 50;
    document.pageSettings.margins.left = 100;
    document.pageSettings.margins.right = 100;

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
    //   graphics.clientSize.width - textSize.width - 10, result.bounds.top);

//Draws the date by using drawString method

    String icono_company = company.str_image.toString();
    String name_company = company.strDesCompany!;
    String ruc = company.strRucCompany!;
    // if (_CodCompany == "1") {
    //   icono_company = 'refermat.png';
    //   // name_company = "Refermat S.A.C. ";
    //   // ruc = "20603430248";
    // }

    // if (_CodCompany == "2") {
    //   icono_company = 'suminox.png';
    //   // name_company = "Suminox S.A.C. ";
    //   // ruc = "20548295239";
    // }

    String ruc_cliente = _imprimir.ruc;
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

    page.graphics.drawImage(
        PdfBitmap(io2.File('$tempDirectory/$icono_company').readAsBytesSync()),
        Rect.fromLTWH(130, 40, 100, 100));

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
        text: '${company.strAddress!} * ${company.strRucCompany} \r\n \r\n ',
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
        text: '     Doc. Fiscal : $ruc_cliente',
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
