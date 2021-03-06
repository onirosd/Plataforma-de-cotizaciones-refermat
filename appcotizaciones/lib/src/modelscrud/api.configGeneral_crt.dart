import 'package:appcotizaciones/src/api/api.billing.dart';
import 'package:appcotizaciones/src/api/api.complementsbillquo.dart';
import 'package:appcotizaciones/src/api/api.configgeneral.dart';
import 'package:appcotizaciones/src/api/api.customer.dart';
import 'package:appcotizaciones/src/api/api.productoStock.dart';
import 'package:appcotizaciones/src/api/api.quotation.dart';
import 'package:appcotizaciones/src/models/complementsBillQuo.dart';
import 'package:appcotizaciones/src/models/confgeneral.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/lastAutentication.dart';
import 'package:appcotizaciones/src/models/quotationplusproducst.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/modelscrud/api.complements.dart';
import 'package:appcotizaciones/src/modelscrud/billing_crt.dart';
import 'package:appcotizaciones/src/modelscrud/configGeneral_crt.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
import 'package:appcotizaciones/src/modelscrud/lastAutentication_crud.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_crt.dart';
import 'package:appcotizaciones/src/modelscrud/quotation_product_export.dart';
import 'package:appcotizaciones/src/modelscrud/synclog_crt.dart';
import 'package:appcotizaciones/src/modelscrud/tilalmacen_crt.dart';

class ApiConfigGeneral {
  Future<int> getConfigGeneraluser(int codUser) async {
    ConfigGeneralApiProvider conf = new ConfigGeneralApiProvider();
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    List<int> numbs = [];
    //print(codUser.toString() + "entrando entrando !! ");
    List<ConfGeneral> lista = await conf.getConfigGeneralforUser(codUser);

    print("--- entrando loop veremos---");
    int conteo = await lista.length;
    if (conteo > 0) {
      await crt.deleteAllConfGeneralperUser(codUser);

      for (var i = 0; i < conteo; i++) {
        //await crt.deleteAndInsertConfGeneral(lista[i]);
        numbs.add(await crt.deleteInsertConfGeneralperUser(lista[i]));
      }
    }

    //print("--- Config general veromes ---");
    // print(numbs);

    return numbs.length;
  }

  Future<int> executionsGeneralUserRules(int codUser) async {
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    int saveGeneralConfig = await getConfigGeneraluser(codUser);
    /* Aqui normal copiamos las reglas a la base de datos ,
    pero debemos devolver la confirmacion si esque tenemos reglas en la bd o no,
    fuera de que sincronizo o no. */

    List<ConfGeneral> data = await crt.getConfigGeneralforUser(codUser);
    return data.length;
  }

  Future<ResponseError> executionRuleCleanTables() async {
    int numTablesClean = 0;
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    SyncLogCtr log = new SyncLogCtr();
    ConfGeneral configuracion = new ConfGeneral(
        codconfigGeneral: 0,
        strCodOperation: "",
        strDescription: "",
        flgEnabled: 0,
        pivot1: "",
        pivot2: "",
        pivot3: "",
        codUser: 0,
        flgSync: 0);

    int error = 1;
    int success = 0;
    String description = "";
    ResponseError resp;

    configuracion = await crt.getConfigGeneralforUserforRule("CleanTables");

    /* await crt.getConfigGeneralforUserforRule("CleanTables").then((value) async {
      configuracion = value;
      print(configuracion.toString());
    });
    */

    // obtenemos datos de esta regla siempre en cuando este con valor 1  , osea
    // que el de bd, quiere que se limpie las tablas de este usuario
    try {
      if (configuracion.codconfigGeneral > 0) {
        numTablesClean = numTablesClean + await log.deleteAlllogs();
        description = "Limpieza General : Se limpiaron :" +
            numTablesClean.toString() +
            " Tablas";

        int error = 0;
        int success = 1;
      } else {
        description = "Limpieza General : Limpieza de tabla no programada. ";
        int error = 0;
        int success = 1;
      }
    } catch (e) {
      description = e.toString();
      description = "Limpieza General : error -  " + description;
    }

    // print(numTablesClean.toString());

    return new ResponseError(
        description: description, error: error, success: success);
  }

