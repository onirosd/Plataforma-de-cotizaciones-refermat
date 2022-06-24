<?php 
include '../config/config.php';
include '../config/connections/sqlconnect.php';
include '../controller/functions/funciones.php';


     $arr_productos = array();
     $sql = "  select  a.idusuario, CONCAT(a.nombre,' ',a.apellidos) as ncompleto from usuario a ";
     
         foreach ($conn->query($sql) as $row) {
         $arr = array();
         
         if(count($row) > 0){
         
         $arr['idusuario']     = $row['idusuario'];
         $arr['ncompleto']     = $row['ncompleto'];
         
         $arr_productos['datos'][] = $arr;
         
         }
         
         
         }
         
     $arr_productos['mensaje'] =  isset($arr_productos['datos']) && count($arr_productos['datos']) > 0  ?"Conexion exitosa": " Tabla de Usuario vacia"; 
     $arr_productos['estado']  =  true; 
     
     include "../view/ViewAppSubida.php";


?>