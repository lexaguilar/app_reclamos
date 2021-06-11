import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'const/uri.dart';
import 'model/db.dart';
import 'model/user.dart';

MyDB myDB = new MyDB();

class UploadScreen extends StatefulWidget {
  final tramiteId;
  UploadScreen(this.tramiteId);

  @override
  _UploadScreenState createState() => _UploadScreenState(tramiteId);
}

class _UploadScreenState extends State<UploadScreen> {
  int tramiteId;
  _UploadScreenState(this.tramiteId);
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  List<Asset> images = [];
  User user = new User();
  Dio dio = new Dio();

  @override
  void initState() {
    super.initState();

    myDB.create().then((value) {
      myDB.getUser().then((_value) {
        setState(() {
          user = _value;
        });
      });
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  final _appDataDir = Directory.systemTemp;
  static const _dataFilesBaseDirectoryName = "store";

  File _createZipFile(String fileName) {
    final zipFilePath = "${_appDataDir.path}/$fileName";
    final zipFile = File(zipFilePath);

    if (zipFile.existsSync()) {
      print("Deleting existing zip file: ${zipFile.path}");
      zipFile.deleteSync();
    }
    return zipFile;
  }

  Future<File> createZip({bool includeBaseDirectory}) async {
    print("_appDataDir=${_appDataDir.path}");
    final storeDir =
        Directory("${_appDataDir.path}${"/$_dataFilesBaseDirectoryName"}");

    final zipFile = _createZipFile("testZip.zip");
    print("Writing to zip file: ${zipFile.path}");

    final files = <File>[];
    for (var i = 0; i < images.length; i++) {
      final file = new File("${storeDir.path}/${images[i].name}");
      ByteData byteData = await images[i].getByteData();
      file.createSync(recursive: true);
      final buffer = byteData.buffer;
      file.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      files.add(file);
    }

    try {
      await ZipFile.createFromFiles(
          sourceDir: storeDir,
          zipFile: zipFile,
          files: files,
          includeBaseDirectory: includeBaseDirectory);
    } on PlatformException catch (e) {
      print(e);
    }
    return zipFile;
  }

  bool containImages() => images != null && images.length > 0;

  savaImages() async {
    print("object");
    if (images != null) {
      if (images.length > 0) {
        EasyLoading.show(status: 'Comprimiendo ${images.length} imagenes');

        var myzip = await createZip(includeBaseDirectory: false);

        var url = getUploadFiles(tramiteId, user.username);
        dio.options.headers["authorization"] = "Bearer ${user.token}";

        var date = DateTime.now();

        String filename =
            "$tramiteId-${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}.zip";

        MultipartFile file = await MultipartFile.fromFile(myzip.path,
            filename: filename,
            contentType: MediaType('application/octet-stream', 'zip'));

        FormData formData = FormData.fromMap({
          "file": file,
        });

        EasyLoading.show(status: 'Enviando archivos...');

        EasyLoading.dismiss();

        try {
          var resp = await dio.post(url, data: formData);
          if (resp.statusCode == 200) {
            print(resp.data);
            EasyLoading.showSuccess("Archivo enviado correctamente",
                duration: Duration(seconds: 2));
            EasyLoading.dismiss();
          } else {
            EasyLoading.dismiss();
          }
        } catch (e) {
          EasyLoading.showError("Error al enviar imagenes");
          EasyLoading.dismiss();
        }

        // for (var i = 0; i < images.length; i++) {
        //   count++;
        //   EasyLoading.show(
        //       status: 'Comprimiendo $count de ${images.length}...');

        //   ByteData byteData = await images[i].getByteData();
        //   List<int> imgData = byteData.buffer.asUint8List();

        //   // MultipartFile file = MultipartFile.fromBytes(imgData,
        //   //     filename: images[i].name,
        //   //     contentType: MediaType('image', 'jpg'));

        //   // FormData formData = FormData.fromMap({
        //   //   "file": file,
        //   // });

        //   // var url = getUploadFiles(tramiteId, user.username);
        //   // dio.options.headers["authorization"] = "Bearer ${user.token}";

        //   // var resp = await dio.post(url, data: formData);
        //   // if (resp.statusCode == 200) {
        //   //   print(resp.data);
        //   // } else {
        //   //   EasyLoading.dismiss();
        //   // }
        // }
        // EasyLoading.dismiss();
        // EasyLoading.showSuccess('$count imagenes adjuntas');
      }
    }
    _btnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imagenes Tramite: $tramiteId"),
      ),
      body: Column(
        children: [
          Expanded(child: buildGridView()),
          RoundedLoadingButton(
            width: 200,
            //child: Text('Tap me!', style: TextStyle(color: Colors.white)),
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text("Subir imagenes",
                        style: TextStyle(color: Colors.white)),
                    Icon(Icons.file_upload, color: Colors.white)
                  ],
                )),
            controller: _btnController,
            onPressed: savaImages,
          ),
          // RaisedButton(
          //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          //   onPressed: !sending ? savaImages : () => 0,
          //   child: Column(
          //     children: [Text("Subir imagenes"), Icon(Icons.file_upload)],
          //   ),
          // )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: loadAssets,
        tooltip: 'Upload',
        child: Icon(Icons.add_a_photo),
      ), // T
    );
  }
}
