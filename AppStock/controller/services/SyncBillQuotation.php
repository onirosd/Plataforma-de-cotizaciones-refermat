<?php

include '../../config/config.php';
//echo BASE_URL.'controller/functions/CustomerDb.php';

//require_once(__DIR__.'/controller/functions/CustomerDb.php');
//include $_SERVER['DOCUMENT_ROOT']
//include BASE_URL.'controller/functions/CustomerDb.php';
//include '../functions/CustomerDb.php';
//require_once ( '../functions/CustomerDb.php');
//require_once ( 'config/connections/sqlconnect.php');
//include '../functions/CustomerDb.php';
require '../../config/connections/sqlconnect.php';

 $errordescription = '';
 $code_error  = 1;
 $json_params = file_get_contents("php://input");
 $num_inserts = 0;


function isValidJSON($str) {
    $valid = false;
    json_decode($str);
    if (json_last_error() == 0) {
        $valid  = true;
    }

    return $valid;
   // return json_last_error() == JSON_ERROR_NONE;
 }

 

 if(!$constatus){
    $errordescription = 'No se tiene conexion a la BD der servicio.';
    $code_error = 0;
 }

 if(!isValidJSON($json_params) || strlen($json_params) == 0){
    $errordescription = 'Error al enviar los registros al servidor.';
    $code_error = 0;
}

if($code_error == 0){
    echo json_encode(['error' => $code_error , 'description' => $errordescription ,  'cant'=> 0]);
    return false;
}


$decoded_params = (array) json_decode(json_decode($json_params));
$codUser        = $decoded_params['codUser'];
$bgn            = $decoded_params['bgn'];
$end            = $decoded_params['end'];
$position       = $decoded_params['position'];
$valposition    = rtrim(ltrim($position))  != 'VENDEDOR' ? 1 :0;


