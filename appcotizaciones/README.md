# appcotizaciones

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

- generar apk

cmd : flutter build apk --debug --no-sound-null-safety

------------------------------------


### Estados ###

column state : 

0 : Pre Procesado
1 : Procesado pendiente de sincronizar
2 : Procesado sincronizado

5 : Es una  actualizacion del supervisor  , y si  la columna  updateflg es igual a 1 , estos registros
van a actualizar en el mobil con estado 2.


### Customer ###

column flg_sinc

esta columna puede tener 2 estados

0 = pendiente de sincronizar en el mobil
2 = esta sincronizado con exito en la nube y mobil


* tener cuidado si mandamos un customer con codiog cero de la base de datos.
en el mobil se duplicaria varias veces, ya que esa tabla se trae al iniciar el logueo


### Cotizaciones y Recibos ###

updateflg != -1
lgSync != -1

estos registros hacen referencia a que estan pendientes de sincronizar