  Future<ResponseError> executionRuleLoadComplements(
      int codUser, int forzar, String company) async {
    //int numTablesClean = 0;
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    ApiComplements com = new ApiComplements();
    ResponseError resp;
    ConfGeneral configuracion;
    //SyncLogCtr log = new SyncLogCtr();
    //if (forzar == 0) {
    configuracion = await crt.getConfigGeneralforUserforRule("LoadComplements");

    // obtenemos datos de esta regla siempre en cuando este con valor 1  , osea
    // que el de bd, quiere que se limpie las tablas de este usuario

    if (configuracion.codconfigGeneral > 0 || forzar == 1) {
      //numTablesClean = numTablesClean + await log.deleteAlllogs();
      print("llegamos aqui");
      resp = await com.syncComplementsfromApi2(
          codUser, 'init-Complementos', company);
    } else {
      resp = new ResponseError(
          description:
              "Carga Complementos : No tenemos sincronizaciones pendientes.",
          error: 0,
          success: 1);
    }

    SyncLogCtr log = new SyncLogCtr();
    await log.saveLogtoUser(codUser, 'UploadClients', resp.description);

    print(resp);

    return resp;
  }

  Future<ResponseError> executionRuleUploadClients(int codUser) async {
    String description = "";
    int error = 1;
    int success = 0;
    ResponseError resp =
        new ResponseError(description: "", error: 0, success: 1);

    CustomerApiProvider api_customer = new CustomerApiProvider();
    CustomerCtr crt_customer = new CustomerCtr();

    ConfigGeneralCtr crt = ConfigGeneralCtr();

    ConfGeneral confiini =
        await crt.getConfigGeneralforUserforRule("LoadCustomer");

    if (confiini.codconfigGeneral > 0) {
      final customerData = await crt_customer.getCustomernoSincronice();
      resp = await api_customer.uploadCustomers(customerData);

      if (resp.error == 2) {
        for (var customer in customerData) {
          customer.asyncFlag = 1;
          await crt_customer.updateCustomerOnebyOne(customer);
        }
      }

      SyncLogCtr crt = new SyncLogCtr();
      await crt.saveLogtoUser(codUser, 'UploadClients', resp.description);
    }

    return resp;
  }

  Future<ResponseError> executionRuleUploadQuotation(int codUser) async {
    String description = "";
    int error = 1;
    int success = 0;
    ResponseError resp =
        new ResponseError(description: "", error: 0, success: 1);
    ConfigGeneralCtr crt = ConfigGeneralCtr();

    ConfGeneral confiini =
        await crt.getConfigGeneralforUserforRule("EnabledPreProc");
    int enablepreproc = confiini.codconfigGeneral > 0 ? 1 : 0;

    QuotationApiProvider api_quotation = new QuotationApiProvider();
    QuotationProductExport crt_quotationexport = new QuotationProductExport();
    QuotationCrt crt_quotation = new QuotationCrt();
    //CustomerCtr crt_customer = new CustomerCtr();

    List<QuotationProductsExport> listquotationsdata =
        await crt_quotationexport.getDataQuotationProdExp(enablepreproc);
    //print(listquotationsdata);

    resp =
        await api_quotation.uploadQuotationProductsExport(listquotationsdata);

    if (resp.error == 2) {
      for (var list in listquotationsdata) {
        list.quotat.state = "2";
        print(await crt_quotation.updateQuotation(list.quotat));
      }
    }

    SyncLogCtr crt_sync = new SyncLogCtr();
    await crt_sync.saveLogtoUser(codUser, 'UploadQuotation', resp.description);

    return resp;
  }

  Future<ResponseError> executionRuleUploadBilling(int codUser) async {
    String description = "";
    int error = 1;
    int success = 0;
    ResponseError resp;
    ConfigGeneralCtr crt = ConfigGeneralCtr();

    ConfGeneral confiini =
        await crt.getConfigGeneralforUserforRule("EnabledPreProc");
    int enablepreproc = confiini.codconfigGeneral > 0 ? 1 : 0;

    BillingApiProvider api_customer = new BillingApiProvider();
    BillingCrt crt_billing = new BillingCrt();
    //CustomerCtr crt_customer = new CustomerCtr();

    final billingsData = await crt_billing.getBillingsSincronice(enablepreproc);
    resp = await api_customer.uploadBillings(billingsData);

    if (resp.error == 2) {
      for (var billing in billingsData) {
        billing.flgSync = 1;
        billing.flgState = 2;

        print(billing);
        await crt_billing.updateBilling(billing);
      }
    }

    SyncLogCtr crt_long = new SyncLogCtr();
    await crt_long.saveLogtoUser(codUser, 'UploadBillings', resp.description);

    return resp;
  }

