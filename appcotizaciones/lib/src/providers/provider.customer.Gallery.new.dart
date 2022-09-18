import 'dart:convert';
import 'dart:io' as i;
// import 'package:appcotizaciones/src/models/cusdart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/models/galleriespluscustomer.dart';
import 'package:appcotizaciones/src/models/gallery.dart';
import 'package:appcotizaciones/src/models/galleryDetail.dart';
import 'package:appcotizaciones/src/models/galleryDetailSubtipos.dart';
import 'package:appcotizaciones/src/models/sub_tipo_multimedia.dart';
import 'package:appcotizaciones/src/models/tipo_multimedia.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_crt.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_detail_crt.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_detail_subtipo_crt.dart';
import 'package:appcotizaciones/src/modelscrud/subtipomultimedia_crt.dart';
import 'package:appcotizaciones/src/modelscrud/tipomultimedia_crt.dart';
import 'package:appcotizaciones/src/providers/changes.notifier.dart';
import 'package:appcotizaciones/src/screens/multimedia_add_subtipo.dart';
import 'package:appcotizaciones/src/search/search_customers.dart';
import 'package:appcotizaciones/src/widgets/appbars2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appcotizaciones/src/constants/listsubtipomultimedia.dart';
import 'package:unique_identifier/unique_identifier.dart';

class CustomerGalleryNew extends StatefulWidget {
  final GalleriesplusCustomer dataedit;

  CustomerGalleryNew({Key? key, required this.dataedit}) : super(key: key);

  @override
  _CustomerGalleryNewState createState() => _CustomerGalleryNewState();
}

class _CustomerGalleryNewState extends State<CustomerGalleryNew> {
  String _LoginUser = '';
  int _CodUser = 0;
  String _Company = '';
  String _CodCompany = '';
  Gallery gallery_save = new Gallery(
      codGallery: '',
      codCustomer: '',
      codUser: 0,
      tipoMultimedia: 0,
      // subTipoMultimedia: 0,
      flatEstado: 0,
      fechaCreacion: '');

  List<GalleryDetail> list_galleryDetail = [];
  List<TipoMultimedia> list_tipomultimedia = [];
  List<SubTipoMultimedia> list_subtipomultimedia = [];

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isInternet = true;
  bool isAbsorbing = false;
  bool loader = false;

  String _selectedDate = "";
  TextEditingController _editingController = new TextEditingController();
  // final _key = GlobalKey<FormState>();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  final ButtonStyle _raisedButtonStyle = ElevatedButton.styleFrom(
    //onPrimary: Colors.black,
    primary: Colors.blue,
    minimumSize: Size(300, 72),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  final _space = SizedBox(height: 8);
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  List<i.File>? _imageListSend;
  var _listItems = ['Foto', 'Adjuntar'];
  String _item = 'Foto';
  dynamic _pickImageError;
  String _url = "No tenemos foto seleccionada ";
  List<FIle_send> urls = [];
  int _validateOnepressbutton = 0;
  Customer _customer = new Customer();
  Gallery _galeria = new Gallery(
      codGallery: '',
      codCustomer: '',
      codUser: 0,
      tipoMultimedia: 0,
      // subTipoMultimedia: 0,
      fechaCreacion: '',
      flatEstado: 0);

  List<GalleryDetail> _galeriadetail = [];
  List<GalleryDetailSubtipos> _galeriadetailsubtipos = [];

  int _contador = 0;

  int _input_codTipoMultimedia = 0;
  String _input_codGallery = "";
  String _input_fecha_creacion = "";
  int _flagadjuntar = 0;

