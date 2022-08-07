import 'dart:ffi';
import 'dart:math';

import 'package:appcotizaciones/src/models/product_stock.dart';
import 'package:appcotizaciones/src/models/sub_tipo_multimedia.dart';
import 'package:appcotizaciones/src/models/tialmacen.dart';
import 'package:appcotizaciones/src/modelscrud/productStock.dart';
import 'package:appcotizaciones/src/modelscrud/product_crt.dart';
import 'package:appcotizaciones/src/modelscrud/subtipomultimedia_crt.dart';
import 'package:appcotizaciones/src/modelscrud/tilalmacen_crt.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/controller/listController.dart';
import 'package:appcotizaciones/src/constants/listsubtipomultimedia.dart';
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

class Multimediaaddsubt extends StatefulWidget {
  const Multimediaaddsubt({Key? key}) : super(key: key);

  @override
  _MultimediaaddsubtState createState() => _MultimediaaddsubtState();
}

class _MultimediaaddsubtState extends State<Multimediaaddsubt> {
  bool loading = true, loader = false;

  // CONTROLLERS
  TextEditingController comentariocontroller = TextEditingController();
  TextEditingController subtipocontrolle = TextEditingController();

  List<SubTipoMultimedia> subtipo1_list = <SubTipoMultimedia>[];
  int _sub_tipo_multimedia = 0;

  static String _displayStringForOption(ProductStock option) =>
      option.strNameProduct;

  String _lcod_tiproducts = "";
  String _lcod_list = "";
  String _lcod_tialmacen = "";
  String _lcod_currency = "";

  @override
  void initState() {
    print(ListItems.sel_tipomultimedia.toString() + " ---> llega");
    // TODO: implement initState
    super.initState();
    getsubTipoMultimedia();

    setState(() {
      // _sub_tipo_multimedia = ListItems.sel_tipomultimedia;
      comentariocontroller.text =
          ListItems.sel_subtipomultimedia.comentario.toString();
    });
    print(ListItems.sel_subtipomultimedia);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getsubTipoMultimedia() async {
    SubTipoMultimedia_crt crt = new SubTipoMultimedia_crt();
    int tipo_multimedia = ListItems.sel_tipomultimedia;
    //ProductCtr productcrt = ProductCtr();

    try {
      List<SubTipoMultimedia> ressubtipomult =
          await crt.getsubTipoMultimedia(tipo_multimedia.toString());

      setState(() {
        subtipo1_list = ressubtipomult;
        if (subtipo1_list.length == 0) {
          ListItems.sel_subtipomultimedia.subTipoMultimedia = -9;
          Navigator.pop(context, true);
        }
        _sub_tipo_multimedia =
            ListItems.sel_subtipomultimedia.subTipoMultimedia == 0
                ? subtipo1_list[0].codSubtipomultimedia
                : ListItems.sel_subtipomultimedia.subTipoMultimedia;
        loading = false;
      });
    } catch (err) {
      print(err);
    }
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
                "Elegir Sub Tipo Multimedia",
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
                        space,
                        regularText('Subtipo Almacen'),
                        DropdownButton(
                          value: _sub_tipo_multimedia,
                          isExpanded: true,
                          iconSize: 30.0,
                          onChanged: (newValue) {
                            //print(_lcod_tiproducts + "---------Z");

                            setState(() {
                              _sub_tipo_multimedia = newValue as int;
                              // getProductsStock(_lcod_currency, _lcod_list,
                              //     _selectalmacen, _lcod_tiproducts);
                            });
                            // print(_selectalmacen);
                          },
                          items: subtipo1_list.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location.desSubtipomultimedia),
                              value: location.codSubtipomultimedia,
                            );
                          }).toList(),
                        ),
                        space,
                        regularText('Comentario'),
                        TextFormField(
                          maxLines: 5,
                          controller: comentariocontroller,
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
                                      Text("Guardar"),
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
          ListItems.sel_subtipomultimedia.comentario =
              comentariocontroller.text;

          ListItems.sel_subtipomultimedia.subTipoMultimedia =
              _sub_tipo_multimedia;

          // print(ListItems.sel_subtipomultimedia);

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
}
