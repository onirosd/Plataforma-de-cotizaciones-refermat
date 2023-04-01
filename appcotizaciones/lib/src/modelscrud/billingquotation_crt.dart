import 'package:appcotizaciones/src/helpers/database_helper.dart';
import 'package:appcotizaciones/src/models/querys.dart';
import 'package:appcotizaciones/src/providers/provider.home.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Billingquotation_crt {
  DatabaseHelper con = new DatabaseHelper();

  Future<List<SelectBillingQuotation>> getSelectBillingQuoatation(
      Filtros filtro,
      Map<String, int> tipo_estados,
      Map<String, int> tipo_items2) async {
    var dbCustomer = await con.db;
    String idtipo_doc = tipo_items2[filtro.tipo].toString();
    String idtipo_estado = tipo_estados[filtro.tipo_estado].toString();

    String tipo_doc = "";
    if (idtipo_doc != '0' && idtipo_doc != 'null') {
      tipo_doc = " and b.tipo = $idtipo_doc ";
    }

    String tipo_est = "";
    if (idtipo_estado != '-1' && idtipo_estado != 'null') {
      tipo_est = " and b.numstate = $idtipo_estado ";
    }

    print(tipo_est);
    print(tipo_doc);

    final List<Map<String, dynamic>> maps = await dbCustomer.rawQuery(
        " select * from ( select cast(a.id as text) id, cast('1' as text) tipo, cast(a.customerId as text) codCustomer, cast( DATE(a.dateQuotation) as text ) as fec, cast(a.userId as text) userId, cast(au.strNameUser as text) salesperson, cast( count(c.id) as int ) as prods, case when a.updateflg == -1 and cast(a.state as int) == 1 then 1 else cast(a.state as int) end as numstate, cast(a.total as text) total from quotation a inner join customer b on cast(b.codCustomer as TEXT) = a.customerId inner join QuotationProducts c on a.id = c.quotation_id left join Autentication au on a.userId = au.codUser where a.state != 99 group by a.id, a.customerId, b.numRucCustomer, a.dateQuotation, a.userId, au.strNameUser, cast(a.state as int) union select cast(a.codBillingUniq as text) id, cast('2' as text) tipo, cast(a.codCustomer as text) codCustomer, cast( DATE(a.dteBillingDate) as text ) fec, cast(a.codUser as text) userId, cast(c.strNameUser as text) salesperson, cast(0 as int) prods, case when a.flgSync == -1 and cast(a.flgState as int) == 1 then 1 else cast(a.flgState as int) end as numstate, cast(a.numAmountOperation as text) total from Billing a inner join Customer b on a.codCustomer = b.codCustomer inner join Autentication c on a.codUser = c.codUser ) b where 1 = 1 $tipo_doc $tipo_est order by date(b.fec) desc ");

    return maps.map((c) => SelectBillingQuotation.fromMap(c)).toList();
  }
}
