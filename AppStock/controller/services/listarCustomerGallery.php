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
$empresa = (String) $decoded_params['codEmpresa'];
$codUser = (String) $decoded_params['codUser'];

// print_r($empresa);

//echo $empresa;

if($constatus){


    $arr_usuario = array();
    $sql = "
       
	 SELECT 
     cod_Customer codCustomer,
     num_RucCustomer numRucCustomer,
     num_RucCustomer numRut,
     str_Name strName,
     str_Celphone strCelphone,
     str_Mail strMail,
     str_Address strAddress,
     cod_TiCustomer codTiCustomer,
     cod_Company codCompany,
     flg_Sinc asyncFlag,
     latitude,
     longitude,
     flag_force_multimedia as flagForceMultimedia,
     flag_tipo_multimedia as flagTipoMultimedia,
     Mensaje as mensaje,
     DeudaTotal as deudaTotal,
     DeudaVencida as deudaVencida,
     DiasVencida as diasVencida,
     FechaUltimaVenta as fechaUltimaVenta,
     CondicionCredito as condicionCredito,
     flag_mensaje_invasivo as flagMensajeInvasivo

     FROM CUSTOMER  
     where cod_Company = ".$empresa;

     $sql_gallery = "
       
     SELECT [codGallery] AS  codGallery
     ,A.[codCustomer] AS codCustomer
     ,[codUser] AS codUser
     ,[tipoMultimedia] AS tipoMultimedia
     ,[comentario] comentario
     ,[latitud] latitud
     ,[longitud] longitud
     ,[fechaCreacion] fechaCreacion
     ,[flatEstado] flatEstado
      FROM [dbo].[Gallery] A
      INNER JOIN Customer B ON B.cod_Customer = A.codCustomer
      WHERE A.codUser = ".$codUser." and  B.cod_Company  = ".$empresa;

     $sql_gallery_detail = "
       
     SELECT a.[codGallery] codGallery
     ,[codImage] codImage
     ,[nameImage] nameImage
     ,a.[latitud] latitud
     ,a.[longitud] longitud
     ,a.[fechaCreacion] fechaCreacion
     ,[pathImage] pathImage
      FROM [dbo].[GalleryDetail] a
      INNER JOIN  [dbo].[Gallery] b on a.codGallery = b.codGallery
      INNER JOIN Customer c on c.cod_Customer = b.codCustomer
     where b.codUser = ".$codUser." and c.cod_Company = ".$empresa;

     $sql_gallery_detail_subtipos = "
     SELECT 
	  a.subTipoMultimedia,
	  a.comentario,
	  a.fechaCreacion,
	  a.codGallery,
	  a.codGallerySubtipo
      FROM [dbo].[GalleryDetailSubtipos] a
      INNER JOIN  [dbo].[Gallery] b on a.codGallery = b.codGallery
      INNER JOIN Customer c on c.cod_Customer = b.codCustomer
	  where b.codUser = ".$codUser." and c.cod_Company = ".$empresa;


     
    $comprobacion = 0;
    $master_class          = new stdClass();
    $arr_customer  = array();
    $arr_galllery  = array();
    $arr_galleryDetail  = array();
    $arr_galleryDetailSubtipos = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     if(count($row) > 0){

     $arr['codCustomer'] = $row['codCustomer'];
     $arr['numRucCustomer'] = $row['numRucCustomer'];
     $arr['numRut'] = $row['numRut'];
     $arr['strName'] = $row['strName'];
     $arr['strCelphone'] = $row['strCelphone'];
     $arr['strMail'] = $row['strMail'];
     $arr['strAddress'] = $row['strAddress'];
    
     $arr['codTiCustomer'] = (int)$row['codTiCustomer'];
     $arr['codCompany'] = (int)$row['codCompany'];
     $arr['asyncFlag'] = (int)$row['asyncFlag'];
     $arr['latitude'] = (String)$row['latitude'];
     $arr['longitude'] = (String)$row['longitude'];


     $arr['flagForceMultimedia'] = (int)$row['flagForceMultimedia'];
     $arr['flagTipoMultimedia'] = (int)$row['flagTipoMultimedia'];

     
     $arr['Mensaje'] = (String)$row['Mensaje'];
     $arr['DeudaTotal'] = (String)$row['DeudaTotal'];
     $arr['DeudaVencida'] = (String)$row['DeudaVencida'];
     $arr['DiasVencida'] = (int)$row['DiasVencida'];
     $arr['FechaUltimaVenta'] = (String)$row['FechaUltimaVenta'];
     $arr['CondicionCredito'] = (String)$row['CondicionCredito'];
     $arr['flag_mensaje_invasivo'] = (int)$row['flag_mensaje_invasivo'];

    // $arr['PASS'] = $row['PASS'];

     $arr_customer[] = $arr;

     }
    

     }


     foreach ($conn->query($sql_gallery) as $row) {
      $arr = array(); 
 
      if(count($row) > 0){
 
      $arr['codGallery'] = (String)$row['codGallery'];
      $arr['codCustomer'] = (String)$row['codCustomer'];
      $arr['codUser'] = (int)$row['codUser'];
      $arr['tipoMultimedia'] = (int)$row['tipoMultimedia'];
      // $arr['subTipoMultimedia'] = (int)$row['subTipoMultimedia'];
      $arr['comentario'] = (String)$row['comentario'];
      $arr['latitud'] = (String)$row['latitud'];
      $arr['longitud'] = (String)$row['longitud'];
      $arr['fechaCreacion'] = (String)$row['fechaCreacion'];
      $arr['flatEstado'] = (int)$row['flatEstado'];
 
      $arr_galllery[] = $arr;
 
      }
     
 
      }


      foreach ($conn->query($sql_gallery_detail) as $row) {
         $arr = array(); 
    
         if(count($row) > 0){
    
         $arr['codGallery'] = (String)$row['codGallery'];
         $arr['codImage'] = (String)$row['codImage'];
         $arr['nameImage'] = (String)$row['nameImage'];
         $arr['pathImage'] = (String)$row['pathImage'];
         $arr['latitud'] = (String)$row['latitud'];
         $arr['longitud'] = (String)$row['longitud'];
         $arr['fechaCreacion'] = (String)$row['fechaCreacion'];
         
    
         $arr_galleryDetail[] = $arr;
    
         }
        
    
         }


         foreach ($conn->query($sql_gallery_detail_subtipos) as $row) {
            $arr = array(); 
       
            if(count($row) > 0){
            
            $arr['codGallerySubtipo'] = (String)$row['codGallerySubtipo'];
            $arr['subTipoMultimedia'] = (int)$row['subTipoMultimedia'];
            $arr['comentario'] = (String)$row['comentario'];
            $arr['fechaCreacion'] = (String)$row['fechaCreacion'];
            $arr['codGallery'] = (String)$row['codGallery'];
            
       
            $arr_galleryDetailSubtipos[] = $arr;
       
            }
           
       
            }


         $master_class->customer            = $arr_customer;
         $master_class->gallery             = $arr_galllery;
         $master_class->galleryDetail       = $arr_galleryDetail;
         $master_class->galleriesdetailsubtipos = $arr_galleryDetailSubtipos;
      
         echo "[".json_encode($master_class)."]";
   //   echo json_encode($arr_customer); 

  //  $comprobacion            = count($arr_usuario);  
  //  $cadenaenviar['estado']  = $comprobacion;  
   // $cadenaenviar['datos']   = $arr_usuario;

 //   if($comprobacion > 0){
     
   //    $cadenaenviar['mensaje'] =  " Se Ingreso Correctamente.";    
     
   // }else{


     //  $cadenaenviar['mensaje'] = 'Usuario y/o Contraseña Incorrectas';

   // }

 
}
 ?>