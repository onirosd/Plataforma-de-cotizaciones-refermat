import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:appcotizaciones/src/models/response_error.dart';
import 'package:appcotizaciones/src/modelscrud/gallery_crt.dart';
import 'package:http/http.dart' as http;
import 'package:appcotizaciones/src/config/variables.dart';
import 'package:path/path.dart';
import 'dart:io' as i;

class ApiUploadImages {
  var _url_uploads =
      DIR_URL + "Appstock/controller/services/uploadImagenes.php";

  List<Map> toBase64(List<SelectGallerImages> galleriesList) {
    List<Map> s = [];
    if (galleriesList.length > 0)
      galleriesList.forEach((element) {
        i.File data = i.File(element.pathImage);

        Map a = {
          'nameImage': element.nameImage,
          'fileName': basename(data.path),
          'directory': element.codCustomer.toString(),
          'encoded': base64Encode(data.readAsBytesSync())
        };

        s.add(a);
      });
    return s;
  }

  Future<ResponseError> httpSend_Images_Galleries(
      List<SelectGallerImages> galleriesList) async {
    final Map params = new Map();
    List<i.File> files = [];
    ResponseError error =
        new ResponseError(description: '', error: 1, success: 0);

    // for (var xfile in fileList) {
    //   files.add(i.File(xfile.path));
    // }

    List<Map> attch = toBase64(galleriesList);
    var uri = Uri.parse(_url_uploads);

    params["attachment"] = jsonEncode(attch);

    try {
      var response = await http.post(uri, body: params);
      if (response.statusCode == 200) {
        // print(response.body);
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["result"] == 1 || jsondata["result"] == 0) {
          error.description = jsondata["msg"];
          error.success = jsondata["result"] == 1 ? 1 : 0;
          error.error = jsondata["result"] == 0 ? 1 : 0;
          // print(jsondata["msg"]);
          //if error return from server, show message from server
        } else {
          error.description = 'Tuvimos errores en la subida al servidor';
          error.success = 0;
          error.error = 1;
        }
      } else {
        error.description = 'Error durante la conexion al servidor';
        error.success = 0;
        error.error = 1;
        // print("Error durante la conexion al servidor");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      error.description = e.toString();
      error.success = 0;
      error.error = 1;

      //there is error during converting file image to base64 encoding.
    }
    return error;
  }

  // 1. este era el funcional correctamente
  // Future<bool> httpSend(List<FIle_send> fileList) async {
  //   final Map params = new Map();
  //   List<i.File> files = [];

  //   for (var xfile in fileList) {
  //     files.add(i.File(xfile.path));
  //   }

  //   List<Map> attch = toBase64(files);
  //   var uri = Uri.parse(_url_uploads);

  //   params["attachment"] = jsonEncode(attch);

  //   try {
  //     var response = await http.post(uri, body: params);
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       var jsondata = json.decode(response.body); //decode json data
  //       if (jsondata["error"]) {
  //         //check error sent from server
  //         print(jsondata["msg"]);
  //         //if error return from server, show message from server
  //       } else {
  //         print("Upload successful");
  //       }
  //     } else {
  //       print("Error during connection to server");
  //       //there is error during connecting to server,
  //       //status code might be 404 = url not found
  //     }
  //   } catch (e) {
  //     print("Error during converting to Base64");
  //     //there is error during converting file image to base64 encoding.
  //   }
  //   return true;
  // }

  // 2. este es el segundo funcional individual pero.
  // Future<Future<bool?>?> uploadImages(List<FIle_send> _image) async {
  //   //final List<File> _image = [];
  //   var request = http.MultipartRequest('POST', Uri.parse(_url_uploads));
  //   request.fields['user_id'] = '10';
  //   request.fields['post_details'] = 'dfsfdsfsd';

  //   if (_image.length > 0) {
  //     for (var i = 0; i < _image.length; i++) {
  //       request.files.add(http.MultipartFile(
  //           'images',
  //           File(_image[i].path).readAsBytes().asStream(),
  //           File(_image[i].path).lengthSync(),
  //           filename: basename(_image[i].path.split("/").last)));
  //     }

  //     // send
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       print("Image Uploaded");
  //     } else {
  //       print("Upload Failed");
  //     }
  //   }
  // }

//   Future uploadImageToServer(BuildContext context) async {

//     var uri = Uri.parse('http://18.224.86.8:4000/api/v1/posts/add');
//     http.MultipartRequest request = new http.MultipartRequest('POST', uri);

//     request.fields['userid'] = '1';
//     request.fields['food_name'] = 'piza';

//     List<http.MultipartFile> newList = new http.List<http.MultipartFile>();

//     for (int i = 0; i < imagesList.length; i++) {
//       var path = await FlutterAbsolutePath.getAbsolutePath(imagesList[i].identifier);
//       File imageFile =  File(path);

//       var stream = new http.ByteStream(imageFile.openRead());
//       var length = await imageFile.length();

//       var multipartFile = new http.MultipartFile("pictures", stream, length,
//           filename: basename(imageFile.path));
//       newList.add(multipartFile);
//     }

//     request.files.addAll(newList);
//     var response = await request.send();
//     print(response.toString()) ;

//     response.stream.transform(utf8.decoder).listen((value) {
//       print('value') ;
//       print(value);
//     });

//     if (response.statusCode == 200) {
//       setState(() {
//         showSpinner = false ;
//       });

//       print('uploaded');

//     } else {
//       setState(() {
//         showSpinner = false ;
//       });
//       print('failed');

//     }

//   }catch(e){
//     setState(() {
//       showSpinner = false ;
//     });
//     print(e.toString()) ;

//   }

// }

  Future<void> uploadImage(i.File uploadimage) async {
    //show your own loading or progressing code here

    //String uploadurl = "http://192.168.0.112/test/image_upload.php";
    var uri = Uri.parse(_url_uploads);
    var fileName = uploadimage.path.split('/').last;
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    try {
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http
          .post(uri, body: {'image': baseimage, 'name': fileName.toString()});
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data

        if (jsondata["success"]) {
          //check error sent from server
          print(jsondata["msg"]);
          //if error return from server, show message from server
        }
      } else {
        print("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      print("Error during converting to Base64");
      //there is error during converting file image to base64 encoding.
    }
  }
}
