import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:appcotizaciones/src/modelscrud/bank_crt.dart';
import 'package:appcotizaciones/src/modelscrud/billingtype.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paymentmethod_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/providers/customer_provider.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:date_field/date_field.dart';

class CustomerBillingNew extends StatefulWidget {
  CustomerBillingNew({Key? key}) : super(key: key);

  @override
  _CustomerBillingNewState createState() => _CustomerBillingNewState();
}

class _CustomerBillingNewState extends State<CustomerBillingNew> {
  String _LoginUser = '';
  int _CodUser = 0;
  String _Company = '';
  String _CodCompany = '';

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;
  QuotationCrt crt = new QuotationCrt();

  List<PaymentMethod> _metodospago = [];
  List<BillingType> _tipocobro = [];
  List<Currency> _currency = [];
  List<Bank> _bank = [];
  bool isAbsorbing = false;
  Customer _customer = new Customer();

  Billing _bill = new Billing(
      codBillingUniq: "",
      codUser: 0,
      codCustomer: "",
      codBillingType: 0,
      codPaymentMethod: 0,
      strOperation: "",
      dteBillingDate: "",
      codBank: 0,
      codCurrency: 0,
      numAmountOperation: 0,
      flgState: 0,
      strCreateUser: "",
      codCompany: 0,
      flgSync: 0,
      flgCodRealSystem: 0,
      latitude: '',
      longitude: '');

