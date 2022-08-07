import 'dart:convert';
import 'dart:io' as io2;

import 'package:appcotizaciones/src/constants/RepQuotation.dart';
import 'package:appcotizaciones/src/constants/listController.dart';
import 'package:appcotizaciones/src/constants/listControllerEdit.dart';
import 'package:appcotizaciones/src/constants/listProdModify.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/delivery_time_model.dart';
import 'package:appcotizaciones/src/models/delivery_type_model.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/models/report_quotation.dart';
import 'package:appcotizaciones/src/models/selcurrency.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryTime_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryType_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paycondition_crt.dart';
import 'package:appcotizaciones/src/modelscrud/product_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotationProduct_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/screens/product_add_edit_form.dart';
import 'package:appcotizaciones/src/screens/product_edit_edit_form.dart';

import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/utils/size_config.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:appcotizaciones/src/widgets/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:appcotizaciones/src/screens/product_edit_form.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../models/company.dart';
import '../modelscrud/company_crt.dart';

class CustomerQuotationEdit extends StatefulWidget {
  CustomerQuotationEdit({Key? key}) : super(key: key);

  @override
  _CustomerQuotationEditState createState() => _CustomerQuotationEditState();
}

class _CustomerQuotationEditState extends State<CustomerQuotationEdit> {
  String _LoginUser = '';
  int _CodUser = 0;
  String _Company = '';
  String _CodCompany = '';
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

  // CONTROLLERS
  TextEditingController customerController = TextEditingController();
  TextEditingController vendedorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController socialController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController lgvController = TextEditingController();

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

  late int _stateQuotation = 0;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<QuotationProduct> _updQuotationProducts = [];
  late Quotation _updQuotation;
  late String _updSalesperson;

  PayCondition _payed =
      new PayCondition(codPayCondition: 1, strDescription: "Contado");

  int _contador = 0;
  int _bloquearCurrency = 0;

  /*Integration */

