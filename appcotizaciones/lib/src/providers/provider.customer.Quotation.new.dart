import 'package:appcotizaciones/src/constants/listController.dart';
import 'package:appcotizaciones/src/constants/listProdModify.dart';
import 'package:appcotizaciones/src/models/billing.dart';
import 'package:appcotizaciones/src/models/company.dart';
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
import 'package:appcotizaciones/src/models/selcurrency.dart';
import 'package:appcotizaciones/src/models/selproduct.dart';
import 'package:appcotizaciones/src/modelscrud/company_crt.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryTime_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryType_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paycondition_crt.dart';
import 'package:appcotizaciones/src/modelscrud/product_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotationProduct_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/screens/product_add_edit_form.dart';
import 'package:appcotizaciones/src/screens/product_add_form.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/utils/size_config.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:appcotizaciones/src/widgets/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CustomerQuotationNew extends StatefulWidget {
  CustomerQuotationNew({Key? key}) : super(key: key);

  @override
  _CustomerQuotationNewState createState() => _CustomerQuotationNewState();
}

class _CustomerQuotationNewState extends State<CustomerQuotationNew> {
  String _LoginUser = '';
  int _CodUser = 0;
  String _Company = '';
  String _CodCompany = '0';
  String _Almacen = "";
  late Customer _customer;

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;

  /*Integration */

  DateTime selectedDate = DateTime.now();
  final DateFormat format = DateFormat("yyyy-MM-dd");
  late String dropdownvalue;
  bool loading = true, loader = false;

  List<Product> products = <Product>[];
  List<Currency> currency = <Currency>[];
  List<DeliveryType> deliveryTypes = <DeliveryType>[];
  List<DeliveryTime> deliveryTimes = <DeliveryTime>[];
  List<PayCondition> payConditions = <PayCondition>[];

  Currency selectedCurrency = new Currency(codCurrency: 0, strDescription: '');
  late DeliveryType selectedDeliveryType;
  late DeliveryTime selectedDeliveryTimes;
  late PayCondition selectedPayConditions;
  Company datacompany = new Company(
      codCompany: 0,
      codCurrency: '',
      numImpuesto: '',
      strAddress: '',
      strDesCompany: '',
      strLogo: '',
      strPhone: '',
      strPrintFormat: '',
      strRucCompany: '');

  // CONTROLLERS
  TextEditingController customerController = TextEditingController();
  TextEditingController vendedorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController socialController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController lgvController = TextEditingController();

  Customer _customerMensaje = Customer();

  late int _stateQuotation = 0;
  int _bloquearCurrency = 0;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  /*Integration */

  void initState() {
    super.initState();

    getValues();
    getSelectCurrency();

    dateController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); //format.format(DateTime.now());
    //customerController.text = "3453453";

