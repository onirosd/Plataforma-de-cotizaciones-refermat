<?php
class GalleryDetailDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $gallerydetail)
    {
        $statement = "
        INSERT INTO GalleryDetail_Temp(
            codGallery
            ,codImage
            ,nameImage
            ,fechaCreacion
            ,pathImage
         )
         VALUES(
            :codGallery,
            :codImage,
            :nameImage,
            :fechaCreacion,
            :pathImage
         )
        ";

        try {
            
            $http = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https://' : 'http://';
            $directorio_principal = $http.$_SERVER['SERVER_NAME']. '/AppStock/dirimagenes/';
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'codGallery' => (String) $gallerydetail['codGallery'],
            'codImage' => (String)$gallerydetail['codImage'],
            'nameImage' => (String)$gallerydetail['nameImage'],
            'fechaCreacion' => (String)$gallerydetail['fechaCreacion'],
            'pathImage' => (String)$directorio_principal.$gallerydetail['nameImage'] //(String)$gallerydetail['pathImage'] veremo
            
            ));
            
            return $statement->rowCount();
        
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>