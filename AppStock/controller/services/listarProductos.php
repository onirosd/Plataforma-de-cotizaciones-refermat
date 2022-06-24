<?php  
include '../../config/connections/sqlconnect.php';

$usuario = "";
if(isset($_GET['usuario'])){

  $usuario = trim($_GET['usuario']);

}else{

    return false;
}

if($constatus){

    $arr_productos = array();
    $sql = "
    SELECT  
    CODIGO,
    CODIGOPROV,
    DESCRIPCION,
    INVENTARIO,
    PRECIO_FULL,
    PRECIO_DESC,
    OBSERVACION,
    USUARIO
    FROM Listaproductos
    WHERE USUARIO = '$usuario'

    ";
    
    foreach ($conn->query($sql) as $row) {
     $arr = array();
     
     if(count($row) > 0){
     
     $arr['CODIGO'] = $row['CODIGO'];
     $arr['CODIGOPROV'] = $row['CODIGOPROV'];
     $arr['DESCRIPCION'] = $row['DESCRIPCION'];
     $arr['INVENTARIO'] = $row['INVENTARIO'];
     $arr['PRECIO_FULL'] = $row['PRECIO_FULL'];
     $arr['PRECIO_DESC'] = $row['PRECIO_DESC'];
     $arr['USUARIO'] = $row['USUARIO'];
     
     $arr_productos[] = $arr;

     }


    } 

    echo json_encode($arr_productos);
    
 
} else{
	
    $arr_productos = array();
    $arr_productos['mensaje'] = 'Tenemos error de conexion';
    
    echo json_encode($arr_productos);
}

?>