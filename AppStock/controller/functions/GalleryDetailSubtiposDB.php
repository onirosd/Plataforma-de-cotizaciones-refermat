<?php
class GalleryDetailSubtiposDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $gallerydetail)
    {
        $statement = "
        INSERT INTO GalleryDetailSubtipos_Temp(
            subTipoMultimedia
            ,comentario
            ,fechaCreacion
            ,codGallery
            ,codGallerySubtipo
         )
         VALUES(
            :subTipoMultimedia,
            :comentario,
            :fechaCreacion,
            :codGallery,
            :codGallerySubtipo
         )
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'subTipoMultimedia' => (int) $gallerydetail['subTipoMultimedia'],
            'comentario' => (String)$gallerydetail['comentario'],
            'fechaCreacion' => (String)$gallerydetail['fechaCreacion'],
            'codGallery' => (String)$gallerydetail['codGallery'],
            'codGallerySubtipo' => (String)$gallerydetail['codGallerySubtipo']
            
            ));
            
            return $statement->rowCount();
        
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>