  String _selectedDate = "";
  TextEditingController _editingController = new TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  final ButtonStyle _raisedButtonStyle = ElevatedButton.styleFrom(
    //onPrimary: Colors.black,
    primary: Colors.blue,
    minimumSize: Size(300, 72),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void initState() {
    super.initState();
    PaymentMethodCtr crt1 = new PaymentMethodCtr();
    BillingTypeCtr ctr2 = new BillingTypeCtr();
    CurrencyCtr ctr3 = new CurrencyCtr();
    BankCtr ctr4 = new BankCtr();

    // getValues();
    // setState(() {
    //   getValues();
    // });

    setState(() {
      ctr4.getDataBanks().then((value) {
        _bank = value;
      });
    });

    setState(() {
      ctr3.getDataCurrency().then((value1) {
        _currency = value1;
      });
    });

    setState(() {
      ctr2.getDataBillingType().then((value) {
        _tipocobro = value;
      });
    });

    setState(() {
      crt1.getDataPaymentMethods().then((value) {
        _metodospago = value;
      });
    });

    // setState(() {
    //   _metodospago = crt1.getDataPaymentMethods();
    // });

    //  crt1.getDataPaymentMethods();

    SharedPreferences.getInstance().then((res) {
      if (mounted) {
        // PaymentMethodCtr crt1 = new PaymentMethodCtr();
        // BillingTypeCtr ctr2 = new BillingTypeCtr();
        // CurrencyCtr ctr3 = new CurrencyCtr();
        // BankCtr ctr4 = new BankCtr();

        setState(() async {
          // _bank = await ctr4.getDataBanks();
          // _currency = await ctr3.getDataCurrency();
          // _tipocobro = await ctr2.getDataBillingType();
          // _metodospago = await crt1.getDataPaymentMethods();

          _LoginUser = res.getString("usuario") ?? '';
          _Company = res.getString("empresa") ?? '';
          _CodUser = res.getInt("codigo") ?? 0;
          _CodCompany = res.getString("codcompany") ?? '';

          _showAlert(context, _customer);
        });
      }
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() => _source = source);
      }
    });
  }

  Future getValues() async {
    PaymentMethodCtr crt1 = new PaymentMethodCtr();
    BillingTypeCtr ctr2 = new BillingTypeCtr();
    CurrencyCtr ctr3 = new CurrencyCtr();
    BankCtr ctr4 = new BankCtr();

    List<Bank> listbank = await ctr4.getDataBanks();
    List<Currency> listcurrency = await ctr3.getDataCurrency();
    List<BillingType> listbillingtype = await ctr2.getDataBillingType();
    List<PaymentMethod> listmethods = await crt1.getDataPaymentMethods();

    try {
      setState(() {
        _bank = listbank;
        _currency = listcurrency;
        _tipocobro = listbillingtype;
        _metodospago = listmethods;

        _showAlert(context, _customer);
      });
    } catch (err) {
      print(err);
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
                'Cuidado : Se perderan los datos ingresados !! \r  ¿ Desea Salir ? '),
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
  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    _customer = customer;
    //CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    // final riKey1 = const Key('__RIKEY1__');

    //List<SelectQuotation> listQuotations =
    //  crt.getSelectQuotationByCustomer(customer.codCustomer.toString())
    //    as List<SelectQuotation>;

    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;

    return WillPopScope(
      onWillPop: () async {
        bool? showpopup = await showWarning(context);
        if (showpopup == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'listBilling', (route) => false,
              arguments: customer);
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
            future: Future.delayed(Duration(seconds: 0)),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                //   print(snapshot);
                //if (_IsInternet) {
                //  _mensaje = "Se sincronizaron :  " + snapshot.data.toString()

                return AbsorbPointer(
                  absorbing: isAbsorbing,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              alignment: Alignment.topLeft,
                              child: Form(
                                key: formGlobalKey,
                                child: Column(
                                  //shrinkWrap: true,
                                  children: [
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      //enabled: false,
                                      focusNode:
                                          FocusNode(canRequestFocus: false),
                                      readOnly: true,
                                      controller: TextEditingController()
                                        ..text = "N° Temporal de Recibo",
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[400],
                                          filled: true,
                                          labelText: "Recibo",
                                          labelStyle:
                                              TextStyle(color: Colors.white)),

                                      // onSaved: (value) {
                                      // customer.numRut = value.toString();
                                      //},
                                    ),
                                    TextFormField(
                                        readOnly: true,
                                        controller: TextEditingController()
                                          ..text = customer.numRucCustomer
                                              .toString(),
                                        decoration: InputDecoration(
                                            fillColor: Colors.grey[400],
                                            filled: true,
                                            labelText: "Doc. Fiscal",
                                            labelStyle:
                                                TextStyle(color: Colors.white)),
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        onSaved: (val) {
                                          _bill.codCustomer =
                                              customer.codCustomer!;
                                          //print('saved');
                                        }

                                        // onSaved: (value) {
                                        // customer.numRut = value.toString();
                                        //},
                                        ),
                                    TextFormField(
                                        readOnly: true,
                                        controller: TextEditingController()
                                          ..text = _LoginUser,
                                        decoration: InputDecoration(
                                            fillColor: Colors.grey[400],
                                            filled: true,
                                            labelText: "Vendedor",
                                            labelStyle:
                                                TextStyle(color: Colors.white)),
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        onSaved: (val) {
                                          _bill.codUser = _CodUser;
                                          //print('saved');
                                        }
                                        // onSaved: (value) {
                                        // customer.numRut = value.toString();
                                        //},
                                        ),
                                    DropdownButtonFormField(
                                      // decoration: textInputDecoration,
                                      decoration: InputDecoration(
                                          labelText: "Tipo de Cobro"),
                                      value: _tipocobro.length > 0
                                          ? _tipocobro[0].codBillingType
                                          : 0,

                                      items: _tipocobro.map((emap) {
                                        return DropdownMenuItem(
                                          value: emap.codBillingType != null
                                              ? emap.codBillingType
                                              : 0,
                                          child: Text(emap.strDescription!),
                                        );
                                      }).toList(),

                                      onSaved: (val) {
                                        if (val != null) {
                                          _bill.codBillingType = val as int;
                                        } else {
                                          _bill.codBillingType = 0;
                                        }
                                        //print('saved');
                                      },

                                      onChanged: (val) async {
                                        print(val.toString() + '_________');
                                        //  setState(() {
                                        //   loginForm.company = val.toString();
                                        //});
                                      },
                                    ),
                                    DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          labelText: "Metodo de Pago"),
                                      // decoration: textInputDecoration,
                                      value: _metodospago[0].codPaymentMethod,

                                      items: _metodospago.map((e) {
                                        return DropdownMenuItem(
                                          value: e.codPaymentMethod != null
                                              ? e.codPaymentMethod
                                              : 0,
                                          child: Text(e.strDescription!),
                                        );
                                      }).toList(),
                                      onSaved: (val) {
                                        if (val != null) {
                                          _bill.codPaymentMethod = val as int;
                                        } else {
                                          _bill.codPaymentMethod = 0;
                                        }

                                        //print('saved');
                                      },

                                      onChanged: (val) async {
                                        print(val.toString() + '_________');
                                        //  setState(() {
                                        //   loginForm.company = val.toString();
                                        //});
                                      },
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "N° Operación",
                                        icon: Icon(Icons.confirmation_number),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      //enabled: false,
                                      /*
                                      
                                      validator: (dir) => dir == null || dir == ''
                                          ? 'Este Campo no puede estar en blanco'
                                          : null,*/
                                      //enabled: false,

                                      onSaved: (val) {
                                        _bill.strOperation = val.toString();
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
                                      cursorColor: Colors.blue[900],
                                      readOnly: true,
                                      enableInteractiveSelection: false,
                                      controller: _editingController,
                                      onTap: () =>
                                          _selectDate(context), // Refer step 3

                                    
                                      decoration: InputDecoration(
                                          labelText: "Fecha",
                                          hintText: (_selectedDate.toString())),
                                      validator: (dir) => dir == null || dir == ''
                                          ? 'Este Campo no puede estar en blanco'
                                          : null,
                                      onSaved: (val) {
                                        String datetext = val.toString();
                                        var parsedDate = DateTime.parse(datetext);
                                        String milli = parsedDate
                                            .millisecondsSinceEpoch
                                            .toString();

                                        _bill.dteBillingDate = milli;
                                        //print('saved');
                                      },
                                    ),*/
                                    DropdownButtonFormField(
                                      decoration:
                                          InputDecoration(labelText: "banco"),
                                      // decoration: textInputDecoration,
                                      value: _bank.length > 0
                                          ? _bank[0].codBank
                                          : 0,

                                      items: _bank.map((emap) {
                                        return DropdownMenuItem(
                                          value: emap.codBank != null
                                              ? emap.codBank
                                              : 0,
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
                                          _bill.codBank = val as int;
                                        } else {
                                          _bill.codBank = 0;
                                        }

                                        //print('saved');
                                      },
                                    ),
                                    DropdownButtonFormField(
                                      // decoration: textInputDecoration,
                                      decoration: InputDecoration(
                                          labelText: "N° Moneda"),
                                      value: _currency.length > 0
                                          ? _currency[0].codCurrency
                                          : 0,
                                      items: _currency.map((curr) {
                                        return DropdownMenuItem(
                                          value: curr.codCurrency != null
                                              ? curr.codCurrency
                                              : 0,
                                          child: Text(curr.strDescription!),
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
                                          _bill.codCurrency = val as int;
                                        } else {
                                          _bill.codCurrency = 0;
                                        }

                                        //print('saved');
                                      },
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Monto Operación",
                                        icon: Icon(Icons.payments_outlined),
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true, signed: false),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"[0-9.]")),
                                        TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                          try {
                                            final text = newValue.text;
                                            if (text.isNotEmpty)
                                              double.parse(text);
                                            return newValue;
                                          } catch (e) {}
                                          return oldValue;
                                        }),
                                      ],
                                      /*inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],*/

                                      //enabled: false,
                                      validator: (dir) => dir == null ||
                                              dir == ''
                                          ? 'Este Campo no puede estar en blanco'
                                          : null,
                                      //enabled: false,

                                      onSaved: (val) {
                                        if (val != null) {
                                          _bill.numAmountOperation =
                                              double.parse(val);
                                        } else {
                                          _bill.numAmountOperation = 0;
                                        }

                                        //print('saved');
                                      },
                                      // decoration:
                                      //   InputDecoration(labelText: "Vendedor"),
                                      // onSaved: (value) {
                                      // customer.numRut = value.toString();
                                      //},
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Observaciones .."),
                                      keyboardType: TextInputType.text,
                                      onSaved: (val) {
                                        _bill.strComments =
                                            val.toString().toLowerCase();
                                        //print('saved');
                                      },
                                    ),
                                    /*TextField(
                                      maxLines: 8,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Observaciones .."),
                                       onSaved: (val) {
                                        bill.numAmountOperation = val.toString() as double;
                                        //print('saved');
                                      },
                                    ),*/
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.orange,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      // style: wi,
                                      onPressed: () async {
                                        final msg_confirm = SnackBar(
                                            content:
                                                Text(' Confirme Su perdido !'));
                                        final msg_wait = SnackBar(
                                            content:
                                                Text('Espere un momento....'));
                                        final msg_err = SnackBar(
                                            content: Text(
                                                'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                                        //final f = formGlobalKey;
                                        // customerProvider.isLoading = true;
                                        FocusScope.of(context).unfocus();
                                        //final f = customerProvider.formKey;
                                        if (formGlobalKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            this.isAbsorbing =
                                                !this.isAbsorbing;
                                          });

                                          formGlobalKey.currentState!.save();

                                          _bill.dteBillingDate =
                                              _editingController.text;

                                          _bill.codCompany =
                                              int.parse(_CodCompany);

                                          _bill.dteCreateDate =
                                              DateTime.now().toString();

                                          _bill.flgState = 0;
                                          _bill.flgSync = -1;

                                          // print(_bill.toString());
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Confirme recibo !.')),
                                          );

                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'BillingNewConfirm',
                                              (route) => false,
                                              arguments: _bill);
                                        }
                                      },
                                      child: Row(
                                        textBaseline: TextBaseline.ideographic,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Icon(
                                            Icons.error_outlined,
                                            // color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            'Imprimir Pre - Procesado',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                                        final msg_confirm = SnackBar(
                                            content:
                                                Text(' Confirme Su perdido !'));
                                        final msg_wait = SnackBar(
                                            content:
                                                Text('Espere un momento....'));
                                        final msg_err = SnackBar(
                                            content: Text(
                                                'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                                        //final f = formGlobalKey;
                                        // customerProvider.isLoading = true;
                                        FocusScope.of(context).unfocus();
                                        //final f = customerProvider.formKey;
                                        if (formGlobalKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            this.isAbsorbing =
                                                !this.isAbsorbing;
                                          });

                                          formGlobalKey.currentState!.save();
                                          _bill.flgState = 1;
                                          _bill.flgSync = -1;
                                          _bill.dteBillingDate =
                                              _editingController.text;
                                          _bill.dteCreateDate =
                                              DateTime.now().toString();
                                          _bill.codCompany =
                                              int.parse(_CodCompany);

                                          //    print(_bill.dteCreateDate.toString() +
                                          //      "--------------------");
                                          // estado procesaro
                                          // print(_bill.toString());
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Confirme recibo !.')),
                                          );

                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'BillingNewConfirm',
                                              (route) => false,
                                              arguments: _bill);
                                        }
                                      },
                                      child: Row(
                                        textBaseline: TextBaseline.ideographic,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                            )
                          ],
                        ),
                      )
                      // _CustomAppBar()
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

  // _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate, // Refer step 1
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //   );
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  // }

  void _showAlert(BuildContext context, Customer customerMensaje) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          if (customerMensaje.flagMensajeInvasivo != 1) {
            // print(">>> entramos porqueeeee");
            Navigator.of(context).pop();
            return Text('');
          } else {
            print(">>> entramos aquii");
            return AlertDialog(
                title: Text('RECORDATORIO'),
                actions: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Mensaje : '),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(customerMensaje.mensaje.toString()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Deuda Total : '),
                            ),
                            Expanded(
                              flex: 5,
                              child:
                                  Text(customerMensaje.deudaTotal.toString()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Deuda Vencida : '),
                            ),
                            Expanded(
                              flex: 5,
                              child:
                                  Text(customerMensaje.deudaVencida.toString()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Dias Vencidos : '),
                            ),
                            Expanded(
                              flex: 5,
                              child:
                                  Text(customerMensaje.diasVencida.toString()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Fecha Ultima Venta : '),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                  customerMensaje.fechaUltimaVenta.toString()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('Condición de Credito : '),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                  customerMensaje.condicionCredito.toString()),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  //   Text(">> Aqui algo"),
                  //   Text(customerMensaje.mensaje.toString()),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Recibido.'),
                  )
                ],
                actionsAlignment: MainAxisAlignment.start);
          }
        });
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
                    /*validator: (dir) => dir == null || dir == ''
                        ? 'Este Campo no puede estar en blanco'
                        : null,
                    */
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
}