    SharedPreferences.getInstance().then((res) {
      setState(() {
        _LoginUser = res.getString("usuario") ?? '';
        _Company = res.getString("empresa") ?? '';
        _CodUser = res.getInt("codigo") ?? 0;
        _CodCompany = res.getString("codcompany") ?? '0';
        _Almacen = res.getString("almacen") ?? '';

        ListItems.listalmacen.clear();
        ListItems.listalmacen.add(_Almacen);

        getCompany(res.getString("codcompany") ?? '0');
      });
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() => _source = source);
      }
    });
  }

  Future getCompany(String codCompany) async {
    // ProductStockCtr productStockCtr = ProductStockCtr();
    // int codMoneda = ListItems.listmoneda[0].codmoneda;
    //ProductCtr productcrt = ProductCtr();
    CompanyCtr com = new CompanyCtr();
    try {
      List<Company> listCompany = await com.getCompany(codCompany);

      setState(() {
        datacompany = listCompany[0];
        ListItems.listIgv.add("");
        ListItems.listIgv[0] = datacompany.numImpuesto.toString();
      });
    } catch (err) {
      print(err);
    }
  }

  Future getSelectCurrency() async {
    int ccompany = 0;
    CurrencyCtr currencycrt = new CurrencyCtr();

    SharedPreferences.getInstance().then((res) {
      setState(() {
        ccompany = int.parse(res.getString("codcompany") ?? '0');
        print(ccompany.toString() + "--------------> entramos");
      });

      currencycrt.getDataCurrencyforCompany(ccompany.toString()).then((value) {
        selectedCurrency = value[0];
      });
    });
  }

  Future getValues() async {
    // if (codCompany != "0") {
    //   print(codCompany + "------------>");
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

        ListItems.listItems.clear();
        ListItems.listmoneda.clear();

        ListSelProduct.listproduct.clear();
        _showAlert(context, _customer);
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     content: const Text('Dialog content'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: const Text('Accept'),
        //       ),
        //     ],
        //   ),
        // );
      });
    } catch (err) {
      print(err);
    }
    // }
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Center(
              child: Text(
                'Cuidado : Se perderan los datos ingresados !! \n ¿ Desea Salir ? ',
                textAlign: TextAlign.center,
              ),
            ),
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int _conteo = 0;
  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    _customer = customer;
    QuotationCrt crt = new QuotationCrt();

    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;
    return WillPopScope(
      onWillPop: () async {
        bool? showpopup = await showWarning(context);
        if (showpopup == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'listQuotas', (route) => false,
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...userTile(),
              if (loading)
                Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                )),
              if (!loading) quoteAffForm(customer)
            ],
          ),
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

  void _showAlert(BuildContext context, Customer customerMensaje) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          if (customerMensaje.flagMensajeInvasivo != 1) {
            Navigator.of(context).pop();
            return Text('');
          } else {
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

  List<Widget> userTile() {
    final space = SizedBox(height: 8);
    return [
      // Container(
      //   padding: EdgeInsets.all(20),
      //   //width: SizeConfig.screenWidth,
      //   color: Colors.grey.shade600,
      //   child: const Text(
      //     "Cotizaciones Agregar",
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      //   ),
      // ),
      space,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Icon(
                  Icons.account_circle,
                  size: 60,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                regularText('Cliente: ' + _customer.strName.toString()),
                // regularText('Rubro: Ferretria'),
                regularText('Doc. Fiscal: ${_customer.numRucCustomer}'),
              ],
            ),
          ),
        ],
      ),
      space,
      space,
      space,
    ];
  }

  Widget quoteAffForm(Customer cust) {
    final space = SizedBox(height: 8);
    customerController.text = cust.codCustomer.toString();
    vendedorController.text = _CodUser.toString();
    socialController.text = cust.strName.toString();

    return Form(
      key: _key,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            regularText('Fecha'),
            // textField('Pick a date', dateController, _selectDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.calendar_today,
                    size: 25,
                    // size: SizeConfig.textMultiplier * 2.3,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: normalField(
                    hint: cust.numRucCustomer,
                    controller: dateController, //--customerController,
                    readOnly: true,
                    maxLine: 1,
                    inputType: TextInputType.text,
                    validator: (value) =>
                        value!.isEmpty ? "Field is empty!" : null,
                  ),
                )
                // Expanded(
                //   flex: 7,
                //   child: DateTimeField(
                //     initialValue: DateTime.now(),
                //     readOnly: true,
                //     format: format,
                //     controller: dateController,
                //     validator: (value) =>
                //         value == null ? "Field is required!" : null,
                //     onShowPicker: (context, currentValue) {
                //       return showDatePicker(
                //           context: context,
                //           firstDate: DateTime(1900),
                //           initialDate: DateTime.now(),
                //           lastDate: DateTime(2100));
                //     },
                //   ),
                // ),
              ],
            ),
            space,

            regularText('Nro. Cotización'),
            space,
            coloredText('3453453'),
            space,

            regularText('Doc. Fiscal'),
            normalField(
              hint: cust.numRucCustomer,
              controller: TextEditingController(
                  text: cust.numRucCustomer), //--customerController,
              readOnly: true,
              maxLine: 1,
              inputType: TextInputType.text,
              validator: (value) => value!.isEmpty ? "Field is empty!" : null,
            ),
            space,

            regularText('Razon Social'),
            normalField(
              readOnly: true,
              controller: socialController,
              maxLine: 1,
              inputType: TextInputType.text,
              validator: (value) => value!.isEmpty ? "Field is empty!" : null,
            ),
            space,

            regularText('Vendedor'),
            normalField(
              hint: _LoginUser.toString(),
              controller: TextEditingController(
                text: _LoginUser.toString(),
              ),
              readOnly: true,
              maxLine: 1,
              inputType: TextInputType.text,
              validator: (value) => value!.isEmpty ? "Field is empty!" : null,
            ),
            space,

            // PAYMENT CONDITIONS
            regularText('Condicion de Pago'),
            normalDropdown(payConditions, 0, -1),
            space,

            // DELIVERY TYPES
            regularText('Tipo de Entrega'),
            normalDropdown(deliveryTypes, 0, -1),
            space,

            // DELIVERY TIMES
            regularText('Tiempo de Entrega'),
            normalDropdown(deliveryTimes, 0, -1),
            space,

            // CURRENCY DROP DOWN
            regularText('Moneda'),

            DropdownButtonFormField(
              icon: Icon(Icons.keyboard_arrow_down),
              validator: (value) => value == null ? "Field is empty!" : null,
              // hint: _selectalmacen == ""
              //     ? Text('Dropdown')
              //     : Text(
              //         "Almacen " + _selectalmacen.toString(),
              //         style: TextStyle(color: Colors.blue),
              //       ),
              value: int.parse(datacompany.codCurrency!),
              isExpanded: true,
              iconSize: 30.0,
              onSaved: (newValue) => FocusScope.of(context).unfocus(),
              onTap: () => FocusScope.of(context).unfocus(),
              onChanged: _bloquearCurrency == 1
                  ? null
                  : (value) {
                      //print(value);
                      late Currency cur = new Currency();
                      setState(() {
                        currency.forEach((element) {
                          if (element.codCurrency.toString() ==
                              value.toString()) {
                            selectedCurrency = element;
                          }
                        });
                        // selectedCurrency = value as Currency;

                        // print(selectedCurrency);

                        // dropdownvalue = value.toString();
                      });
                    },
              items: currency.map((location) {
                return DropdownMenuItem(
                  child: new Text(location.strDescription!),
                  value: location.codCurrency,
                );
              }).toList(),
            ),

            // normalDropdown(currency, _bloquearCurrency,
            //     int.parse(datacompany.codCurrency!)),
            space,

            // CHOOSE PRODUCTS
            popup(),
            space,

            // LIST PRODUCTS
            if (ListItems.listItems.isNotEmpty)
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, minHeight: 200),
                  child: Scrollbar(
                    // isAlwaysShown: true,
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ListItems.listItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  ListItems.listItems[index].product_name
                                      .toString()
                                      .trimRight()
                                      .trimLeft(),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    ListItems.listItems[index].sub_total
                                        .toString(),
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  // print("deleted");
                                  var subTotal = double.tryParse(ListItems
                                      .listItems
                                      .elementAt(index)
                                      .sub_total);
                                  setState(() {
                                    subTotalController.text = (double.tryParse(
                                                subTotalController.text == ''
                                                    ? '0'
                                                    : subTotalController
                                                        .text)! -
                                            subTotal!)
                                        .toStringAsFixed(2);
                                    lgvController.text = (double.tryParse(
                                                subTotalController.text == ''
                                                    ? '0'
                                                    : subTotalController
                                                        .text)! *
                                            double.parse(datacompany.numImpuesto
                                                .toString()))
                                        .toStringAsFixed(2);
                                    totalController.text = (double.tryParse(
                                                subTotalController.text == ''
                                                    ? '0'
                                                    : subTotalController
                                                        .text)! +
                                            (double.tryParse(
                                                    subTotalController.text ==
                                                            ''
                                                        ? '0'
                                                        : subTotalController
                                                            .text)! *
                                                double.parse(datacompany
                                                    .numImpuesto
                                                    .toString())))
                                        .toStringAsFixed(2);
                                    ListItems.listItems.removeAt(index);
                                  });

                                  if (ListItems.listItems.length == 0) {
                                    _bloquearCurrency = 0;
                                  }
                                },
                                icon: Icon(Icons.delete_outlined),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    ListSelProduct.listproduct.clear();
                                    ListSelProduct.indexprod = index;

                                    ListSelProduct.listproduct
                                        .add(ListItems.listItems[index]);

                                    print(ListSelProduct.listproduct);
                                  });

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return openDialogueEdit();
                                      }).then((value) {
                                    if (value != null) {
                                      double subTotal = 0;
                                      ListItems.listItems.forEach((element) {
                                        subTotal +=
                                            double.tryParse(element.sub_total)!;
                                      });
                                      setState(() {
                                        subTotalController.text =
                                            subTotal.toStringAsFixed(2);
                                        lgvController.text = (subTotal *
                                                double.parse(datacompany
                                                    .numImpuesto
                                                    .toString()))
                                            .toStringAsFixed(2);
                                        totalController.text = (subTotal +
                                                (subTotal *
                                                    double.parse(datacompany
                                                        .numImpuesto
                                                        .toString())))
                                            .toStringAsFixed(2);
                                      });

                                      if (ListItems.listItems.length > 0) {
                                        _bloquearCurrency = 1;
                                      }
                                    }
                                  });
                                },
                                icon: Icon(Icons.edit),
                              ), // icon-1
                              // icon-2
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        height: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            space,

            regularText('Observaciones'),
            normalField(
              controller: observationController,
              maxLine: 1,
              inputType: TextInputType.text,
              // validator: (value) => value!.isEmpty ? "Field is empty!" : null,
            ),
            space,

            regularText('Subtotal'),
            normalField(
                controller: subTotalController,
                maxLine: 1,
                readOnly: true,
                validator: (value) => value!.isEmpty ? "Field is empty!" : null,
                inputType: TextInputType.number),
            space,

            regularText(
                '+${(double.parse(datacompany.numImpuesto.toString()) * 100).toStringAsFixed(0)}% IGV'),
            normalField(
                controller: lgvController,
                maxLine: 1,
                readOnly: true,
                validator: (value) => value!.isEmpty ? "Field is empty!" : null,
                inputType: TextInputType.number),
            space,

            regularText('Total'),
            normalField(
                controller: totalController,
                maxLine: 1,
                readOnly: true,
                validator: (value) => value!.isEmpty ? "Field is empty!" : null,
                inputType: TextInputType.number),
            space,
            space,
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         primary: Colors.orange,
            //         side: BorderSide(
            //           width: 2.0,
            //           color: Colors.black,
            //         )),
            //     onPressed: () {},
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       // ignore: prefer_const_literals_to_create_immutables
            //       children: [
            //         Text("Imprimire Pre - Procesado"),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Icon(Icons.error),
            //       ],
            //     ),
            //   ),
            // ),
            // space,

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                onPressed: handleSubmit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    if (loader)
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    else ...[
                      Text(
                        "Imprimir Pre - Procesado",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.error_outlined),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                onPressed: handleSubmitProccess,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    if (loader)
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    else ...[
                      Text("Imprimir Procesado",
                          style: TextStyle(fontSize: 15.0)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.check_circle_rounded),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget normalDropdown2(List<dynamic> items, int bloq, int defaultvalue) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        isExpanded: true,
        value: defaultvalue,
        icon: Icon(Icons.keyboard_arrow_down),
        validator: (value) => value == null ? "Field is empty!" : null,
        items: items.map((item) {
          return DropdownMenuItem(
              value: item,
              child: Text(item.runtimeType == Currency ||
                      item.runtimeType == PayCondition
                  ? item.strDescription
                  : item.description));
        }).toList(),
        onSaved: (newValue) => FocusScope.of(context).unfocus(),
        onTap: () => FocusScope.of(context).unfocus(),
        onChanged: bloq == 1
            ? null
            : (value) {
                setState(() {
                  if (value.runtimeType == Currency)
                    selectedCurrency = value as Currency;
                  if (value.runtimeType == DeliveryTime)
                    selectedDeliveryTimes = value as DeliveryTime;
                  if (value.runtimeType == DeliveryType)
                    selectedDeliveryType = value as DeliveryType;
                  if (value.runtimeType == PayCondition)
                    selectedPayConditions = value as PayCondition;
                  // dropdownvalue = value.toString();
                });
              },
      ),
    );
  }

  Widget normalDropdown(List<dynamic> items, int bloq, int defaultvalue) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        isExpanded: true,
        // value: defaultvalue,
        icon: Icon(Icons.keyboard_arrow_down),
        validator: (value) => value == null ? "Field is empty!" : null,
        items: items.map((item) {
          return DropdownMenuItem(
              value: item,
              child: Text(item.runtimeType == Currency ||
                      item.runtimeType == PayCondition
                  ? item.strDescription
                  : item.description));
        }).toList(),
        onSaved: (newValue) => FocusScope.of(context).unfocus(),
        onTap: () => FocusScope.of(context).unfocus(),
        onChanged: bloq == 1
            ? null
            : (value) {
                setState(() {
                  if (value.runtimeType == Currency)
                    selectedCurrency = value as Currency;
                  if (value.runtimeType == DeliveryTime)
                    selectedDeliveryTimes = value as DeliveryTime;
                  if (value.runtimeType == DeliveryType)
                    selectedDeliveryType = value as DeliveryType;
                  if (value.runtimeType == PayCondition)
                    selectedPayConditions = value as PayCondition;
                  // dropdownvalue = value.toString();
                });
              },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    print("tappes");
    // FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(
        () => selectedDate = picked,
      );
    }
  }

  handleSubmit() async {
    //QuotationCrt quotationCrt = new QuotationCrt();

    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      try {
        setState(() => loader = true);
        //var res = await quotationCrt.insertQuotation(Quotation(

        Quotation quotation = new Quotation(
          createDate: DateTime.now().toString(),
          total: totalController.text,
          subTotal: subTotalController.text,
          // company: ,
          currencyId: selectedCurrency.codCurrency,
          dateQuotation: dateController.text,
          deliveryTimeId: selectedDeliveryTimes.id,
          deliveryTypeId: selectedDeliveryType.id,
          lgv: lgvController.text,
          nameBusiness: socialController.text,
          // createUser: ,
          observation: observationController.text,
          payId: selectedPayConditions.codPayCondition,
          state: '0',
          updateflg: -1,
          company: int.parse(_CodCompany), //_Company.toString(),
          // quotationParents: ,
          // updateDate: ,
          customerId: customerController.text,
          // updateUser: ,
          userId: _CodUser,
        );
        // QuotationProductCrt crt = new QuotationProductCrt();

        List<QuotationProduct> quotationproducts = ListItems.listItems;
        setState(() {
          loader = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Confirme su cotizacion porfavor !")));

        QuotationPlusProducts quotationPlusProducts = new QuotationPlusProducts(
            quotat: quotation,
            listproduct: quotationproducts,
            customer: _customer,
            salesperson: _LoginUser);

        Navigator.pushNamedAndRemoveUntil(
            context, 'QuotationNewConfirm', (route) => false,
            arguments: quotationPlusProducts);
      } catch (err) {
        print(err);
        setState(() {
          loader = false;
        });
      }
    }
  }

  handleSubmitProccess() async {
    //QuotationCrt quotationCrt = new QuotationCrt();

    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      try {
        setState(() => loader = true);
        //var res = await quotationCrt.insertQuotation(Quotation(

        Quotation quotation = new Quotation(
          createDate: DateTime.now().toString(),
          total: totalController.text,
          subTotal: subTotalController.text,
          // company: ,
          currencyId: selectedCurrency.codCurrency,
          dateQuotation: dateController.text,
          deliveryTimeId: selectedDeliveryTimes.id,
          deliveryTypeId: selectedDeliveryType.id,
          lgv: lgvController.text,
          nameBusiness: socialController.text,
          // createUser: ,
          observation: observationController.text,
          payId: selectedPayConditions.codPayCondition,
          state: '1',
          updateflg: -1,
          company: int.parse(_CodCompany), //_Company.toString(),
          //company: _Company.toString(),
          // quotationParents: ,
          // updateDate: ,
          customerId: customerController.text,
          // updateUser: ,
          userId: _CodUser,
        );
        // QuotationProductCrt crt = new QuotationProductCrt();

        List<QuotationProduct> quotationproducts = ListItems.listItems;
        setState(() {
          loader = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Confirme su cotizacion porfavor !")));

        QuotationPlusProducts quotationPlusProducts = new QuotationPlusProducts(
            quotat: quotation,
            listproduct: quotationproducts,
            customer: _customer,
            salesperson: _LoginUser);

        Navigator.pushNamedAndRemoveUntil(
            context, 'QuotationNewConfirm', (route) => false,
            arguments: quotationPlusProducts);
      } catch (err) {
        print(err);
        setState(() {
          loader = false;
        });
      }
    }
  }

  Widget popup() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              side: BorderSide(
                width: 5.0,
                color: Colors.grey.shade400,
              )),
          onPressed: () {
            print(ListItems.listIgv);

            ListItems.listmoneda.clear();
            Cmoneda m = new Cmoneda(codmoneda: selectedCurrency.codCurrency!);
            ListItems.listmoneda.add(m);

            // _displayTextInputDialog;
            showDialog(
                context: context,
                builder: (context) {
                  return openDialogue();
                }).then((value) {
              if (value != null) {
                double subTotal = 0;
                ListItems.listItems.forEach((element) {
                  subTotal += double.tryParse(element.sub_total)!;
                });
                setState(() {
                  subTotalController.text = subTotal.toStringAsFixed(2);
                  lgvController.text = (subTotal *
                          double.parse(datacompany.numImpuesto.toString()))
                      .toStringAsFixed(2);
                  totalController.text = (subTotal +
                          (subTotal *
                              double.parse(datacompany.numImpuesto.toString())))
                      .toStringAsFixed(2);
                });

                if (ListItems.listItems.length > 0) {
                  _bloquearCurrency = 1;
                }
              }
            });
          },
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Elegir Productos",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )),
    );
  }

  Widget openDialogue() {
    return ProductAddForm();
  }

  Widget openDialogueEdit() {
    return ProductAddEditForm();
  }
}
