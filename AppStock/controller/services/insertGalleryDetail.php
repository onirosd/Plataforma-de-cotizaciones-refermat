<?php

include '../../config/config.php';
include '../functions/GalleryDetailDB.php';
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

    $galleryDetaildb = new GalleryDetailDB($conn);

    foreach ($decoded_params as $key => $value) {
        //$dato = $value[0];
        $dato = (array) json_decode($value);
      //  print_r($dato);
        $num_inserts =  $num_inserts +  $galleryDetaildb->insert($dato);
    }
  

    echo json_encode([
        'error' => 1 , 
        'description' => 'Se sincronizaron '.(String)$num_inserts.' Galerias Detalles de clientes',
        'cant' => $num_inserts
    ]);
    
} catch (exception $e) {
    echo json_encode(['error' => 0 , 'description' => $e->getMessage(),  'cant'=> 0]);
}

}


?>