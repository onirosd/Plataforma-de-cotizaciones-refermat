<?php

include '../../config/config.php';
//echo BASE_URL.'controller/functions/CustomerDb.php';

//require_once(__DIR__.'/controller/functions/CustomerDb.php');
//include $_SERVER['DOCUMENT_ROOT']
//include BASE_URL.'controller/functions/CustomerDb.php';
//include '../functions/CustomerDb.php';
//require_once ( '../functions/CustomerDb.php');
//require_once ( 'config/connections/sqlconnect.php');
include '../functions/GalleryDB.php';
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


if($constatus){

try {

    $gallerydb = new GalleryDB($conn);
    $galleryDetaildb = new GalleryDetailDB($conn);

    foreach ($decoded_params as $key => $value) {
        $dato = (array) json_decode($value);
        $num_inserts =  $num_inserts +  $gallerydb->insert((array) $dato['gallery'], 2);
        
        foreach ($dato['galleryDetail'] as $key => $value) {

            $arreglo = (array)$value;
            // print_r($arreglo);

            $galleryDetaildb->insert($arreglo); 
            
        }

    }
  

    echo json_encode([
        'error' => 1 , 
        'description' => 'Se insertaron correctamente '.(String)$num_inserts.' Galerias.',
        'cant' => $num_inserts
    ]);
    
} catch (exception $e) {
    echo json_encode(['error' => 0 , 'description' => $e->getMessage(),  'cant'=> 0]);
}

}


?>