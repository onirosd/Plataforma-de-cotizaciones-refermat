import 'package:appcotizaciones/src/models/galleriespluscustomer.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Gallery.new.dart';
import 'package:flutter/material.dart';

class CustomerGalleryEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final datagalleriescustomer =
        ModalRoute.of(context)!.settings.arguments as GalleriesplusCustomer;

    return Center(
        child: CustomerGalleryNew(
      dataedit: datagalleriescustomer,
    ));
  }
}
