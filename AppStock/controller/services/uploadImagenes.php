<?php

    
// $img = ['jpg', 'jpeg', 'png', 'bmp'];
// $doc = ['zip', 'rar', 'pdf', 'doc', 'docx', 'xls','xlsx','ppt','pptx'];
// $whitelistExt = array_merge($img, $doc);
//veremos  =
$return["success"] = 1;
$return["msg"] = "";

$directorio_principal = $_SERVER['DOCUMENT_ROOT']. '\AppStock/dirimagenes/';

try {
$conteo = 0;
foreach ($_POST as $key => $value)
{

    $datos = json_decode($value);
    foreach ($datos as $key2 => $value2) {

        $sub_directorio = $value2->directory;
        // $fn = $value2->fileName;
        // $f = base64_decode($value->encoded);
        // file_put_contents("dirimagenes/".$fn, $f);


        // CREAMOS DIRECTORIO POR CLIENTE - NO ES CONVENIENTE
        // if (!file_exists($directorio_principal.$sub_directorio)) {
        //     mkdir($directorio_principal.$sub_directorio, 0777, true);
        // }
  
        $name      = $value2->fileName; 
        
        $base64_string = $value2->encoded;
        $outputfile = $directorio_principal.$name;
        $filehandler = fopen($outputfile, 'wb' ); 
        fwrite($filehandler, base64_decode($base64_string));
        fclose($filehandler); 

      $conteo++;
    }
    
}

$return["result"] = 1;
$return["msg"] = " Se insertaron correctamente $conteo imagenes en el servidor ";

}catch (Exception $e) {
    $return["result"] = 0;
    $return["msg"] = $e->getMessage();
    die();
}



header('Content-Type: application/json');
// tell browser that its a json data
echo json_encode($return);
//converting array to JSON string

// $image = $_FILES['images']['name'];
// $tmpFile = $_FILES['images']['tmp_name'];


// foreach($image as $keyImage => $value) {
//     foreach($tmpFile as $key => $tmpFilevalue) {
//         $fileExt = explode('.', $value);
//         $fileActualExt = strtolower(end($fileExt));
//         $new_extension = 'jpg';
//         $fileNameNew = "post".$key.".".$new_extension;
        
//         if(move_uploaded_file($tmpFilevalue, 'dirimagenes/'. $fileNameNew)) {
//            echo "ok";
//         }
//     }
// }




// echo "impresion de algo";
// print_r($_FILES["image"]);

// foreach ($_FILES["image"]["error"] as $clave => $error) {
//     echo $error;

//     if ($error == UPLOAD_ERR_OK) {
//         $nombre_tmp = $_FILES["image"]["tmp_name"][$clave];
//         // basename() puede evitar ataques de denegació del sistema de ficheros;
//         // podría ser apropiado más validación/saneamiento del nombre de fichero
//         $nombre = basename($_FILES["image"]["name"][$clave]);
//         print_r($nombre);

//         move_uploaded_file($nombre_tmp, "dirimagenes/$nombre");
//     }
// }

// $return["error"] = false;
// $return["msg"] = "";
// //array to return

// if(isset($_POST["image"])){
//     $name   = $_POST["name"];   
//     $base64_string = $_POST["image"];
//     $outputfile = "dirimagenes/$name" ;
//     //save as image.jpg in uploads/ folder

//     $filehandler = fopen($outputfile, 'wb' ); 
//     //file open with "w" mode treat as text file
//     //file open with "wb" mode treat as binary file
    
//     fwrite($filehandler, base64_decode($base64_string));
//     // we could add validation here with ensuring count($data)>1

//     // clean up the file resource
//     fclose($filehandler); 
// }else{
//     $return["error"] = true;
//     $return["msg"] =  "No image is submited.";
// }

// header('Content-Type: application/json');
// // tell browser that its a json data
// echo json_encode($return);
// //converting array to JSON string

?>