$sql_quotation = "
      
  
    select
    convert(varchar(100), cod_Quotation) id,
    convert(int, cod_Currency) currencyId,
    convert(int, cod_PayCondition) payId,
    convert(int, cod_DeliveryType) deliveryTypeId,
    convert(int, cod_DeliveryTime) deliveryTimeId,
    convert(varchar(100), cod_Customer) customerId,
    convert(int, cod_User) userId,
    convert(varchar(100),dte_DateQuotation, 121) dateQuotation,
    convert(varchar(100),str_NameBusiness) nameBusiness,
    convert(varchar(max),str_Observation) observation,
    convert(varchar(100),num_SubTotal) subTotal,
    convert(varchar(100),num_Total) total,
    convert(varchar(100),num_Igv) lgv,
    convert(varchar(100),dte_CreateDate, 121) createDate,
    convert(varchar(100),str_CreateUser) createUser,
    convert(varchar(100),dte_UpdateDate, 121) updateDate,
    convert(varchar(100),str_UpdateUser) updateUser,
    convert(varchar(100),flg_State) state,
    convert(varchar(100),cod_QuotationParents) quotationParents,
    convert(int,cod_Company) company,
    convert(int,flg_update) updateflg
    from quotation q where
    ( q.dte_CreateDate between '".$bgn."' and '".$end."' )


   ";

   if($valposition != 1){

      $sql_quotation = $sql_quotation . "   ". "   and   
      q.cod_User = ".$codUser;

   }

   $sql_quotationProducts = "

   select
   convert(varchar(100),qp.Cod_Quotation_Products) id,
   convert(varchar(100),qp.cod_Quotation) quotation_id,
   convert(int,qp.cod_Products) product_id,
   convert(varchar(100),qp.dte_CreateDate, 121) create_date,
   convert(varchar(100),qp.str_CreateUser) create_user,
   convert(varchar(100),qp.num_WidthInternalDiameter) width_internal_diameter,
   convert(varchar(100),qp.num_long) long,
   convert(varchar(100),ISNULL(qp.str_ProductName,p.str_NameProduct)) product_name,
   convert(varchar(100),qp.num_quantity) quantity,
   convert(varchar(100),qp.num_SubTotal) sub_total,
   convert(varchar(100),qp.num_Total) total,
   convert(varchar(100),qp.num_price) unity_price,
   convert(varchar(100),ISNULL(qp.diameter,p.num_Diameter)) diameter,
   convert(varchar(100),ISNULL(qp.theorical_weight,p.num_TeoricalWeight)) theoretical_weight,
   convert(varchar(100),ISNULL(qp.unity_product,p.num_Unit)) unity_product,
   convert(varchar(100),p.cod_TiProducts) cod_TiProducts,
   convert(varchar(100),qp.cod_tialmacen) cod_tialmacen
   from Quotation_Products qp
   inner join quotation q on qp.cod_Quotation = q.cod_Quotation
   inner join Products p on qp.cod_Products = p.cod_Products
   where 
   ( q.dte_CreateDate between '".$bgn."' and '".$end."' )


   ";


   if($valposition != 1){

      $sql_quotationProducts = $sql_quotationProducts . "   ". "   and 
      q.cod_User = ".$codUser;

   }



   $sql_billing = "
   
   select 
   a.cod_Billing codBillingUniq,
   a.cod_User codUser,
   convert(varchar(100),a.cod_Customer) codCustomer,
   a.cod_BillingType codBillingType,
   a.cod_PaymentMethod codPaymentMethod,
   a.str_operation strOperation,
   a.dte_BillingDate dteBillingDate,
   a.cod_Bank codBank,
   a.cod_Currency codCurrency,
   a.num_AmountOperation numAmountOperation,
   a.str_Comments strComments,
   a.flg_State flgState,
   a.dte_CreateUser dteCreateUser,
   a.str_CreateDate strCreateDate,
   a.cod_Company codCompany,
   0 flgSync,
   0 flgCodRealSystem
   from billing a
   where 
   ( convert(date, a.str_CreateDate) between '".$bgn."' and '".$end."' )

   ";


   
   if($valposition != 1){

      $sql_billing = $sql_billing . "   ". "   and 
      a.cod_User = ".$codUser;

   }

   $master_class          = new stdClass();
   $arr_quotation         = array(); 
   $arr_quotationProducts = array(); 
   $arr_billings          = array(); 



   // echo $sql_quotation;
   // echo "<<<<z<>>>>>>>>";
   // echo $sql_quotationProducts;
   // echo "<<<<z<>>>>>>>>";
   // echo $sql_billing;


   foreach ($conn->query($sql_quotation) as $row) {
    $arr = array(); 
   
     if(count($row) > 0){


        $arr['id'] = (String) $row['id'];
        $arr['currencyId'] = (int)$row['currencyId'];
        $arr['payId'] = (int)$row['payId'];
        $arr['deliveryTypeId']        = (int)$row['deliveryTypeId'];
        $arr['deliveryTimeId']    = (int)$row['deliveryTimeId'];
        $arr['customerId'] = (String)$row['customerId'];

        $arr['userId'] =  (int)$row['userId'];
        $arr['dateQuotation'] = (String)$row['dateQuotation'];
        $arr['nameBusiness']  = (String)$row['nameBusiness'];
        $arr['observation']  = (String)$row['observation'];
        $arr['subTotal']     = (String)$row['subTotal'];
        $arr['total']      = (String)$row['total'];
        $arr['lgv'] = (String)$row['lgv'];
        $arr['createDate']  = (String)$row['createDate'];
        $arr['createUser'] = (String) $row['createUser'];
        $arr['updateDate']  = (String)$row['updateDate'];
        $arr['updateUser'] = (String) $row['updateUser'];

        $arr['state'] = (String) $row['state'];

        $arr['quotationParents'] = (String) $row['quotationParents'];
        $arr['company'] = (int) $row['company'];
        $arr['updateflg'] = (int) $row['updateflg'];
        $arr_quotation[] = $arr;
       

     }

   }


   foreach ($conn->query($sql_quotationProducts) as $row) {
    $arr2 = array(); 
   
     if(count($row) > 0){


        $arr2['id'] = (String) $row['id'];
        $arr2['quotation_id'] = (String)$row['quotation_id'];
        $arr2['product_id'] = (int)$row['product_id'];
        $arr2['create_date']        = (String)$row['create_date'];
        $arr2['create_user']    = (String)$row['create_user'];
        $arr2['width_internal_diameter'] = (String)$row['width_internal_diameter'];

        $arr2['long'] =  (String)$row['long'];
        $arr2['product_name'] = (String)$row['product_name'];
        $arr2['quantity']  = (String)$row['quantity'];
        $arr2['sub_total']  = (String)$row['sub_total'];
        $arr2['total']     = (String)$row['total'];
        $arr2['unity_price']      = (String)$row['unity_price'];
        $arr2['diameter'] = (String)$row['diameter'];
        $arr2['theoretical_weight']  = (String)$row['theoretical_weight'];
        $arr2['unity_product'] = (String) $row['unity_product'];
        $arr2['cod_TiProducts']  = (String)$row['cod_TiProducts'];
        $arr2['cod_TiAlmacen']  = (String)$row['cod_tialmacen'];
        

        $arr_quotationProducts[] = $arr2;
       

     }

   }



   foreach ($conn->query($sql_billing) as $row) {
    $arr2 = array(); 
   
     if(count($row) > 0){


        $arr2['codBillingUniq'] = (String) $row['codBillingUniq'];
        $arr2['codUser'] = (int)$row['codUser'];
        $arr2['codCustomer'] = (String)$row['codCustomer'];
        $arr2['codBillingType']        = (int)$row['codBillingType'];
        $arr2['codPaymentMethod']    = (int)$row['codPaymentMethod'];
        $arr2['strOperation'] = (String)$row['strOperation'];

        $arr2['dteBillingDate'] =  (String)$row['dteBillingDate'];
        $arr2['codBank'] = (int)$row['codBank'];

        $arr2['codCurrency']  = (int)$row['codCurrency'];
        $arr2['numAmountOperation']  = (double)$row['numAmountOperation'];
        $arr2['strComments']     = (String)$row['strComments'];
        $arr2['flgState']      = (int)$row['flgState'];
        $arr2['strCreateUser'] = (String)$row['dteCreateUser'];
        $arr2['dteCreateDate']  = (String)$row['strCreateDate'];
        $arr2['codCompany'] = (int) $row['codCompany'];
        $arr2['flgSync']  = (int)$row['flgSync'];
        $arr2['flgCodRealSystem']  = (int)$row['flgCodRealSystem'];

        $arr_billings[] = $arr2;
       

     }

   }



   $master_class->quotations                = $arr_quotation;
   $master_class->quotationsproducts        = $arr_quotationProducts;
   $master_class->billings                  = $arr_billings;

   echo "[".json_encode($master_class)."]";





?>