  void initState() {
    super.initState();
    ListItems.sel_subtipomultimedia.clear();
    // ListItems.sel_tipomultimedia = 0;
    // ListItems.sel_subtipomultimedia =  [];
    // ListItems.sel_subtipomultimedia.subTipoMultimedia = 0;

    TipoMultimedia_crt crt = new TipoMultimedia_crt();
    setState(() {
      crt.getDataTipoMultimedia().then((value) {
        TipoMultimedia seleccionar = new TipoMultimedia(
            codTipomultimedia: 0,
            desTipomultimedia: 'Seleccionar ',
            flagAdjuntar: 0);
        list_tipomultimedia.add(seleccionar);
        for (var item in value) {
          list_tipomultimedia.add(item);
        }
      });
    });

    SharedPreferences.getInstance().then((res) {
      if (mounted) {
        setState(() {
          _LoginUser = res.getString("usuario") ?? '';
          _Company = res.getString("empresa") ?? '';
          _CodUser = res.getInt("codigo") ?? 0;
          _CodCompany = res.getString("codcompany") ?? '';
        });
      }
    });

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() => _source = source);
      }
    });
  }

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  Future<void> _deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: 50,
        // maxHeight: 50,
        imageQuality: 90,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
        if (_imageFileList != null) {
          _url = _imageFileList![0].path;
          FIle_send filess = new FIle_send(path: _url);
          urls.add(filess);

          print(urls);
        } else {
          _url = 'No tenemos foto seleccionada ';
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                'Cuidado : Se perderan los datos ingresados !! \r  ¿ Desea Salir ? '),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Si'),
              ),
            ],
          ));
  Future<bool?> showWarningImg(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
                'Cuidado : Se perderan las imagenes guardadas !! \r  ¿ Desea Salir ? '),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Si'),
              ),
            ],
          ));

  final Future<String> _delayed = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (widget.dataedit.galleriesdetail == null) {
      _customer = ModalRoute.of(context)!.settings.arguments as Customer;

      SubTipoMultimedia_crt crt1 = new SubTipoMultimedia_crt();
      if (_customer.flagTipoMultimedia != 0) {
        crt1
            .getsubTipoMultimedia(_customer.flagTipoMultimedia.toString())
            .then((value) {
          list_subtipomultimedia = value;
        });
      }

      print(">> entrando correctamente");
      print(_customer);
    } else {
      print(">> no deberia de llegar aqui");
      _customer = widget.dataedit.customer!;
      _galeria = widget.dataedit.gallery!;
      _galeriadetail = widget.dataedit.galleriesdetail!;
      _galeriadetailsubtipos = widget.dataedit.galleriesdetailsubtipos!;

      SubTipoMultimedia_crt crt1 = new SubTipoMultimedia_crt();
      crt1
          .getsubTipoMultimedia(
              widget.dataedit.gallery!.tipoMultimedia.toString())
          .then((value) {
        list_subtipomultimedia = value;
      });
      // final veremos = widget.dataedit.gallery!.codGallery;
    }

    // print(_customer);

    _isInternet =
        _source.keys.toList()[0] == ConnectivityResult.none ? false : true;

    return WillPopScope(
      onWillPop: () async {
        print(_customer);
        bool? showpopup = await showWarning(context);
        if (showpopup == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'Gallery_customer', (route) => false,
              arguments: _customer);
        }
        //  _moveToScreen2(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBars(
          loginuser: _LoginUser,
          company: _Company,
          context: context,
          isOnline: _isInternet,
        ),
        body: FutureBuilder(
          future: _delayed,
          builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              // Obtenemos los datos si es que vienen para modificar

              if (widget.dataedit.gallery != null && _contador == 0) {
                ListItems.sel_tipomultimedia = _galeria.tipoMultimedia;
                // ListItems.sel_subtipomultimedia.comentario =
                //     _galeria.comentario;
                // ListItems.sel_subtipomultimedia.subTipoMultimedia =
                //     _galeria.subTipoMultimedia;

                // print(ListItems.sel_subtipomultimedia);

                for (var item in _galeriadetail) {
                  FIle_send filess = new FIle_send(path: item.pathImage);
                  urls.add(filess);
                }

                for (var items in _galeriadetailsubtipos) {
                  ListItems.sel_subtipomultimedia.add(items);
                }

                List<TipoMultimedia> list_tipomultimedia_filtrado =
                    list_tipomultimedia
                        .where((o) =>
                            o.codTipomultimedia ==
                            widget.dataedit.gallery!.tipoMultimedia)
                        .toList();

                _flagadjuntar = list_tipomultimedia_filtrado[0].flagAdjuntar;

                // int _input_codTipoMultimedia = _galeria.tipoMultimedia;
                // String _input_codGallery = _galeria.codGallery;
                // String _input_fecha_creacion = _galeria.fechaCreacion;
                _contador++;
              } else {
                if (_customer.flagTipoMultimedia != 0) {
                  List<TipoMultimedia> list_tipomultimedia_filtrado =
                      list_tipomultimedia
                          .where((o) =>
                              o.codTipomultimedia ==
                              _customer.flagTipoMultimedia)
                          .toList();

                  _flagadjuntar = list_tipomultimedia_filtrado[0].flagAdjuntar;
                  ListItems.sel_tipomultimedia = _customer.flagTipoMultimedia!;
                }
              }

              return AbsorbPointer(
                absorbing: isAbsorbing,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              alignment: Alignment.topLeft,
                              child: Form(
                                key: _key,
                                child: Column(
                                  //shrinkWrap: true,
                                  children: [
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      //enabled: false,
                                      focusNode:
                                          FocusNode(canRequestFocus: false),
                                      readOnly: true,
                                      controller: TextEditingController()
                                        ..text = widget.dataedit.gallery == null
                                            ? "N° Temporal de Galeria"
                                            : widget
                                                .dataedit.gallery!.codGallery,

                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[400],
                                          filled: true,
                                          labelText: "codGaleria",
                                          labelStyle:
                                              TextStyle(color: Colors.white)),

                                      // onSaved: (value) {
                                      // customer.numRut = value.toString();
                                      //},
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController()
                                        ..text = _LoginUser,
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[400],
                                          filled: true,
                                          labelText: "Vendedor",
                                          labelStyle:
                                              TextStyle(color: Colors.white)),
                                      focusNode:
                                          FocusNode(canRequestFocus: false),
                                      validator: (val) {
                                        gallery_save.codUser = _CodUser;
                                        gallery_save.codCustomer =
                                            _customer.codCustomer!;
                                      },
                                      // onSaved: (val) {

                                      // }
                                      // onSaved: (value) {
                                      // customer.numRut = value.toString();
                                      //},
                                    ),

                                    TextFormField(
                                        readOnly: true,
                                        controller: _editingController
                                          ..text = widget.dataedit.gallery !=
                                                  null
                                              ? widget.dataedit.gallery!
                                                  .fechaCreacion
                                              : DateFormat("yyyy-MM-dd").format(
                                                  DateTime
                                                      .now()), //DateTime.now().toString(),
                                        // DateFormat("yyyy-MM-dd").toString(),
                                        decoration: InputDecoration(
                                            fillColor: Colors.grey[400],
                                            filled: true,
                                            labelText: "Fecha",
                                            labelStyle:
                                                TextStyle(color: Colors.white)),
                                        focusNode:
                                            FocusNode(canRequestFocus: false),
                                        onSaved: (val) {
                                          gallery_save.fechaCreacion =
                                              widget.dataedit.gallery! != null
                                                  ? widget.dataedit.gallery!
                                                      .fechaCreacion
                                                  : DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.now());
                                          //print('saved');
                                        }
                                        // onSaved: (value) {
                                        // customer.numRut = value.toString();
                                        //},
                                        ),

                                    DropdownButtonFormField(
                                      // decoration: textInputDecoration,
                                      decoration: InputDecoration(
                                          labelText: "Tipo Multimedia"),
                                      value: ListItems.sel_tipomultimedia == 0
                                          ? (_customer.flagTipoMultimedia != 0
                                              ? _customer.flagTipoMultimedia
                                              : (list_tipomultimedia.length > 0
                                                  ? list_tipomultimedia[0]
                                                      .codTipomultimedia
                                                  : '0'))
                                          : ListItems.sel_tipomultimedia,

                                      items: list_tipomultimedia.map((emap) {
                                        return DropdownMenuItem(
                                          // ignore: unnecessary_null_comparison
                                          value: emap.codTipomultimedia != null
                                              ? emap.codTipomultimedia
                                              : 0,
                                          child: Text(emap.desTipomultimedia),
                                        );
                                      }).toList(),

                                      validator: (val) {
                                        if (val == 0 || val == null) {
                                          return 'Seleccione un tipo multimedia valido';
                                        } else {
                                          gallery_save.tipoMultimedia =
                                              val as int;
                                        }
                                        return null;
                                        // gallery_save.codUser = _CodUser;
                                        // gallery_save.codCustomer =
                                        //     customer.codCustomer!;
                                      },

                                      onChanged: (val) async {
                                        setState(() {});
                                        SubTipoMultimedia_crt crt1 =
                                            new SubTipoMultimedia_crt();

                                        list_subtipomultimedia =
                                            await crt1.getsubTipoMultimedia(
                                                val.toString());

                                        List<TipoMultimedia>
                                            list_tipomultimedia_filtrado =
                                            list_tipomultimedia
                                                .where((o) =>
                                                    o.codTipomultimedia ==
                                                    val as int)
                                                .toList();

                                        _flagadjuntar =
                                            list_tipomultimedia_filtrado[0]
                                                .flagAdjuntar;

                                        ListItems.sel_tipomultimedia =
                                            val as int;

                                        urls.clear();
                                        setState(() {
                                          ListItems.sel_subtipomultimedia
                                              .clear();
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                        child: Text(
                                          'Elegir Sub-tipo',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        alignment: Alignment.topLeft),
                                    popup(context),

                                    const SizedBox(height: 8),
                                    // LIST PRODUCTS
                                    if (ListItems
                                            .sel_subtipomultimedia.isNotEmpty &&
                                        ListItems.sel_subtipomultimedia.length >
                                            0)
                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: 150, minHeight: 100),
                                          child: Scrollbar(
                                            // isAlwaysShown: true,
                                            child: ListView.separated(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: ListItems
                                                  .sel_subtipomultimedia.length,
                                              itemBuilder: (context, index) {
                                                var subtipo = ListItems
                                                    .sel_subtipomultimedia[
                                                        index]
                                                    .subTipoMultimedia
                                                    .toString()
                                                    .trimRight()
                                                    .trimLeft();

                                                var list_subtipo =
                                                    list_subtipomultimedia
                                                        .where((o) =>
                                                            o.codSubtipomultimedia
                                                                .toString() ==
                                                            subtipo)
                                                        .toList();
                                                var sub_tipo = list_subtipo
                                                            .length >
                                                        0
                                                    ? list_subtipo.first
                                                        .desSubtipomultimedia
                                                    : '';

                                                return ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 7,
                                                        child: Text(
                                                          (index + 1)
                                                                  .toString() +
                                                              " : " +
                                                              sub_tipo,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      // Expanded(
                                                      //   flex: 1,
                                                      //   child: Container(
                                                      //     alignment: Alignment.topRight,
                                                      //     child: Text(
                                                      //       ListItems.listItems[index].sub_total
                                                      //           .toString(),
                                                      //       style: TextStyle(fontSize: 10),
                                                      //       textAlign: TextAlign.right,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  trailing: Wrap(
                                                    spacing:
                                                        12, // space between two icons
                                                    children: <Widget>[
                                                      IconButton(
                                                        onPressed: () {
                                                          // print("deleted");
                                                          // var subTotal = double.tryParse(ListItems
                                                          //     .listItems
                                                          //     .elementAt(index)
                                                          //     .sub_total);

                                                          setState(() {
                                                            ListItems
                                                                .sel_subtipomultimedia
                                                                .removeAt(
                                                                    index);
                                                          });

                                                          // if (ListItems.listItems.length == 0) {
                                                          //   _bloquearCurrency = 0;
                                                          // }
                                                        },
                                                        icon: Icon(Icons
                                                            .delete_outlined),
                                                      ),
                                                      // icon-2
                                                    ],
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(
                                                height: 1.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 30.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: '',
                                        ),
                                        maxLines: 1,
                                        validator: (val) {
                                          if (ListItems.sel_subtipomultimedia
                                                  .length ==
                                              0) {
                                            return 'Seleccione por lo menos un Subtipo';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Container(
                                        child: Text(
                                          'Adjuntar Imagenes',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        alignment: Alignment.topLeft),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  var opcion =
                                                      ImageSource.camera;

                                                  _onImageButtonPressed(opcion,
                                                      context: context);
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Foto'), // <-- Text
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      // <-- Icon
                                                      Icons.image,
                                                      size: 24.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: _flagadjuntar == 0
                                                    ? null
                                                    : () {
                                                        var opcion =
                                                            ImageSource.gallery;

                                                        _onImageButtonPressed(
                                                            opcion,
                                                            context: context);
                                                      },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'Adjuntar'), // <-- Text
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      // <-- Icon
                                                      Icons.image_search_sharp,
                                                      size: 24.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // _crearFecha(context),

                                    if (urls.isNotEmpty)
                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: 200, minHeight: 200),
                                          child: Scrollbar(
                                            // isAlwaysShown: true,
                                            child: ListView.separated(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: urls.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 6,
                                                        child: Text(
                                                          'Nro.' +
                                                              (index + 1)
                                                                  .toString() +
                                                              ': ' +
                                                              urls[index]
                                                                  .path
                                                                  .split('/')
                                                                  .last
                                                                  .toString()
                                                                  .trimRight()
                                                                  .trimLeft(),
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(
                                                height: 1.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 30),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      onPressed: _validateOnepressbutton == 1
                                          ? null
                                          : () async {
                                              setState(() {
                                                _validateOnepressbutton = 1;
                                              });

                                              FocusScope.of(context).unfocus();

                                              if (_key.currentState!
                                                  .validate()) {
                                                try {
                                                  setState(() => loader = true);
                                                  String latitude = '';
                                                  String longitude = '';

                                                  GalleryCtr crt1 =
                                                      new GalleryCtr();
                                                  GalleryDetailCtr crt2 =
                                                      new GalleryDetailCtr();

                                                  GalleryDetailSubtipoCtr crt3 =
                                                      new GalleryDetailSubtipoCtr();

                                                  try {
                                                    Position coordenadas =
                                                        await _getGeoLocationPosition();
                                                    latitude = coordenadas
                                                        .latitude
                                                        .toString();
                                                    longitude = coordenadas
                                                        .longitude
                                                        .toString();
                                                  } catch (e) {
                                                    print(
                                                        "Tenemos un error : " +
                                                            e.toString());
                                                  }
                                                  //var res = await quotationCrt.insertQuotation(Quotation(
                                                  String? identifier =
                                                      widget.dataedit.gallery ==
                                                              null
                                                          ? UniqueKey()
                                                              .hashCode
                                                              .toString()
                                                          : widget
                                                              .dataedit
                                                              .gallery!
                                                              .codGallery;

                                                  // gallery_save
                                                  //         .subTipoMultimedia =
                                                  //     ListItems
                                                  //         .sel_subtipomultimedia
                                                  //         .subTipoMultimedia;
                                                  // gallery_save.comentario =
                                                  //     ListItems
                                                  //         .sel_subtipomultimedia
                                                  //         .comentario;
                                                  gallery_save.tipoMultimedia =
                                                      ListItems
                                                          .sel_tipomultimedia;
                                                  gallery_save.fechaCreacion =
                                                      _editingController.text;
                                                  gallery_save.codGallery =
                                                      identifier;
                                                  gallery_save.latitud =
                                                      latitude;
                                                  gallery_save.longitud =
                                                      longitude;
                                                  gallery_save.flatEstado = 0;

                                                  if (urls.isNotEmpty ||
                                                      urls.length > 0) {
                                                    if ((await crt1
                                                            .insertUpdateGallery(
                                                                gallery_save,
                                                                widget.dataedit
                                                                            .gallery ==
                                                                        null
                                                                    ? 0
                                                                    : 1)) >
                                                        0) {
                                                      if (widget.dataedit
                                                              .gallery !=
                                                          null) {
                                                        await crt2
                                                            .deleteGalleryDetailforcodGallery(
                                                                gallery_save
                                                                    .codGallery);
                                                      }

                                                      for (var item in urls) {
                                                        final code_name = item
                                                            .path
                                                            .split('/')
                                                            .last;

                                                        GalleryDetail input =
                                                            new GalleryDetail(
                                                                codGallery:
                                                                    identifier,
                                                                codImage:
                                                                    code_name
                                                                        .split(
                                                                            '.')
                                                                        .first,
                                                                nameImage:
                                                                    code_name,
                                                                pathImage:
                                                                    item.path,
                                                                fechaCreacion:
                                                                    _editingController
                                                                        .text);

                                                        // actualizamos datos en la galeria
                                                        await crt2
                                                            .insertGalleryDetail(
                                                                input);
                                                      }

                                                      if (widget.dataedit
                                                              .gallery !=
                                                          null) {
                                                        await crt3
                                                            .deleteGalleryDetailSubtiposforcodGallery(
                                                                gallery_save
                                                                    .codGallery);
                                                      }

                                                      for (var gallerydetailsubtipo
                                                          in ListItems
                                                              .sel_subtipomultimedia) {
                                                        gallerydetailsubtipo
                                                                .codGallery =
                                                            identifier;

                                                        await crt3
                                                            .insertGalleryDetailSubtipos(
                                                                gallerydetailsubtipo);
                                                      }

                                                      // actualizamos el flag del cliente para que sea sincronizado
                                                      _customer.asyncFlag = 0;
                                                      _customer
                                                          .flagForceMultimedia = 0;

                                                      CustomerCtr crtcust =
                                                          new CustomerCtr();
                                                      await crtcust
                                                          .updateCustomerOnebyOneInd(
                                                              _customer);
                                                      // terminamos el guardado  y nos regresamos al menu de galeria
                                                      final msg_confirm = SnackBar(
                                                          content: Text(
                                                              ' Se inserto correctamente la galeria!'));

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              msg_confirm);
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              'Gallery_customer',
                                                              (route) => false,
                                                              arguments:
                                                                  _customer);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "ALERTA : Tuvimos errores al insertar en la galeria !")));
                                                    }
                                                    //Aqui en este punto guardamos

                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "ALERTA : No estas guardando imagenes!")));
                                                  }

                                                  setState(() {
                                                    loader = false;
                                                  });
                                                } catch (err) {
                                                  print(err);
                                                  setState(() {
                                                    loader = false;
                                                  });
                                                }
                                              }

                                              setState(() {
                                                _validateOnepressbutton = 0;
                                              });
                                            },
                                      child: Row(
                                        textBaseline: TextBaseline.ideographic,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          if (loader)
                                            Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.white,
                                            ))
                                          else ...[
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Icon(
                                              Icons
                                                  .check_circle_outline_outlined,
                                              // color: Colors.blue,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              'Imprimir Procesado',
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    // _CustomAppBar()
                  ],
                ),
              );
            }
          }),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1),
              label: 'Agregar',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: 'Buscar',
              backgroundColor: Colors.green,
            ),
          ],
          currentIndex: 1,
          // selectedItemColor: Colors.blue,
          onTap: (int page) async {
            if (page == 2) {
              await showSearch(
                context: context,
                delegate: CustomerSearchDelegate(),
              );
            }
            if (page == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'customerNew', (route) => false);
            }
            if (page == 0) {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'home', (route) => false);
            }
          },
        ),
      ),
    );
  }

  _crearFecha(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 9,
                child: TextFormField(
                    //autofocus: true,
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: _editingController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today),
                    ),
                    onTap: () {
                      //FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDate2(context, _editingController.text);
                    },
                    onSaved: (val) {}),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      // setState(() {
                      _editingController.text = '';
                      //});
                    },
                    icon: Icon(Icons.clear),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void _selectDate2(BuildContext context, String fecha) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime.now(),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _selectedDate =
            DateFormat("yyyy-MM-dd").format(picked); //picked.toString();
        _editingController.text = _selectedDate;
      });
    }
  }

  Widget popup(BuildContext context2) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 47, 151, 241)),
          onPressed: ListItems.sel_tipomultimedia == 0
              ? null
              : () {
                  // ListItems.sel_tipomultimedia = 0;
                  // ListItems.sel_subtipomultimedia.comentario = '';
                  // ListItems.sel_subtipomultimedia.tipoMultimedia = 0;

                  // _displayTextInputDialog;

                  showDialog(
                      context: context2,
                      builder: (context) {
                        return openDialogue();
                      }).then((value) {
                    if (value != null) {
                      setState(() {});
                      if (ListItems.sel_tipomultimedia > 0) {
                        // _bloquearCurrency = 1;
                      }
                    }
                  });
                },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Seleccionar Motivo SubTipo",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          )),
    );
  }

  Widget openDialogue() {
    return Multimediaaddsubt();
  }
}

class FIle_send {
  String path;

  FIle_send({
    required this.path,
  });

  FIle_send copyWith({
    String? path,
  }) {
    return FIle_send(
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'path': path});

    return result;
  }

  factory FIle_send.fromMap(Map<String, dynamic> map) {
    return FIle_send(
      path: map['path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FIle_send.fromJson(String source) =>
      FIle_send.fromMap(json.decode(source));

  @override
  String toString() => 'FIle_send(path: $path)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FIle_send && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}
