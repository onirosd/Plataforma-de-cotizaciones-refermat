import 'dart:convert';

import 'package:appcotizaciones/src/models/complementsCustoGalle.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:appcotizaciones/src/models/galleryDetailSubtipos.dart';
import 'package:appcotizaciones/src/models/galleryExport.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'package:appcotizaciones/src/config/variables.dart';
import 'package:appcotizaciones/src/helpers/database_helper.dart';

class ComplementsCustomerGalleries {
  DatabaseHelper con = new DatabaseHelper();

  var url_complements =
      DIR_URL + "Appstock/controller/services/listarCustomerGallery.php";
  var url_upload_galleries =
      DIR_URL + "Appstock/controller/services/insertarGalleries.php";

  Future<List<ComplementsCustoGalle>> uploadComplementsCustomerGalleries(
      int codempresa) async {
    // ResponseError error =
    //     new ResponseError(description: "", error: 0, success: 0);

    send_empresa reqe = new send_empresa(codEmpresa: codempresa);
    List data = [];

    try {
      final response = await http.post(
        Uri.parse(url_complements),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reqe),
      );

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        //  print(data);
      }
    } catch (e) {}

    return data.map((job) => new ComplementsCustoGalle.fromMap(job)).toList();
  }

  Future<ResponseError> batchInsertComplementscustogalle(
      List<ComplementsCustoGalle> complements) async {
    var dbconn = await con.db;
    Batch batch = dbconn.batch();
    int estado = 0;
    ResponseError responseerror =
        new ResponseError(description: '', error: 1, success: 0);

    List<Customer>? listCustomer = complements[0].customer;
    List<Gallery>? listGallery = complements[0].gallery;
    List<GalleryDetail>? listGalleryDetail = complements[0].galleryDetail;
    List<GalleryDetailSubtipos>? listGalleryDetailSubtipos =
        complements[0].galleriesdetailsubtipos;

    if (listCustomer.length > 0) {
      listCustomer.forEach((customer) {
        batch.insert('Customer', customer.toMap());
      });
      // queryDelet = queryDelet + " DELETE FROM Company;  ";
    }

    if (listGallery.length > 0) {
      // batch.delete('QuotationProducts'); //('Company', company.toMap());
      listGallery.forEach((gallery) {
        batch.insert('Gallery', gallery.toMap());
      });
      // queryDelet = queryDelet + " DELETE FROM Company;  ";
    }

    if (listGalleryDetail.length > 0) {
      // batch.delete('Billing'); //('Company', company.toMap());
      listGalleryDetail.forEach((gallerydetail) {
        batch.insert('GalleryDetail', gallerydetail.toMap());
      });
    }

    if (listGalleryDetailSubtipos.length > 0) {
      // batch.delete('Billing'); //('Company', company.toMap());
      listGalleryDetailSubtipos.forEach((gallerydetailsubtipos) {
        batch.insert('GalleryDetailSubtipos', gallerydetailsubtipos.toMap());
      });
    }
    // queryDelet = queryDelet + " DELETE FROM Company;  ";

    try {
      // await deleteDataComplements(queryDelet);
      await batch.commit(continueOnError: false);
      responseerror.error = 0;
      responseerror.success = 1;
      responseerror.description =
          'Carga Clientes,Imagenes : Tablas de Clientes y Galerias Sincronizadas con Exito';
    } catch (e) {
      estado = 0;

      responseerror.description = 'Carga Clientes,Imagenes : ' + e.toString();

      print(e.toString());
    }

    return responseerror;
  }

  Future<ResponseError> uploadGalleriesExport(
      List<GalleryExport> listExport) async {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String jsondata =
        encoder.convert(listExport).toString(); //json.encode(listExport);

    // print(jsondata);

    ResponseError error =
        new ResponseError(description: "", error: 0, success: 0);
    final response = await http.post(
      Uri.parse(url_upload_galleries),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsondata,
    );

    //print(response.statusCode);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //final respon = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      String description = map['description'];
      int er = map['error'];
      int cant = map['cant'];

      if (er == 1) {
        error.error = cant > 0 ? 2 : 1;
        error.description = description;
      } else {
        error.description = description;
      }

      //print(respon["error"]);
      //return Customer.fromJson(jsonDecode(response.body));
    } else {
      error.description = response.body.toString();
    }

    return error;
  }
}

class send_empresa {
  int codEmpresa;

  send_empresa({
    required this.codEmpresa,
  });

  send_empresa copyWith({
    int? codEmpresa,
  }) {
    return send_empresa(
      codEmpresa: codEmpresa ?? this.codEmpresa,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'codEmpresa': codEmpresa});

    return result;
  }

  factory send_empresa.fromMap(Map<String, dynamic> map) {
    return send_empresa(
      codEmpresa: map['codEmpresa']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory send_empresa.fromJson(String source) =>
      send_empresa.fromMap(json.decode(source));

  @override
  String toString() => 'send_empresa(codEmpresa: $codEmpresa)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is send_empresa && other.codEmpresa == codEmpresa;
  }

  @override
  int get hashCode => codEmpresa.hashCode;
}
