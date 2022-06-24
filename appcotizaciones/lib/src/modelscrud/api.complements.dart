import 'dart:convert';

import 'package:appcotizaciones/src/api/api.autentication.dart';
import 'package:appcotizaciones/src/api/api.complements.dart';
import 'package:appcotizaciones/src/models/autentication.dart';
import 'package:appcotizaciones/src/models/bank.dart';
import 'package:appcotizaciones/src/models/billingType.dart';
import 'package:appcotizaciones/src/models/company.dart';
import 'package:appcotizaciones/src/models/complements.dart';
import 'package:appcotizaciones/src/models/currency.dart';
import 'package:appcotizaciones/src/models/delivery_time_model.dart';
import 'package:appcotizaciones/src/models/payCondition.dart';
import 'package:appcotizaciones/src/models/paymentMethod.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/models/synclog.dart';
import 'package:appcotizaciones/src/models/tilist.dart';
import 'package:appcotizaciones/src/models/tiperson.dart';
import 'package:appcotizaciones/src/modelscrud/autentication_crt.dart';
import 'package:appcotizaciones/src/modelscrud/bank_crt.dart';
import 'package:appcotizaciones/src/modelscrud/billingtype.dart';
import 'package:appcotizaciones/src/modelscrud/company_crt.dart';
import 'package:appcotizaciones/src/modelscrud/currency_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryTime_crt.dart';
import 'package:appcotizaciones/src/modelscrud/deliveryType_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paycondition_crt.dart';
import 'package:appcotizaciones/src/modelscrud/paymentmethod_crt.dart';
import 'package:appcotizaciones/src/modelscrud/productStock.dart';
import 'package:appcotizaciones/src/modelscrud/synclog_crt.dart';
import 'package:appcotizaciones/src/modelscrud/tilist_crt.dart';
import 'package:appcotizaciones/src/modelscrud/tiperson_crt.dart';
import 'package:ntp/ntp.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

class ApiComplements {
  //Company? compa;

  //Company? get getCompa => this.compa;

  // set setCompa(Company? compa) => this.compa = compa;