  void initState() {
    super.initState();

    dateController.text = format.format(DateTime.now());
    //customerController.text = "3453453";

    SharedPreferences.getInstance().then((res) {
      setState(() {
        _LoginUser = res.getString("usuario") ?? '';
        _Company = res.getString("empresa") ?? '';
        _CodUser = res.getInt("codigo") ?? 0;
        _CodCompany = res.getString("codcompany") ?? '';
      });

      getCompany(res.getString("codcompany") ?? '0');
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() => _source = source);
      }
    });

    getValues();
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
        ListItemsEdit.listIgv.add("");
        ListItemsEdit.listIgv[0] = datacompany.numImpuesto.toString();
      });
    } catch (err) {
      print(err);
    }
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
      // if(quotaionProducts.isNotEmpty){
      //   Future.forEach(quotaionProducts, (element) => setState((){
      //     ListItems.listItems.add(element);
      //   }));
      //   setState(() {
      //     loading = false;
      //   });
      // } else {
      //   setState(() {
      //     loading = false;
      //   });
      // }
    } catch (err) {
      print(err);
    }
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                'Se perderan los cambios !! \r, ¿ Quieres salir de la edición ?'),
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

  @override
  Widget build(BuildContext context) {
    //final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    final quotationplusproducts =
        ModalRoute.of(context)!.settings.arguments as QuotationPlusProducts;

    ListItemsEdit.listIgv.add(datacompany.numImpuesto.toString());

    _customer = quotationplusproducts.customer;
    _updQuotationProducts = quotationplusproducts.listproduct;
    _updQuotation = quotationplusproducts.quotat;
    _updSalesperson = quotationplusproducts.salesperson;

    QuotationCrt crt = new QuotationCrt();

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
              if (!loading)
                quoteAffForm(_customer, _updQuotationProducts, _updQuotation,
                    _updSalesperson)
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

  List<Widget> userTile() {
    final space = SizedBox(height: 8);

    return [
      space,
      // Container(
      //   padding: EdgeInsets.all(20),
      //   //width: SizeConfig.screenWidth,
      //   color: Colors.grey.shade600,
      //   child: const Text(
      //     "Cotizaciones Agregar",
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      //   ),
      // ),
      // space,
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

  Widget quoteAffForm(
      Customer cust,
      List<QuotationProduct> updQuotationProducts,
      Quotation updQuotation,
      String updSalesperson) {
    final space = SizedBox(height: 8);

    if (_contador == 0) {
      customerController.text = cust.codCustomer.toString();
      vendedorController.text = updQuotation.customerId.toString();
      socialController.text = updQuotation.nameBusiness.toString();
      subTotalController.text = updQuotation.subTotal.toString();
      lgvController.text = updQuotation.lgv.toString();
      totalController.text = updQuotation.total.toString();
      observationController.text = updQuotation.observation.toString();

      ListItemsEdit.listmoneda.clear();
      Cmoneda n = new Cmoneda(codmoneda: updQuotation.currencyId!);
      ListItemsEdit.listmoneda.add(n);

      ListItemsEdit.listItems.clear();
      ListItemsEdit.listItems.addAll(updQuotationProducts);
      _contador = _contador + 1;

      if (ListItemsEdit.listItems.length > 0) {
        _bloquearCurrency = 1;
      }
    }

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
                    size: 25, //SizeConfig.textMultiplier * 2.3,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    updQuotation.dateQuotation.toString(),
                  ),

                  /*DateTimeField(
                    initialValue:
                        DateTime.parse(updQuotation.dateQuotation.toString()),
                    format: format,
                    controller: dateController,
                    validator: (value) =>
                        value == null ? "Field is required!" : null,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  ),*/
                ),
              ],
            ),
            space,

            regularText('N* Cotizacion'),
            space,
            regularTexthide2(updQuotation.id.toString()),
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
              controller: socialController,
              readOnly: true,
              maxLine: 1,
              inputType: TextInputType.text,
              validator: (value) => value!.isEmpty ? "Field is empty!" : null,
            ),
            space,

            regularText('Vendedor'),
            normalField(
              hint: _LoginUser.toString(),
              controller: TextEditingController(
                text: updSalesperson,
              ),
              readOnly: true,
              maxLine: 1,
              inputType: TextInputType.text,
              validator: (value) => value!.isEmpty ? "Field is empty!" : null,
            ),
            space,

            // PAYMENT CONDITIONS
            //regularText('Condicion de Pago'),

            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Condición de Pago"),
              // decoration: textInputDecoration,
              value: updQuotation.payId,

              items: payConditions.map((emap) {
                return DropdownMenuItem(
                  value:
                      emap.codPayCondition != null ? emap.codPayCondition : 0,
                  child: Text(emap.strDescription!),
                );
              }).toList(),

              onChanged: (val) async {
                //  print(val.toString() + '_________');
                if (val != null) {
                  updQuotation.payId = val as int;
                } else {
                  updQuotation.payId = 0;
                }

                //updQuotation.payId = val.
                //  setState(() {
                //   loginForm.company = val.toString();
                //});
              },
              onSaved: (newValue) => FocusScope.of(context).unfocus(),
              onTap: () => FocusScope.of(context).unfocus(),
              /*onSaved: (val) {
                                if (val != null) {
                                  billing.codBank = val as int;
                                } else {
                                  billing.codBank = 0;
                                }

                                //print('saved');
                              },*/
            ),
            //normalDropdown(payConditions, updQuotation.payId!.toInt()),

