<?php

include '../../config/config.php';
//echo BASE_URL.'controller/functions/CustomerDb.php';

//require_once(__DIR__.'/controller/functions/CustomerDb.php');
//include $_SERVER['DOCUMENT_ROOT']
//include BASE_URL.'controller/functions/CustomerDb.php';
//include '../functions/CustomerDb.php';
//require_once ( '../functions/CustomerDb.php');
//require_once ( 'config/connections/sqlconnect.php');
include '../functions/BillingDB.php';
require '../../config/connections/sqlconnect.php';

 $errordescription = '';
 $code_error  = 1;
 $json_params = file_get_contents("php://input");
 $num_inserts = 0;

 /*
 $lista_prueba = [];

 $prueba = [
    //'cod_Customer' => 19,
    'num_RucCustomer' => '20101930222',
    'str_Name' => 'Lister Aiquipa Quispe',
    'str_Celphone' => '98982322',
    'str_Mail' => 'diego@warthon.com',
    'str_Address' => 'Villa el Salvador, sector 3 , grupo 11',
    'cod_TiCustomer' => 0,
    'cod_Company' => 1
];

$lista_prueba[] =  $prueba;
$lista_prueba[] =  $prueba;

print_r(json_encode($lista_prueba)); */

//print_r(isValidJSON($json_param));


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
    $errordescription = 'No se tiene conexion a la BD del servicio.';
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


$decoded_params = json_decode($json_params);


//print_r($decoded_params);

//echo "<br>";
if($constatus){

try {

    $billingdb = new BillingDB($conn);

    foreach ($decoded_params as $key => $value) {
        //$dato = $value[0];
        $dato = (array) json_decode($value);
      //  print_r($dato);
        $num_inserts =  $num_inserts +  $billingdb->insert($dato);
    }
  

    echo json_encode([
        'error' => 1 , 
        'description' => 'Se insertaron correctamente '.(String)$num_inserts.' Recibos.',
        'cant' => $num_inserts
    ]);
    
} catch (exception $e) {
    echo json_encode(['error' => 0 , 'description' => $e->getMessage(),  'cant'=> 0]);
}

}


?>