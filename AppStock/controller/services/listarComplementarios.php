<?php 
include '../../config/connections/sqlconnect.php';

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
$user    = $decoded_params['user'];
$company = $decoded_params['company'];


if($constatus){

    $arr_usuario = array();
    // $sql_company = "
    
    // select 
    // a.cod_company codCompany,
    // a.str_DesCompany strDesCompany,
	// a.str_IdCompany strRucCompany,
	// a.str_Address strAddress,
	// a.str_Phone strPhone,
	// isnull(a.str_Logo,'') strLogo,
    // a.str_PrintFormat strPrintFormat,
    // a.cod_Currency codCurrency,
    // convert(varchar(20),a.num_impuesto) numImpuesto,
	// isnull(b.campo1,'') campo1,
	// isnull(b.campo2,'') campo2,
	// isnull(b.campo3,'') campo3,
	// isnull(b.campo4,'') campo4,
	// isnull(b.campo5,'') campo5,
	// isnull(b.campo6,'') campo6,
	// isnull(b.campo7,'') campo7,
	// isnull(b.campo8,'') campo8,
	// isnull(b.campo9,'') campo9,
	// isnull(b.campo10,'') campo10
    // from Company a
	// left join CompanyVarReports b on a.cod_Company = b.cod_Company
    // where a.flg_async = 0 
   

    // ";
    
    $sql_person = "
    
    select
    a.cod_Person codPerson,
    a.str_DesPerson strDesPerson,
    a.str_Position strPosition,
    a.str_Celphone strCelphone
    from TI_Person a
    where a.flg_async = 0  and
    a.cod_company = ".$company."

    ";

    $sql_tilist = "
    
    select 
    a.cod_List codList,
    a.str_description strDescription
    from TI_list a
    where a.flg_async = 0 and
    a.cod_company = ".$company."

    ";

    $sql_bank =  "
    select 
    a.cod_Bank codBank,
    a.str_Description strDescription 
    from bank a
    where a.flg_async = 0 and
    a.cod_company = ".$company."
    ";

    $sql_payCondition =  "
    select 
    a.cod_PayCondition codPayCondition,
    a.str_Description strDescription 
    from payCondition a
    where a.flg_async = 0 and
    a.cod_company = ".$company."
    ";

    $sql_paymentMethod =  "
    select 
    a.cod_PaymentMethod codPaymentMethod,
    a.str_Description strDescription 
    from Payment_Method a
    where a.flg_async = 0 and
    a.cod_company = ".$company."
    ";

    /// aQUI NOS ESTAMOS QUEDANDO
    
    $sql_billingtype =  "
    select 
    a.cod_BillingType codBillingType,
    a.str_Description strDescription 
    from Billing_Type a
    where a.flg_async = 0 and 
    a.cod_company = ".$company."
    ";

    $sql_currency =  "
    select 
    a.cod_Currency codCurrency,
    a.str_Currency strDescription ,
    a.str_Description strName
    from Currency a
    where a.flg_async = 0 and
    a.cod_company = ".$company."
    ";


    $sql_deliverytime =  "
    select 
    a.cod_DeliveryTime id,
    a.str_Description delivery_time,
    a.str_Description description
    from deliveryTime a
    where a.flg_async = 0 and
    a.cod_company = ".$company."
    ";


    $sql_deliverytype=  "
    select 
    a.cod_DeliveryType id,
    a.str_Description description
    from DeliveryType a
    where a.flg_async = 0 and
    a.cod_company = ".$company."
    ";


    $sql_indicators=  "
    SELECT 
    str_Descripcion AS strDescription,
    str_Value AS strValue,
    cod_User AS codUser
    FROM Ti_IndicatorsUser a
    WHERE  a.cod_User = ".$user." and 
    a.cod_company = ".$company."
    ";
    

    $master_class = new stdClass();
     
    // $arr_company = array();
    // foreach ($conn->query($sql_company) as $row) {
    //  $arr = array(); 
    //  if(count($row) > 0){

    //  $arr['codCompany'] = (int)$row['codCompany'];
    //  $arr['strDesCompany'] = $row['strDesCompany'];
    //  $arr['strRucCompany'] = $row['strRucCompany'];
    //  $arr['strAddress'] = $row['strAddress'];
    //  $arr['strPhone'] = $row['strPhone'];
    //  $arr['strLogo'] = $row['strLogo'];
    //  $arr['strPrintFormat'] = $row['strPrintFormat'];
    //  $arr['codCurrency'] = $row['codCurrency'];
    //  $arr['numImpuesto'] = $row['numImpuesto'];
    //  $arr['campo1'] = $row['campo1'];
    //  $arr['campo2'] = $row['campo2'];
    //  $arr['campo3'] = $row['campo3'];
    //  $arr['campo4'] = $row['campo4'];
    //  $arr['campo5'] = $row['campo5'];
    //  $arr['campo6'] = $row['campo6'];
    //  $arr['campo7'] = $row['campo7'];
    //  $arr['campo8'] = $row['campo8'];
    //  $arr['campo9'] = $row['campo9'];
    //  $arr['campo10'] = $row['campo10'];

    //  $arr_company[] = $arr;
    // }
    
    // }


    $arr_person = array();
    foreach ($conn->query($sql_person) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codPerson'] = (int)$row['codPerson'];
     $arr['strDesPerson'] = $row['strDesPerson'];
     $arr['strPosition'] =  $row['strPosition'];
     $arr['strCelphone'] =  $row['strCelphone'];
     $arr_person[] = $arr;
                        }
    }


    $arr_tilist = array();
    foreach ($conn->query($sql_tilist) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codList'] = (int)$row['codList'];
     $arr['strDescription'] = $row['strDescription'];
     $arr_tilist[] = $arr;
                        }
    }
    

    $arr_bank = array();
    foreach ($conn->query($sql_bank) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codBank'] = (int)$row['codBank'];
     $arr['strDescription'] = $row['strDescription'];
     $arr_bank[] = $arr;
     }
    
    }

    $arr_payCondition = array();
    foreach ($conn->query($sql_payCondition) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codPayCondition'] = (int)$row['codPayCondition'];
     $arr['strDescription']  = $row['strDescription'];
     $arr_payCondition[] = $arr;
     }
    
    }


    $arr_paymentMethod = array();
    foreach ($conn->query($sql_paymentMethod) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codPaymentMethod'] = (int)$row['codPaymentMethod'];
     $arr['strDescription']   = $row['strDescription'];
     $arr_paymentMethod[]     = $arr;

     }
    
    }


    $arr_billingType= array();
    foreach ($conn->query($sql_billingtype) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codBillingType'] = (int)$row['codBillingType'];
     $arr['strDescription']   =      $row['strDescription'];
     $arr_billingType[]       = $arr;

     }
    
    }



    $arr_currency = array();
    foreach ($conn->query($sql_currency) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['codCurrency'] = (int)$row['codCurrency'];
     $arr['strDescription']   =      $row['strDescription'];
     $arr['strName']   =      $row['strName'];

     $arr_currency[]       = $arr;

     }
    
    }
    
    $arr_deliverytime = array();
    foreach ($conn->query($sql_deliverytime) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['id']      = (int)$row['id'];
     $arr['delivery_time']   =      $row['delivery_time'];
     $arr['description']   =        $row['description'];
     $arr_deliverytime[]       = $arr;

     }
    
    }
    
    $arr_deliverytype= array();
    foreach ($conn->query($sql_deliverytype) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['id']              = (int)$row['id'];
     $arr['description']     = $row['description'];
     $arr_deliverytype[]     = $arr;

     }
    
    }

    $arr_indicators= array();
    foreach ($conn->query($sql_indicators) as $row) {
     $arr = array(); 
     if(count($row) > 0){

     $arr['strDescription'] = (String)$row['strDescription'];
     $arr['strValue']     = (String)$row['strValue'];
     $arr['codUser']     = (int)$row['codUser'];
     $arr_indicators[]     = $arr;

     }
    
    }



    // $master_class->company          = $arr_company;
    $master_class->tiperson         = $arr_person;
    $master_class->tilist           = $arr_tilist;
    $master_class->bank             = $arr_bank;
    $master_class->paycondition     = $arr_payCondition;
    $master_class->paymentmethod    = $arr_paymentMethod;
    $master_class->billingtype      = $arr_billingType;
    $master_class->currency         = $arr_currency;
    $master_class->deliverytype     = $arr_deliverytype;
    $master_class->deliverytime     = $arr_deliverytime;
    $master_class->indicators       = $arr_indicators;

    echo "[".json_encode($master_class)."]";

   // echo json_encode(object_to_array($master_class));

 
}


function object_to_array($data)
{
    if (is_array($data) || is_object($data))
    {
        $result = [];
        foreach ($data as $key => $value)
        {
            $result[$key] = (is_array($data) || is_object($data)) ? object_to_array($value) : $value;
        }
        return $result;
    }
    return $data;
}


 ?>