/*
            // DELIVERY TYPES
            regularText('Tipo de Entrega'),
            normalDropdown(deliveryTypes, updQuotation.deliveryTypeId!.toInt()),
            space,

            

            // DELIVERY TIMES
            regularText('Tiempo de Entrega'),
            normalDropdown(deliveryTimes, updQuotation.deliveryTimeId!.toInt()),
            space,
*/
            space,

            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Tipo de Entrega"),
              // decoration: textInputDecoration,
              value: updQuotation.deliveryTypeId,

              items: deliveryTypes.map((emap) {
                return DropdownMenuItem(
                  value: emap.id != null ? emap.id : 0,
                  child: Text(emap.description),
                );
              }).toList(),

              onChanged: (val) async {
                //  print(val.toString() + '_________');
                if (val != null) {
                  updQuotation.deliveryTypeId = val as int;
                } else {
                  updQuotation.deliveryTypeId = 0;
                }
              },
              onSaved: (newValue) => FocusScope.of(context).unfocus(),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            space,

            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Tiempo de Entrega"),
              // decoration: textInputDecoration,
              value: updQuotation.deliveryTimeId,

              items: deliveryTimes.map((emap) {
                return DropdownMenuItem(
                  value: emap.id != null ? emap.id : 0,
                  child: Text(emap.description),
                );
              }).toList(),

              onChanged: (val) async {
                //  print(val.toString() + '_________');
                if (val != null) {
                  updQuotation.deliveryTimeId = val as int;
                } else {
                  updQuotation.deliveryTimeId = 0;
                }
              },
              onSaved: (newValue) => FocusScope.of(context).unfocus(),
              onTap: () => FocusScope.of(context).unfocus(),
            ),

            space,

            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Moneda"),
              // decoration: textInputDecoration,
              value: updQuotation.currencyId,

              items: currency.map((emap) {
                return DropdownMenuItem(
                  value: emap.codCurrency != null ? emap.codCurrency : 0,
                  child: Text(emap.strDescription.toString()),
                );
              }).toList(),

              onChanged: _bloquearCurrency == 1
                  ? null
                  : (val) async {
                      //  print(val.toString() + '_________');
                      if (val != null) {
                        updQuotation.currencyId = val as int;
                        ListItemsEdit.listmoneda[0].codmoneda = val as int;
                      } else {
                        updQuotation.currencyId = 0;
                      }
                    },
              onSaved: (newValue) => FocusScope.of(context).unfocus(),
              onTap: () => FocusScope.of(context).unfocus(),
            ),

            // CHOOSE PRODUCTS
            popup(),
            space,

            // LIST PRODUCTS
            if (ListItemsEdit.listItems.isNotEmpty)
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, minHeight: 200),
                  child: Scrollbar(
                    // isAlwaysShown: true,
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ListItemsEdit.listItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  ListItemsEdit.listItems[index].product_name
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
                                    ListItemsEdit.listItems[index].sub_total
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
                                  var subTotal = double.tryParse(ListItemsEdit
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
                                    ListItemsEdit.listItems.removeAt(index);
                                  });
                                  if (ListItemsEdit.listItems.length == 0) {
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
                                        .add(ListItemsEdit.listItems[index]);
                                  });

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return openDialogueEdit();
                                      }).then((value) {
                                    if (value != null) {
                                      double subTotal = 0;
                                      ListItemsEdit.listItems
                                          .forEach((element) {
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

                                      if (ListItemsEdit.listItems.length > 0) {
                                        _bloquearCurrency = 1;
                                      }
                                    }
                                  });
                                },
                                icon: Icon(Icons.edit),
                              ), // icon-1
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
            /*
            // CURRENCY DROP DOWN
            regularText('Moneda'),
            normalDropdown(currency, updQuotation.currencyId!.toInt()),
            space, */

            regularText('Subtotal'),
            normalField(
                controller: subTotalController,
                maxLine: 1,
                readOnly: true,
                validator: (value) => value!.isEmpty ? "Field is empty!" : null,
                inputType: TextInputType.number),
            space,

            regularText(
                '+${(double.parse(datacompany.numImpuesto.toString()) * 100).toStringAsFixed(0)}% lgv'),
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
                onPressed: () async {
                  final msg_edit = SnackBar(
                      content:
                          Text(' La Cotización se actualizo con exito. !'));

                  final msg_err = SnackBar(
                      content: Text(
                          'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                  //QuotationCrt quotationCrt = new QuotationCrt();

                  FocusScope.of(context).unfocus();
                  if (_key.currentState!.validate()) {
                    QuotationCrt quotationCrt = new QuotationCrt();
                    QuotationProductCrt quotationproductCrt =
                        new QuotationProductCrt();

                    //var res = await quotationCrt.insertQuotation(Quotation(

                    //Quotation quotation = new Quotation(
                    //upd createDate: DateTime.now().toString(),
                    updQuotation.total = totalController.text;
                    updQuotation.subTotal = subTotalController.text;
                    updQuotation.dateQuotation = dateController.text;
                    // company: ,
                    //updQuotation.currencyId = selectedCurrency.codCurrency;
                    // updQuotation.dateQuotation: dateController.text,
                    //updQuotation.deliveryTimeId = selectedDeliveryTimes.id;
                    //updQuotation.deliveryTypeId = selectedDeliveryType.id;
                    updQuotation.lgv = lgvController.text;
                    updQuotation.nameBusiness = socialController.text;
                    // createUser: ,
                    updQuotation.observation = observationController.text;
                    //updQuotation.payId =
                    //  selectedPayConditions.codPayCondition;
                    updQuotation.state = '0';
                    updQuotation.updateflg = 0;

                    try {
                      setState(() => loader = true);
                      // print(updQuotation);
                      // print(ListItemsEdit.listItems);

                      if (await quotationCrt.updateQuotation(updQuotation) >
                          0) {
                        await quotationproductCrt
                            .deleteQuotationProductsperCode(
                                updQuotation.id.toString());

                        int corre = 1;
                        await Future.forEach(ListItemsEdit.listItems,
                            (QuotationProduct element) async {
                          element.quotation_id = updQuotation.id;
                          element.id =
                              updQuotation.id.toString() + corre.toString();

                          await quotationproductCrt
                              .insertQuotationProduct(element);

                          corre = corre + 1;
                        });

                        /********************** Generamos PDF ******************/

                        List<PayCondition> payConditions2 = payConditions
                            .where(
                                (o) => o.codPayCondition == updQuotation.payId)
                            .toList();

                        List<DeliveryTime> deliveryTimes2 = deliveryTimes
                            .where((o) => o.id == updQuotation.deliveryTimeId)
                            .toList();

                        List<DeliveryType> deliveryTypes2 = deliveryTypes
                            .where((o) => o.id == updQuotation.deliveryTypeId)
                            .toList();

                        List<Currency> currency2 = currency
                            .where(
                                (o) => o.codCurrency == updQuotation.currencyId)
                            .toList();
                        final directory = await getExternalStorageDirectory();

                        CompanyCtr comp = new CompanyCtr();
                        List<Company> arrCompany =
                            await comp.getCompany(_CodCompany);

                        ReportDataQuotation dataquotation =
                            new ReportDataQuotation(
                                path: directory!.path,
                                codCompany: _CodCompany,
                                quotationfin: updQuotation,
                                listprodquotationfin: ListItemsEdit.listItems,
                                customer: cust,
                                salesperson: updSalesperson,
                                paycondition: payConditions2[0]
                                    .strDescription
                                    .toString(),
                                deliverytype:
                                    deliveryTypes2[0].description.toString(),
                                deliverytime:
                                    deliveryTimes2[0].description.toString(),
                                currency: currency2[0].codCurrency!,
                                currencyName: currency2[0].strName!,
                                company: arrCompany[0],
                                cur: currency2[0]);

                        Reports reports = new Reports();
                        reports.reportsEnableds(dataquotation);

                        // if (_CodCompany == "1") {
                        //   reports.reportsQuotation_refermat(dataquotation);
                        // } else {
                        //   reports.reportsQuotation(dataquotation);
                        // }

                        //_createPDF(cust, ListItemsEdit.listItems, updQuotation,updSalesperson);
                        /********************** Generamos PDF ******************/
                      }

                      setState(() {
                        loader = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(msg_edit);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'listQuotas', (route) => false,
                          arguments: cust);
                    } catch (err) {
                      setState(() {
                        loader = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err.toString())));
                    }
                  }
                },
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
                      Text("Imprimir Pre - Procesado",
                          style: TextStyle(fontSize: 15.0)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.error_outlined),
                    ],
                  ],
                ),
              ),
            ),
            space,
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
                onPressed: () async {
                  final msg_confirm = SnackBar(
                      content: Text(' La Cotización se registro con exito !'));

                  final msg_err = SnackBar(
                      content: Text(
                          'Tuvimos un error en el registro !! , Intentelo de nuevo.'));

                  //QuotationCrt quotationCrt = new QuotationCrt();

                  FocusScope.of(context).unfocus();
                  if (_key.currentState!.validate()) {
                    QuotationCrt quotationCrt = new QuotationCrt();
                    QuotationProductCrt quotationproductCrt =
                        new QuotationProductCrt();

                    //var res = await quotationCrt.insertQuotation(Quotation(

                    //Quotation quotation = new Quotation(
                    //upd createDate: DateTime.now().toString(),
                    updQuotation.total = totalController.text;
                    updQuotation.subTotal = subTotalController.text;
                    updQuotation.dateQuotation = dateController.text;
                    // company: ,
                    //updQuotation.currencyId = selectedCurrency.codCurrency;
                    // updQuotation.dateQuotation: dateController.text,
                    //updQuotation.deliveryTimeId = selectedDeliveryTimes.id;
                    //updQuotation.deliveryTypeId = selectedDeliveryType.id;
                    updQuotation.lgv = lgvController.text;
                    updQuotation.nameBusiness = socialController.text;
                    // createUser: ,
                    updQuotation.observation = observationController.text;
                    //updQuotation.payId =
                    //  selectedPayConditions.codPayCondition;
                    updQuotation.state = '1';
                    updQuotation.updateflg = 0;

                    try {
                      setState(() => loader = true);
                      print(updQuotation);
                      print(ListItemsEdit.listItems);

                      if (await quotationCrt.updateQuotation(updQuotation) >
                          0) {
                        await quotationproductCrt
                            .deleteQuotationProductsperCode(
                                updQuotation.id.toString());

                        int corre = 1;
                        await Future.forEach(ListItemsEdit.listItems,
                            (QuotationProduct element) async {
                          element.quotation_id = updQuotation.id;
                          element.id =
                              updQuotation.id.toString() + corre.toString();

                          await quotationproductCrt
                              .insertQuotationProduct(element);

                          corre = corre + 1;
                        });

                        // _createPDF(cust, ListItemsEdit.listItems, updQuotation,
                        //     updSalesperson);

                        /********************** Generamos PDF ******************/

                        List<PayCondition> payConditions2 = payConditions
                            .where(
                                (o) => o.codPayCondition == updQuotation.payId)
                            .toList();

                        List<DeliveryTime> deliveryTimes2 = deliveryTimes
                            .where((o) => o.id == updQuotation.deliveryTimeId)
                            .toList();

                        List<DeliveryType> deliveryTypes2 = deliveryTypes
                            .where((o) => o.id == updQuotation.deliveryTypeId)
                            .toList();

                        List<Currency> currency2 = currency
                            .where(
                                (o) => o.codCurrency == updQuotation.currencyId)
                            .toList();
                        final directory = await getExternalStorageDirectory();

                        CompanyCtr comp = new CompanyCtr();
                        List<Company> arrCompany =
                            await comp.getCompany(_CodCompany);

                        ReportDataQuotation dataquotation =
                            new ReportDataQuotation(
                                path: directory!.path,
                                codCompany: _CodCompany,
                                quotationfin: updQuotation,
                                listprodquotationfin: ListItemsEdit.listItems,
                                customer: cust,
                                salesperson: updSalesperson,
                                paycondition: payConditions2[0]
                                    .strDescription
                                    .toString(),
                                deliverytype:
                                    deliveryTypes2[0].description.toString(),
                                deliverytime:
                                    deliveryTimes2[0].description.toString(),
                                currency: currency2[0].codCurrency!,
                                currencyName: currency2[0].strName!,
                                company: arrCompany[0],
                                cur: currency2[0]);

                        Reports reports = new Reports();
                        reports.reportsEnableds(dataquotation);

                        // if (_CodCompany == "1") {
                        //   reports.reportsQuotation_refermat(dataquotation);
                        // } else {
                        //   reports.reportsQuotation(dataquotation);
                        // }
                      }

                      setState(() {
                        loader = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(msg_confirm);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'listQuotas', (route) => false,
                          arguments: cust);
                    } catch (err) {
                      setState(() {
                        loader = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err.toString())));
                    }
                  }
                },
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

  Widget normalDropdown(List<dynamic> items, int initialvalue) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        isExpanded: true,
        value: _payed,
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
        onChanged: (value) {
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

  Widget popup() {
    print(" ------------------- entrando ------------------ ");
    print(ListItemsEdit.listmoneda);
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
            // ListItemsEdit.listmoneda.clear();
            // Cmoneda m = new Cmoneda(codmoneda: selectedCurrency.codCurrency!);
            // ListItemsEdit.listmoneda.add(m);
            // _displayTextInputDialog;
            showDialog(
                context: context,
                builder: (context) {
                  return openDialogue();
                }).then((value) {
              if (value != null) {
                double subTotal = 0;
                ListItemsEdit.listItems.forEach((element) {
                  subTotal += double.tryParse(element.sub_total)!;
                });
                setState(() {
                  subTotalController.text = subTotal.toStringAsFixed(2);
                  ;
                  lgvController.text = (subTotal *
                          double.parse(datacompany.numImpuesto.toString()))
                      .toStringAsFixed(2);
                  ;
                  totalController.text = (subTotal +
                          (subTotal *
                              double.parse(datacompany.numImpuesto.toString())))
                      .toStringAsFixed(2);
                  ;
                });
              }

              if (ListItemsEdit.listItems.length > 0) {
                _bloquearCurrency = 1;
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
    return ProductEditForm();
  }

  Widget openDialogueEdit() {
    return ProductEditEditForm();
  }

  Future<void> _createPDF(
      Customer cust,
      List<QuotationProduct> updQuotationProducts,
      Quotation updQuotation,
      String updSalesperson) async {
    List<PayCondition> payConditions2 = payConditions
        .where((o) => o.codPayCondition == updQuotation.payId)
        .toList();

    List<DeliveryTime> deliveryTimes2 = deliveryTimes
        .where((o) => o.id == updQuotation.deliveryTimeId)
        .toList();

    List<DeliveryType> deliveryTypes2 = deliveryTypes
        .where((o) => o.id == updQuotation.deliveryTypeId)
        .toList();

    List<Currency> currency2 = currency
        .where((o) => o.codCurrency == updQuotation.currencyId)
        .toList();

    final controller = new MoneyMaskedTextController(
        decimalSeparator: '.', thousandSeparator: ',');

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

    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 10;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

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

//Measures the width of the text to place it in the correct location
    // Size textSize = subHeadingFont.measureString(currentDate);
    // Offset textPosition = Offset(
    //     graphics.clientSize.width - textSize.width - 10, result.bounds.top);

//Draws the date by using drawString method
    // graphics.drawString(currentDate, subHeadingFont,
    //     brush: element.brush,
    //     bounds: Offset(graphics.clientSize.width - textSize.width - 10,
    //             result.bounds.top) &
    //         Size(textSize.width + 2, 20));

    // page.graphics.drawImage(
    //     PdfBitmap(io2.File('$tempDirectory/user.png').readAsBytesSync()),
    //     Rect.fromLTWH(8, 215, 16, 16));

    // graphics.drawString(currentDate, subHeadingFont,
    //     brush: element.brush,
    //     bounds: Offset(graphics.clientSize.width - textSize.width - 10,
    //             result.bounds.top) &
    //         Size(textSize.width + 2, 20));

    // String icono_company = "";
    // if (_CodCompany == "1") {
    //   icono_company = 'refermat.png';
    // }

    // if (_CodCompany == "2") {
    //   icono_company = 'suminox.png';
    // }

    //print(icono_company + "------------------------------------");
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

    // if (_CodCompany == "2") {
    //   page.graphics.drawImage(
    //       PdfBitmap(io2.File('$tempDirectory/suminox.png').readAsBytesSync()),
    //       Rect.fromLTWH(10, -27, 120, 120));
    // }

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
        text: updQuotation.dateQuotation.toString(), font: timesRomanDet);
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
        PdfTextElement(text: updQuotation.id.toString(), font: timesRomanDet);
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
        text: cust.numRucCustomer.toString(), font: timesRomanDet);
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
        PdfTextElement(text: cust.strName.toString(), font: timesRomanDet);
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

    element = PdfTextElement(text: updSalesperson, font: timesRomanDet);
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
        text: payConditions2[0].strDescription.toString(), font: timesRomanDet);
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
        text: deliveryTypes2[0].description.toString(), font: timesRomanDet);
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
        text: deliveryTimes2[0].description.toString(), font: timesRomanDet);
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

    updQuotationProducts.forEach((quotprod) {
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
                  : double.parse(quotproduct.unity_price.toString()))
              .toString();
      row.cells[10].value = quotproduct.sub_total;

      contador = contador + 1;
    });

    // row = grid.rows.add();
    // row.cells[0].value = '2';
    // row.cells[1].value = '0202301 - 120';
    // row.cells[2].value = 'PLATINO A-36 2.0 X 120mm x 2400';
    // row.cells[3].value = 'PLATINO';
    // row.cells[4].value = '2';
    // row.cells[5].value = '400';
    // row.cells[6].value = '400';
    // row.cells[7].value = '5';
    // row.cells[8].value = '12.88';
    // row.cells[9].value = "9.00";
    // row.cells[10].value = "115.92";
    // row.cells[0].value = 'LJ-0192';
    // row.cells[1].value = 'Long-Sleeve Logo Jersey,M';
    // row.cells[2].value = '\$49.99';
    // row.cells[3].value = '3';
    // row.cells[4].value = '\$149.97';

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

    final icon_mod = currency2[0].codCurrency == 1 ? "\$" : "S/";

    // print(_quotat_final.total.toString());

    controller.updateValue(double.parse(updQuotation.subTotal.toString()));
    String subtotal = controller.numberValue.toString();

    controller.updateValue(double.parse(updQuotation.lgv.toString()));
    String igv = controller.numberValue.toString();

    controller.updateValue(double.parse(updQuotation.total.toString()));
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
        'Observaciones :  ${updQuotation.observation.toString()}',
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

    final moneda_mod =
        currency2[0].codCurrency == 1 ? "dolares americanos" : "soles peruanos";

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
        updQuotation.id == null ? 'temporal_name' : updQuotation.id;

//Create an empty file to write PDF data
    final file = io2.File('$path/$name_pdf.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/$name_pdf.pdf');
  }

  void _moveToScreen2(BuildContext context) {
    Navigator.pushReplacementNamed(context, "listQuotas");
  }
}