  Future<ResponseError> executionRuleUploadStockProduct(
      int codUser, int list, String company) async {
    String description = "";
    int error = 1;
    int success = 0;
    int respuesta = 0;
    ResponseError resp =
        new ResponseError(description: "", error: 0, success: 1);
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    TiAlmacen_ctr crt_almacen = TiAlmacen_ctr();

    ConfGeneral confiini =
        await crt.getConfigGeneralforUserforRule("LoadSyncStock");

    if (confiini.codconfigGeneral > 0) {
      StockProductApiProvider api_stockproduct = new StockProductApiProvider();
      BillingCrt crt_billing = new BillingCrt();

      // Update data stock
      await api_stockproduct.uploadProductsStock(list, company);

      await crt_almacen.insertTiAlmacen();

      SyncLogCtr log = new SyncLogCtr();
      await log.saveLogtoUser(codUser, 'UploadBillings', resp.description);
    }

    return resp;
  }

  Future<ResponseError> executionRuleUploadSyncQuoBill(
      int codUser, String position) async {
    String description = "";
    int error = 1;
    int success = 0;
    int respuesta = 0;
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    ResponseError resp =
        new ResponseError(description: "", error: 0, success: 1);

    ConfGeneral confiini =
        await crt.getConfigGeneralforUserforRule("LoadQuoBills");

    if (confiini.codconfigGeneral > 0) {
      ConfGeneral dayssync =
          await crt.getConfigGeneralforUserforRule("DaysSync");
      String bgn = dayssync.pivot2 == null ? '' : dayssync.pivot2;
      String end = dayssync.pivot3 == null ? '' : dayssync.pivot3;

      ComplementsQuoBillApiProvider api_stockproduct =
          new ComplementsQuoBillApiProvider();

      List<ComplementsBillQuo> list =
          /* Traemos las cotizaciones y recibos de la nube.*/
          await api_stockproduct.uploadComplements(codUser, bgn, end, position);
      /* Solo eliminamos de la BD , aquellos registros que no estan en estado 0 o 1, ya que estos todavia no estan sincronizados en 
         la nube . */
      await crt.deleteBillandQuotationwithoutdatanotfinish();
      /* Insertamos las cotizaciones y recibos al celular. */
      ResponseError responseError =
          await api_stockproduct.batchInsertComplements(list);

      SyncLogCtr log = new SyncLogCtr();
      await log.saveLogtoUser(
          codUser, 'SyncQuotationBillings', resp.description);
    } else {
      resp.description =
          "Recibos y Cotizaciones : Sin sincronizaci??n pendiente.";
    }

    return resp;
  }

  Future<ResponseError> executionRuleLoadClients(
      int codUser, int codempresa, int forzar) async {
    //int numTablesClean = 0;
    CustomerApiProvider api = new CustomerApiProvider();
    ConfigGeneralCtr crt = ConfigGeneralCtr();
    CustomerCtr cust = new CustomerCtr();
    int countCustomer = 0;
    String description = "";
    int error = 1;
    int success = 0;
    ResponseError resp;

    int validateInsert = 0;

    ConfGeneral configuracion =
        await crt.getConfigGeneralforUserforRule("LoadCustomer");

    if (configuracion.codconfigGeneral > 0 || forzar == 1) {
      // try {
      List<Customer> customers = await api.uploadAllCustomers(codempresa);
      if (customers.length > 0) {
        cust.deleteAllCustomer();
        validateInsert = await cust.batchInsertCustomers(customers);
      }

      if (validateInsert > 0) {
        /*
        await api.getAllCustomer().then((value) async {
          if (value.length > 0) {
            await cust.deleteAllCustomer();
          }

          for (Customer customer in value) {
            //cust.createCustomer(customer);

            countCustomer = await cust.createCustomer(customer) > 0
                ? countCustomer + 1
                : countCustomer + 0;
          }
        });   
       */
        error = 0;
        success = 1;
        description = "Carga Clientes : Clientes sincronizados con exito. ";
      } else {
        // description = e.toString();
        description =
            "Carga Clientes : Se tuvo errores en la carga de clientes ";
      }
    } else {
      // resp = new ResponseError(
      description = "Carga Clientes : No tenemos sincronizaciones pendientes.";
      error = 0;
      success = 1;
    }

    SyncLogCtr log = new SyncLogCtr();
    await log.saveLogtoUser(codUser, 'UploadClients', description);

    resp = new ResponseError(
        description: description, error: error, success: success);

    return resp;
  }

  cleanUpdatePrincipaltables(int codUser1) async {
    LastAutenticationCrt crt = LastAutenticationCrt();
    ConfigGeneralCtr crt1 = ConfigGeneralCtr();

    List<LastAutentication> list = await crt.getLastAutentication(codUser1);
    if (list.length == 0) {
      LastAutentication lastauth =
          new LastAutentication(codUser: codUser1, lastDate: '');

      crt1.batchCleanPrincipalTables();
      crt1.deleteBillandQuotationwithoutdatanotfinish();

      crt.insLastAutentication(lastauth);
    }
  }
}
