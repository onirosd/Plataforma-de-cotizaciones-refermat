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
$lista   = $decoded_params['lista'];
$company = $decoded_params['company'];

$arr_consult = array(); 
$sql_consult = "

SELECT 
a.cod_Products,
concat(concat(convert(varchar(250) , a.cod_TiProducts) ,concat(concat(': '+rtrim(ltrim(a.str_NameProduct)),', Stock : '), convert(varchar(50),convert(decimal(18,2), b.num_stock))))+', Precio+IGV : ', convert(varchar(50), convert(decimal(18,2),  convert(decimal(18,2),b.num_priceMax) + (convert(decimal(18,2),b.num_priceMax) * convert(decimal(18,2), com.num_impuesto))) )    ) as str_NameProduct,
a.str_NameProduct as str_NameProductReal,
a.num_Unit,
a.num_Diameter,
a.num_TeoricalWeight,
a.cod_CategoryProduct,
c.str_CategoryProduct,
b.num_priceMin,
b.num_priceMax,
b.num_stock,
b.cod_List,
b.Cod_TiAlmacen,
convert(int, b.str_currency) Cod_Currency,
a.cod_TiProducts,
al.description as Des_TiAlmacen,
a.num_empaque as num_Empaque
FROM Products a 
INNER JOIN Company com2  
on a.cod_company = com2.cod_Company and  com2.cod_Company = ".$company."
INNER JOIN TI_ProductStock b 
on a.cod_TiProducts = b.cod_TiProducts
INNER JOIN  Category_Product c ON
a.cod_CategoryProduct = c.cod_CategoryProduct
INNER JOIN TI_Almacen al
on b.Cod_TiAlmacen = al.Cod_TiAlmacen
INNER JOIN Company com
on al.cod_Company = com.cod_Company
INNER JOIN TI_List li 
on b.cod_List = li.cod_List
WHERE  b.cod_List = ".$lista." and li.cod_company = ".$company."

";




foreach ($conn->query($sql_consult) as $row) {
 $arr = array(); 

 if(count($row) > 0){
    

 $arr['codProducts'] = (int)$row['cod_Products'];
 $arr['strNameProduct'] = (String)$row['str_NameProduct'];
 $arr['strNameProductReal'] = (String)$row['str_NameProductReal'];
 $arr['numUnit']        = (String)$row['num_Unit'];
 $arr['numDiameter']    = (String)$row['num_Diameter'];
 $arr['numTeoricalWeight'] = (String)$row['num_TeoricalWeight'];
 $arr['codCategoryProduct'] =  (int)$row['cod_CategoryProduct'];
 $arr['strCategoryProduct'] = (String)$row['str_CategoryProduct'];
 $arr['numPriceMin']  = (String)$row['num_priceMin'];
 $arr['numPriceMax']  = (String)$row['num_priceMax'];
 $arr['numStock']     = (String)$row['num_stock'];
 $arr['codList']      = (int)$row['cod_List'];
 $arr['codTiAlmacen'] = (int)$row['Cod_TiAlmacen'];
 $arr['codCurrency']  = (int)$row['Cod_Currency'];
 $arr['cod_TiProducts'] = (String) $row['cod_TiProducts'];
 $arr['desTiAlmacen'] = (String) $row['Des_TiAlmacen'];
 $arr['num_Empaque'] = (int) $row['num_Empaque'];
 
 $arr_consult[] = $arr;

 }


}

echo json_encode($arr_consult);



?>