  Future<ResponseError> syncComplementsfromApi(
      int codUser, String seccion) async {
    ComplementsApiProvider api = new ComplementsApiProvider();
    CompanyCtr companyCtr = new CompanyCtr();
    TiListCtr tilistCtr = new TiListCtr();
    TiPersonCtr tipersonCtr = new TiPersonCtr();

    BankCtr bankcrt = new BankCtr();
    PayConditionCtr payconditioncrt = new PayConditionCtr();
    PaymentMethodCtr paymentmethodcrt = new PaymentMethodCtr();
    BillingTypeCtr billingtypecrt = new BillingTypeCtr();
    CurrencyCtr currencycrt = new CurrencyCtr();
    DeliveryTimeCrt deliverytimecrt = new DeliveryTimeCrt();
    DeliveryTypeCtr deliverytypecrt = new DeliveryTypeCtr();

    List<int> devol = [];

    int countCompany = 0;
    int countTilist = 0;
    int countTipersom = 0;
    int countBank = 0;
    int countPayCondition = 0;
    int countPaymetMethod = 0;
    int countBillingType = 0;
    int countCurrency = 0;

    int countDeliveryTime = 0;
    int countDeliveryType = 0;

    String description = "";
    int tablesUpdate = 0;
    int error = 1;
    int success = 0;

    try {
      await api.getAllComplements().then((value) async {
        // if (value[0].company!.length > 0) {
        //   List<Company>? listcompany = value[0].company;

        //   for (Company compa in listcompany!) {
        //     countCompany = await companyCtr.insertCompany(compa) > 0
        //         ? countCompany + 1
        //         : countCompany + 0;
        //   }

        //   description = description +
        //       "Insert Companys : " +
        //       countCompany.toString() +
        //       " , ";
        //   tablesUpdate = tablesUpdate + 1;
        // }

        if (value[0].tilist!.length > 0) {
          List<TiList>? listtilist = value[0].tilist;
          for (TiList list in listtilist!) {
            countTilist = await tilistCtr.insertTiList(list) > 0
                ? countTilist + 1
                : countTilist + 0;
          }

          description = description +
              "Insert Ti_List : " +
              countTilist.toString() +
              " , ";
          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].tiperson!.length > 0) {
          List<TiPerson>? listtiperson = value[0].tiperson;
          for (var tiperson in listtiperson!) {
            countTipersom = await tipersonCtr.insertTiPerson(tiperson) > 0
                ? countTipersom + 1
                : countTipersom + 0;
          }

          description = description +
              "Insert Ti_Person : " +
              countTipersom.toString() +
              " , ";
          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].bank!.length > 0) {
          List<Bank>? listbank = value[0].bank;
          for (var bank in listbank!) {
            countBank = await bankcrt.insertBank(bank) > 0
                ? countBank + 1
                : countBank + 0;
          }

          description =
              description + "Insert Bank : " + countBank.toString() + " , ";
          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].paycondition!.length > 0) {
          List<PayCondition>? listpaycondition = value[0].paycondition;
          for (var paycondition in listpaycondition!) {
            countPayCondition =
                await payconditioncrt.insertPayCondition(paycondition) > 0
                    ? countPayCondition + 1
                    : countPayCondition + 0;
          }

          description = description +
              "Insert PayCondition : " +
              countPayCondition.toString() +
              " , ";
          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].paymentmethod!.length > 0) {
          List<PaymentMethod>? listpaymentmethod = value[0].paymentmethod;
          for (var paymentmethod in listpaymentmethod!) {
            countPaymetMethod =
                await paymentmethodcrt.insertPaymentMethod(paymentmethod) > 0
                    ? countPaymetMethod + 1
                    : countPaymetMethod + 0;
          }

          description = description +
              "Insert PaymentMethod : " +
              countPaymetMethod.toString() +
              " , ";
          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].billingtype!.length > 0) {
          List<BillingType>? listbillingtype = value[0].billingtype;
          for (var billingtype in listbillingtype!) {
            countBillingType =
                await billingtypecrt.insertBillingType(billingtype) > 0
                    ? countBillingType + 1
                    : countBillingType + 0;
          }

          description = description +
              "Insert BillingType : " +
              countBillingType.toString() +
              " , ";

          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].currency!.length > 0) {
          List<Currency>? listcurrency = value[0].currency;
          for (var currency in listcurrency!) {
            countCurrency = await currencycrt.insertCurrency(currency) > 0
                ? countCurrency + 1
                : countCurrency + 0;
          }

          description = description +
              "Insert Currency : " +
              countCurrency.toString() +
              " , ";

          tablesUpdate = tablesUpdate + 1;
        }

        if (value[0].deliverytime!.length > 0) {
          await deliverytimecrt.deleteAllDeliverytime();
          //List<DeliveryTime>? listdeliverytime = value[0].deliverytime;
          for (var deliverytime in value[0].deliverytime!) {
            countDeliveryTime =
                await deliverytimecrt.insertDeliverytime(deliverytime) > 0
                    ? countDeliveryTime + 1
                    : countDeliveryTime + 0;
          }

          description = description +
              "Insert DeliveryTime : " +
              countDeliveryTime.toString() +
              " , ";
        }

        if (value[0].deliverytype!.length > 0) {
          await deliverytypecrt.deleteAllDeliverytype();
          for (var deliverytype in value[0].deliverytype!) {
            countDeliveryType =
                await deliverytypecrt.insertDeliveryType(deliverytype) > 0
                    ? countDeliveryType + 1
                    : countDeliveryType + 0;
          }

          description = description +
              "Insert Deliverytype : " +
              countDeliveryType.toString() +
              " , ";
        }
      });

      error = 0;
      success = 1;
      description = "Carga Complementos  : " +
          tablesUpdate.toString() +
          " Tablas Actualizadas.";

      /* la sincronizacion fue exitosa, entonces guardamos */
      SyncLogCtr crt = new SyncLogCtr();
      await crt.saveLogtoUser(codUser, seccion, "");
    } catch (e) {
      description = e.toString();
      description = "Carga Complementos : error - " + description;
    }

    ResponseError response = new ResponseError(
        description: description, error: error, success: success);

    return response; //.then((value) {
  }

  Future<ResponseError> syncComplementsfromApi2(
      int codUser, String seccion, String company) async {
    ComplementsApiProvider api = new ComplementsApiProvider();
    CompanyCtr companyCtr = new CompanyCtr();
    TiListCtr tilistCtr = new TiListCtr();
    TiPersonCtr tipersonCtr = new TiPersonCtr();

    BankCtr bankcrt = new BankCtr();
    PayConditionCtr payconditioncrt = new PayConditionCtr();
    PaymentMethodCtr paymentmethodcrt = new PaymentMethodCtr();
    BillingTypeCtr billingtypecrt = new BillingTypeCtr();
    CurrencyCtr currencycrt = new CurrencyCtr();
    DeliveryTimeCrt deliverytimecrt = new DeliveryTimeCrt();
    DeliveryTypeCtr deliverytypecrt = new DeliveryTypeCtr();

    List<int> devol = [];

    int countCompany = 0;
    int countTilist = 0;
    int countTipersom = 0;
    int countBank = 0;
    int countPayCondition = 0;
    int countPaymetMethod = 0;
    int countBillingType = 0;
    int countCurrency = 0;

    int countDeliveryTime = 0;
    int countDeliveryType = 0;

    String description = "";
    int tablesUpdate = 0;
    int error = 1;
    int success = 0;

    ResponseError responseerror =
        new ResponseError(description: '', error: 1, success: 0);

    try {
      List<Complements> complements =
          await api.uploadComplements(codUser, company);

      responseerror = await api.batchInsertComplements(complements);

      print(responseerror);
      if (responseerror.success == 1) {
        responseerror.description =
            "Carga Complementos :" + responseerror.description;
      } else {
        responseerror.description =
            "Carga Complementos : error - " + responseerror.description;
      }

      /* la sincronizacion fue exitosa, entonces guardamos */
      SyncLogCtr crt = new SyncLogCtr();
      await crt.saveLogtoUser(codUser, seccion, description);
    } catch (e) {
      responseerror.description =
          "Carga Complementos : error - " + e.toString();
    }

    return responseerror; //.then((value) {
  }
}
