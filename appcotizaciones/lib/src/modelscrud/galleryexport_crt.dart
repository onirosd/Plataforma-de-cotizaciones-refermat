import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:appcotizaciones/src/models/galleryExport.dart';
//import 'package:appcotizaciones/src/models/Quotation.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/models/quotation_model.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/models/quotationv0.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_crt.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_detail_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotationProduct_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:sqflite/sqflite.dart' as sql;
//import 'package:flutter/material.dart';

class GalleryExport_crt {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<GalleryExport>> getDataGalleryExport_sync(
      int enablepreproc) async {
    // enablepreproc no se utiliza porque no hay edicion en las imagenes, siempre va ser un nuevom registro.

    GalleryCtr crt1 = new GalleryCtr();
    GalleryDetailCtr crt2 = new GalleryDetailCtr();

    List<Gallery> listGallery = await crt1.getGallerySync();
    List<GalleryDetail> listGalleryDetail = [];
    List<GalleryExport> listExport = [];

    if (listGallery.length > 0) {
      for (Gallery gallery in listGallery) {
        listGalleryDetail = await crt2.getGalleryDetailSync(gallery.codGallery);

        listExport.add(new GalleryExport(
            gallery: gallery, galleryDetail: listGalleryDetail));
      }
    }

    return listExport;
  }
}
