<?php
class QuotationProductDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $quotation)
    {
        $statement = "
        INSERT INTO Quotation_Products_Temp(
            Cod_Quotation_Products,
            cod_Quotation,
            cod_Products,
            dte_CreateDate,
            str_CreateUser,
            num_WidthInternalDiameter,
            num_long,
            str_ProductName,
            num_quantity,
            num_SubTotal,
            num_Total,
            num_price,
            diameter,
            theorical_weight,
            unity_product,
            str_comment,
            cod_tialmacen
            

         )
         VALUES(
            :Cod_Quotation_Products,
            :cod_Quotation,
            :cod_Products,
            :dte_CreateDate,
            :str_CreateUser,
            :num_WidthInternalDiameter,
            :num_long,
            :str_ProductName,
            :num_quantity,
            :num_SubTotal,
            :num_Total,
            :num_price,
            :diameter,
            :theorical_weight,
            :unity_product,
            :str_comment,
            :cod_tialmacen
         )
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'Cod_Quotation_Products' => (String) $quotation['id'],
            'cod_Quotation' => (String)$quotation['quotation_id'],
            'cod_Products' => (int)$quotation['product_id'],
            'dte_CreateDate' => (String)$quotation['create_date'],
            'str_CreateUser' => (String)$quotation['create_user'],
            'num_WidthInternalDiameter' => (String)$quotation['width_internal_diameter'],
            'num_long' => (String)$quotation['long'],
            'str_ProductName' => (String)$quotation['product_name'],
            'num_quantity' => (String)$quotation['quantity'],
            'num_SubTotal' => (String)$quotation['sub_total'],
            'num_Total' => (String)$quotation['total'],
            'num_price' => (String)$quotation['unity_price'],
            'diameter' => (String)$quotation['diameter'],
            'theorical_weight' => (String)$quotation['theoretical_weight'],
            'unity_product' => (String)$quotation['unity_product'],
            'str_comment' => (String)$quotation['comment'],
            'cod_tialmacen' => (String)$quotation['cod_TiAlmacen'],
               
            ));
            
            return $statement->rowCount();
        
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>