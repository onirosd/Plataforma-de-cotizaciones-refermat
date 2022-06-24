function cTrig(clickedid) { 

      if (document.getElementById(clickedid).checked == true) {
        var box= confirm("¿ Quieres realmente limpiar toda la tabla de Productos ?");
        if (box==true)
            return true;
        else
           document.getElementById(clickedid).checked = false;

      } else {
       return false;

      }
}