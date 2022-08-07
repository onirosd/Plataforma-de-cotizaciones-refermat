import 'package:appcotizaciones/src/models/galleriespluscustomer.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Billing.confirm.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Billing.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Billing.edit.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Billing.new.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Billing.show.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Gallery.edit.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Gallery.new.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Quotation.confirm.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Quotation.copy.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Quotation.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Quotation.edit.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Quotation.new.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Quotation.show.dart';
import 'package:appcotizaciones/src/providers/provider.customer.Gallery.dart';
// import 'package:appcotizaciones/src/providers/provider.customer.gallery.dart';
import 'package:appcotizaciones/src/providers/provider.customer.new.dart';
import 'package:appcotizaciones/src/providers/provider.home.dart';
import 'package:appcotizaciones/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
/*
Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'Alert': (BuildContext context) => AlertPage(),
    'Avatar': (BuildContext context) => AvatarPage(),
    'Card': (BuildContext context) => CardPages(),
    'Inputs': (BuildContext context) => InputPage(),
  };
}*/

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'home': (BuildContext context) => ProviderHome(),
    'login': (BuildContext context) => LoginScreen(),
    'customerNew': (BuildContext context) => ProviderCustomerNew(),
    'listQuotas': (BuildContext context) => ProviderCustomerQuotation(),
    'listBilling': (BuildContext context) => ProviderCustomerBilling(),
    'QuotationNew': (BuildContext context) => CustomerQuotationNew(),
    'QuotationEdit': (BuildContext context) => CustomerQuotationEdit(),
    'QuotationCopy': (BuildContext context) => CustomerQuotationCopy(),
    'QuotationShow': (BuildContext context) => CustomerQuotationShow(),
    'BillingNew': (BuildContext context) => CustomerBillingNew(),
    'BillingNewConfirm': (BuildContext context) => CustomerBillingConfirm(),
    'QuotationNewConfirm': (BuildContext context) => CustomerQuotationConfirm(),
    'BillingShow': (BuildContext context) => CustomerBillingShow(),
    'BillingEdit': (BuildContext context) => CustomerBillingEdit(),
    // 'Gallery': (BuildContext context) => Providercustomergallery2(),
    'Gallery_customer': (BuildContext context) => providercustomerGallery(),
    'Gallery_new_customer': (BuildContext context) =>
        CustomerGalleryNew(dataedit: new GalleriesplusCustomer()),
    'CustomerGalleryEdit': (BuildContext context) => CustomerGalleryEdit(),
  };
}

// CustomerQuotationConfirm