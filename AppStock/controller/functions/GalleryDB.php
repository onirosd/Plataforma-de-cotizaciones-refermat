<?php
class GalleryDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $gallery, int $estado)
    {
        $statement = "
        INSERT INTO Gallery_Temp(
             codGallery
            ,codCustomer
            ,codUser
            ,tipoMultimedia
            ,subTipoMultimedia
            ,comentario
            ,latitud
            ,longitud
            ,fechaCreacion
            ,flatEstado
            
         )
         VALUES(
            :codGallery,
            :codCustomer,
            :codUser,
            :tipoMultimedia,
            :subTipoMultimedia,
            :comentario,
            :latitud,
            :longitud,
            :fechaCreacion,
            :flatEstado
         )
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'codGallery' => (String) $gallery['codGallery'],
            'codCustomer' => (String)$gallery['codCustomer'],
            'codUser' => (int)$gallery['codUser'],
            'tipoMultimedia' => (int)$gallery['tipoMultimedia'],
            'subTipoMultimedia' => (int)$gallery['subTipoMultimedia'],
            'comentario' => (String)$gallery['comentario'],
            'latitud' => (String)$gallery['latitud'],
            'longitud' => (String)$gallery['longitud'],
            'fechaCreacion' => (String)$gallery['fechaCreacion'],
            'flatEstado' => $estado == 2 ? 2 : (int)$gallery['flatEstado']
            
            ));
            
            return $statement->rowCount();
        
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>