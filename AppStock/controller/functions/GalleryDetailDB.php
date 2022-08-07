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
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'codGallery' => (String) $gallerydetail['codGallery'],
            'codImage' => (String)$gallerydetail['codImage'],
            'nameImage' => (String)$gallerydetail['nameImage'],
            'fechaCreacion' => (String)$gallerydetail['fechaCreacion'],
            'pathImage' => (String)$gallerydetail['pathImage']
            
            ));
            
            return $statement->rowCount();
        
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>