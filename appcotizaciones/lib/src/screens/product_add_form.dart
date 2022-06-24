import 'dart:ffi';
import 'dart:math';

import 'package:appcotizaciones/src/models/product_stock.dart';
import 'package:appcotizaciones/src/models/tialmacen.dart';
import 'package:appcotizaciones/src/modelscrud/productStock.dart';
import 'package:appcotizaciones/src/modelscrud/product_crt.dart';
import 'package:appcotizaciones/src/modelscrud/tilalmacen_crt.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/controller/listController.dart';
import 'package:appcotizaciones/src/constants/listController.dart';
//import 'package:flutter_application_1/db/db_provider.dart';
import 'package:appcotizaciones/src/models/product_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
//import 'package:flutter_application_1/models/product_model.dart';
import 'package:appcotizaciones/src/utils/constants.dart';
import 'package:appcotizaciones/src/utils/size_config.dart';
import 'package:appcotizaciones/src/widgets/widgets.dart';

//import 'package:flutter_application_1/utils/constants.dart';
//import 'package:flutter_application_1/utils/size_config.dart';
//import 'package:flutter_application_1/widgets/widgets.dart';

import '../providers/provider.customer.Quotation.new.dart';

class ProductAddForm extends StatefulWidget {
  const ProductAddForm({Key? key}) : super(key: key);

  @override
  _ProductAddFormState createState() => _ProductAddFormState();
}

class _ProductAddFormState extends State<ProductAddForm> {
  bool loading = true, loader = false;

  // CONTROLLERS
  TextEditingController productController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController diameterController = TextEditingController();
  TextEditingController internoController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController almacenController = TextEditingController();

  TextEditingController precioconigv = TextEditingController();
  TextEditingController totalconigv = TextEditingController();
  TextEditingController empaqueController = TextEditingController();

  double valmin = 0;
  double valmax = 0;
  int _cateoryproducts = 0;

  String _msg_alert_price = "";
  String _msg_alert_empaque = "";

  List<ProductStock> products = <ProductStock>[];
  List<TiAlmacen> tialmacen = <TiAlmacen>[];
  late String _selectalmacen = "1";

  late ProductStock selectedProducts;

  static String _displayStringForOption(ProductStock option) =>
      option.strNameProduct;

  String _lcod_tiproducts = "";
  String _lcod_list = "";
  String _lcod_tialmacen = "";
  String _lcod_currency = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
    getTiAlmacen();
    // print(tialmacen);
    print(ListItems.listalmacen[0]);
    setState(() {
      _selectalmacen = ListItems.listalmacen[0];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getProducts() async {
    ProductStockCtr productStockCtr = ProductStockCtr();
    int codMoneda = ListItems.listmoneda[0].codmoneda;
    //ProductCtr productcrt = ProductCtr();

    try {
      List<ProductStock> resProduct =
          await productStockCtr.getDataProductStock(codMoneda);
      setState(() {
        products = resProduct;
        loading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  Future getTiAlmacen() async {
    TiAlmacen_ctr almacenctr = TiAlmacen_ctr();
    //int codMoneda = ListItems.listmoneda[0].codmoneda;
    //ProductCtr productcrt = ProductCtr();

    try {
      List<TiAlmacen> resAlmacen = await almacenctr.getTiAlmacen();
      setState(() {
        tialmacen = resAlmacen;
        //loading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  void getProductsStock(String codMoneda, String codlista, String codalmacen,
      String codtiproducts) async {
    ProductStockCtr ctr = ProductStockCtr();
    List<ProductStock> productstock = [];
    //int codMoneda = ListItems.listmoneda[0].codmoneda;
    //ProductCtr productcrt = ProductCtr();

    try {
      productstock = await ctr.getDataProductStock2(
          codMoneda, codlista, codalmacen, codtiproducts);
      setState(() {});
    } catch (err) {
      print(err);
    }

    // descriptionController.text = "";
    // unitController.text = "";
    // diameterController.text = "";
    // priceController.text = double.parse("0").toStringAsFixed(2);
    print("codMoneda : " +
        codMoneda +
        " -- " +
        " codlista:" +
        codlista +
        " -- codalmacen:" +
        codalmacen +
        " -- codtiproducts:" +
        codtiproducts);

    ProductStock productstock2 = new ProductStock(
        codProducts: 0,
        strNameProduct: "",
        strNameProductReal: "",
        numUnit: "",
        numDiameter: "",
        numTeoricalWeight: "",
        codCategoryProduct: 0,
        strCategoryProduct: "",
        numPriceMin: "0",
        numPriceMax: "0",
        numStock: "",
        codList: 0,
        codTiAlmacen: 0,
        codCurrency: 0,
        desTiAlmacen: "",
        num_Empaque: 0);

    if (productstock.length == 0) {
      selectedProducts = productstock2;
    } else {
      selectedProducts = productstock[0];
    }

    // selectedProducts = productstock.length > 0 ? productstock[0] : ;
    descriptionController.text = selectedProducts.strNameProductReal;
    unitController.text = selectedProducts.strCategoryProduct;
    diameterController.text = selectedProducts.numDiameter;
    priceController.text =
        double.parse(selectedProducts.numPriceMax.trim()).toStringAsFixed(2);

    _cateoryproducts = selectedProducts.codCategoryProduct;

    weightController.text = '0';
    //selection.numTeoricalWeight;
    subTotalController.text = '0';
    // diameterController.text = '0';
    internoController.text = '0';
    longController.text = '0';
    amountController.text = '0';
    precioconigv.text = '0';
    totalconigv.text = '0';
    empaqueController.text = '';

    valmax = double.parse((double.parse(selectedProducts.numPriceMax) * 0.10 +
            double.parse(selectedProducts.numPriceMax))
        .toStringAsFixed(2));

    valmin = double.parse(
        double.parse(selectedProducts.numPriceMin).toStringAsFixed(2));
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final space = SizedBox(
      height: 8,
    );

    // print(double.parse(ListItems.listIgv[0]));

    double restPrice = 0;

    return AlertDialog(
      insetPadding: EdgeInsets.all(2),
      titlePadding: EdgeInsets.all(2),
      title: Row(
        children: [
          Expanded(
            child: Text(''),
            flex: 1,
          ),
          Expanded(
            // width: double.infinity,
            //right: 0,
            //top: 0,
            flex: 7,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 4,
                width: SizeConfig.heightMultiplier * 4,
                color: Colors.black,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Icon(
                Icons.add,
                size: SizeConfig.textMultiplier * 5,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Agregar Productos",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.textMultiplier * 1.8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
      content: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                height: height - 100,
                width: width - 100,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        regularText('SKU'),
                        Autocomplete<ProductStock>(
                          displayStringForOption: _displayStringForOption,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<ProductStock>.empty();
                            }
                            return products.where((ProductStock option) {
                              return option.strNameProduct
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      textEditingValue.text.toLowerCase());
                            }).where((ProductStock option) =>
                                // ignore: unrelated_type_equality_checks
                                option.codTiAlmacen ==
                                int.parse(_selectalmacen));
                          },
                          onSelected: (ProductStock selection) {
                            print(
                                'You just  selected ${_displayStringForOption(selection)}');
                            setState(() {
                              selectedProducts = selection;
                              descriptionController.text =
                                  selection.strNameProductReal;
                              unitController.text =
                                  selection.strCategoryProduct;
                              diameterController.text = selection.numDiameter;
                              priceController.text =
                                  double.parse(selection.numPriceMax.trim())
                                      .toStringAsFixed(2);

                              _cateoryproducts = selection.codCategoryProduct;
                              empaqueController.text =
                                  selection.num_Empaque.toString();

                              weightController.text = '0';
                              //selection.numTeoricalWeight;
                              subTotalController.text = '0';
                              // diameterController.text = '0';
                              internoController.text = '0';
                              longController.text = '0';
                              amountController.text = '0';
                              precioconigv.text = '0';
                              totalconigv.text = '0';
                              empaqueController.text =
                                  selection.num_Empaque.toString();

                              valmax = double.parse(
                                  (double.parse(selectedProducts.numPriceMax) *
                                              0.10 +
                                          double.parse(
                                              selectedProducts.numPriceMax))
                                      .toStringAsFixed(2));

                              valmin = double.parse(
                                  double.parse(selectedProducts.numPriceMin)
                                      .toStringAsFixed(2));

                              _lcod_tiproducts =
                                  selectedProducts.cod_TiProducts.toString();
                              _lcod_list = selectedProducts.codList.toString();
                              _lcod_tialmacen =
                                  selectedProducts.codTiAlmacen.toString();
                              _lcod_currency =
                                  selectedProducts.codCurrency.toString();

                              /* valmin = double.parse((double.parse(
                                          selectedProducts.numPriceMin) -
                                      double.parse(
                                              selectedProducts.numPriceMin) *
                                          0.10)
                                  .toStringAsFixed(2));*/
                            });

                            print(selection);
                          },
                        ),
                        // greyField(
                        //     controller: skuController,
                        //     validator: (value) => value.isEmpty ? "Field is empty!" : null,
                        // ),
                        space,

                        regularText('Almacen'),
                        DropdownButton(
                          // hint: _selectalmacen == ""
                          //     ? Text('Dropdown')
                          //     : Text(
                          //         "Almacen " + _selectalmacen.toString(),
                          //         style: TextStyle(color: Colors.blue),
                          //       ),
                          value: int.parse(_selectalmacen),
                          isExpanded: true,
                          iconSize: 30.0,
                          onChanged: (newValue) {
                            //print(_lcod_tiproducts + "---------Z");

                            setState(() {
                              _selectalmacen = newValue.toString();
                              getProductsStock(_lcod_currency, _lcod_list,
                                  _selectalmacen, _lcod_tiproducts);
                            });
                            // print(_selectalmacen);
                          },
                          items: tialmacen.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location.strDescription),
                              value: location.codTiAlmacen,
                            );
                          }).toList(),
                        ),
                        space,

                        regularText('Description'),
                        greyField(
                          controller: descriptionController,
                          // validator: (value) => value.isEmpty ? "Field is empty!" : null,
                        ),
                        space,
                        regularText('Unidad'),
                        greyField(
                          controller: unitController,
                          validator: (value) =>
                              value!.isEmpty ? "Field is empty!" : null,
                        ),
                        space,
                        regularText('Diametro'),
                        greyField(
                          controller: diameterController,
                          validator: (value) =>
                              value!.isEmpty ? "Field is empty!" : null,
                        ),
                        space,

                        regularText('Ancho Diamero Interno'),
                        Container(
                          child: _cateoryproducts != 8
                              ? normalField(
                                  controller: internoController,
                                  maxLine: 1,
                                  inputType: TextInputType.number,
                                  validator: (value) => value!.isEmpty
                                      ? "Valor no debe ser vacio  !"
                                      : null,
                                  action: (value) {
                                    _calculamosSubTotal(
                                        selectedProducts.codCategoryProduct,
                                        valmin,
                                        valmax,
                                        ListItems.listIgv[0]);
                                  })
                              : greyField(
                                  controller: internoController,
                                  validator: (value) =>
                                      value!.isEmpty ? "Field is empty!" : null,
                                ),
                        ),

                        space,
                        regularText('Largo'),
                        _cateoryproducts != 8
                            ? normalField(
                                controller: longController,
                                maxLine: 1,
                                inputType: TextInputType.numberWithOptions(),
                                validator: (value) =>
                                    value!.isEmpty || value == '0'
                                        ? "Valor no debe ser vacio o cero !"
                                        : null,
                                action: (value) {
                                  _calculamosSubTotal(
                                      selectedProducts.codCategoryProduct,
                                      valmin,
                                      valmax,
                                      ListItems.listIgv[0]);
                                })
                            : greyField(
                                controller: longController,
                                validator: (value) =>
                                    value!.isEmpty ? "Field is empty!" : null,
                              ),

                        space,

                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: regularText('Cantidad'),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              flex: 2,
                              child: regularText('Empaque'),
                            ),
                          ],
                        ),

                        space,

                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  normalField(
                                      controller: amountController,
                                      maxLine: 1,
                                      inputType:
                                          TextInputType.numberWithOptions(),
                                      validator: (value) => value!.isEmpty ||
                                              value == '0'
                                          ? "Valor no debe ser vacio o cero !"
                                          : null,
                                      action: (value) {
                                        _calculamosSubTotal(
                                            selectedProducts.codCategoryProduct,
                                            valmin,
                                            valmax,
                                            ListItems.listIgv[0]);
                                      }),
                                  Text(
                                    _msg_alert_empaque,
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: greyField(
                                controller: empaqueController,
                                validator: (value) =>
                                    value!.isEmpty ? "Field is empty!" : null,
                              ),
                            ),
                          ],
                        ),

                        // regularText('Cantidad'),

                        space,
                        regularText('Peso Teorico'),
                        greyField(
                          controller: weightController,
                          validator: (value) =>
                              value!.isEmpty ? "Field is empty!" : null,
                        ),
                        space,
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: regularText('Precio'),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 1,
                              child: regularText('Sub Total'),
                            ),
                          ],
                        ),
                        space,
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: normalField(
                                  controller: priceController,
                                  maxLine: 1,
                                  inputType: TextInputType.number,
                                  validator: (value) =>
                                      !(double.parse(value!) >= valmin &&
                                              double.parse(value) <= valmax)
                                          ? "Corrija el monto ingresado !"
                                          : null,
                                  action: (value) {
                                    if (value.toString().trim() == '') {
                                      //print("entrando");
                                      // priceController.text = '0';
                                      value = '0';
                                    }

                                    if (double.parse(value) > valmax) {
                                      _msg_alert_price =
                                          "El precio modificado no debe sobrepasar la cantidad de " +
                                              valmax.toString();
                                    } else {
                                      if (double.parse(value) < valmin) {
                                        _msg_alert_price =
                                            "El precio no debe ser menor a " +
                                                valmin.toString();
                                      } else {
                                        _msg_alert_price = "";
                                      }
                                    }
                                    _calculamosSubTotal(
                                        selectedProducts.codCategoryProduct,
                                        valmin,
                                        valmax,
                                        ListItems.listIgv[0]);
                                    setState(() {});
                                  }),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: normalField(
                                controller: subTotalController,
                                readOnly: true,
                                maxLine: 1,
                                inputType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? "Field is empty!" : null,
                              ),
                            ),
                          ],
                        ),
                        space,
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: regularText('Precio c/IGV'),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 1,
                              child: regularText('Total c/IGV'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: greyField(
                                controller: precioconigv,
                                validator: (value) =>
                                    value!.isEmpty ? "Field is empty!" : null,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 1,
                              child: greyField(
                                controller: totalconigv,
                                validator: (value) =>
                                    value!.isEmpty ? "Field is empty!" : null,
                              ),
                            ),
                          ],
                        ),
                        space,
                        Text(
                          _msg_alert_price,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        space,
                        regularText('Comentario'),
                        TextFormField(
                          maxLines: 5,
                          controller: commentController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            hintText: '',
                            hintStyle: TextStyle(
                              color: Constants.lightGrey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.secondaryColor,
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.secondaryColor,
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.secondaryColor,
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.secondaryColor,
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange,
                                    side: BorderSide(
                                      width: 2.0,
                                      color: Colors.black,
                                    )),
                                onPressed: handleSubmit,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    if (loader)
                                      Center(child: CircularProgressIndicator())
                                    else ...[
                                      Text("Agregar"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.add),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    side: BorderSide(
                                      width: 2.0,
                                      color: Colors.black,
                                    )),
                                onPressed: () => Navigator.pop(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text("Cerrar"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // Icon(Icons.check_circle_rounded),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
    );
  }

  handleSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          loader = true;
        });
        //List<String> split =  selectedProducts.strNameProduct.toString().split("Stock");
        setState(() {
          ListItems.listItems.add(QuotationProduct(
              comment: commentController.text,
              product_id: selectedProducts.codProducts,
              quantity: amountController.text,
              sub_total: subTotalController.text,
              total: '0',
              width_internal_diameter: internoController.text,
              theoretical_weight: weightController.text,
              diameter: diameterController.text,
              long: longController.text,
              create_date: DateTime.now().toString(),
              product_name: selectedProducts
                  .strNameProductReal, //split[0].trim(), //selectedProducts.strNameProduct,
              unity_product: unitController.text,
              unity_price: priceController.text,
              cod_TiProducts: selectedProducts.cod_TiProducts.toString(),
              cod_TiAlmacen: _selectalmacen));
          loader = false;
        });

        Navigator.pop(context, true);
      } catch (err) {
        print(err);
        setState(() {
          loader = false;
        });
      }
    }
  }

  void _calculamosSubTotal(
      int catProd, double minval, double maxval, String igv) {
    //print("entramos");
    double diam = double.parse(diameterController.text.trim() == ''
        ? '0'
        : diameterController.text.trim());
    //double.parse(diametro);
    double anch = double.parse(internoController.text.trim() == ''
        ? '0'
        : internoController.text.trim());
    double larg = double.parse(
        longController.text.trim() == '' ? '0' : longController.text.trim());
    double cantid = double.parse(amountController.text.trim() == ''
        ? '0'
        : amountController.text.trim());
    double peso = 0;
    double price = 0;

    if (cantid % int.parse(empaqueController.text) != 0) {
      setState(() {});
      // amountController.text = 0 as String;
      print("entreamos aqui");
      _msg_alert_empaque = "Error : Cantidad debe ser multiplo del empaque";
      return;
    } else {
      setState(() {});
      _msg_alert_empaque = "";
    }
    //print(cantid % int.parse(empaqueController.text));

    // print(diam);
    // print(larg);
    // print(cantid);
    // print(anch);
    if (catProd == 1) {
      // print("entramos a 1");
      peso = ((diam * diam * 0.595 * (larg + 5) / 100000) -
              (anch * anch * 0.625 * larg / 100000)) *
          cantid *
          1.07;
    }
    if (catProd == 2) {
      peso = (((diam * diam * 0.63 * (larg + 5)) / 100) * cantid) / 1000;
    }
    if (catProd == 3) {
      peso = (diam * anch * larg * 8.55 * cantid) / 1000000;
    }
    if (catProd == 4) {
      peso = diam * diam * 0.23 * ((larg / 1000) + 0.005) / 100 * cantid;
    }
    if (catProd == 5) {
      peso = (diam * diam * 0.83 * larg * cantid) / 100000;
    }
    if (catProd == 6) {
      peso = (diam * anch * larg * 2.93 * cantid) / 1000000;
    }
    if (catProd == 7) {
      peso = (diam * anch * larg * 8.05 * cantid) / 1000000;
    }
    if (catProd == 8) {
      peso = cantid;
    }

    peso = double.parse(peso.toStringAsFixed(2).toString());
    weightController.text = peso.toStringAsFixed(2).toString();

    if (priceController.text.toString().trim() != '') {
      if (double.parse(priceController.text) >= minval &&
          double.parse(priceController.text) <= maxval) {
        price = double.parse(priceController.text);
        double subtotal = price * peso;
        double igv = double.parse(ListItems.listIgv[0]);

        // print("veremos");
        // print(igv);
        totalconigv.text = (subtotal + (subtotal * igv)).toStringAsFixed(2);
        precioconigv.text = (price + (price * igv)).toStringAsFixed(2);
        subTotalController.text = subtotal.toStringAsFixed(2);
      } else {
        // print("entramos");
        subTotalController.text = '0';
      }
    } else {
      subTotalController.text = '0';
    }
  }

  double roundDouble(double value, int places) {
    num mod = pow(value, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
