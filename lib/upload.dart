import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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

  savaImages() async {
    if (images != null) {
      if (images.length > 0) {
        int count = 0;
        for (var i = 0; i < images.length; i++) {
          count++;
          EasyLoading.show(status: 'Subiendo $count de ${images.length}...');
          ByteData byteData = await images[i].getByteData();
          List<int> imgData = byteData.buffer.asUint8List();

          MultipartFile file = MultipartFile.fromBytes(imgData,
              filename: images[i].name, contentType: MediaType('image', 'jpg'));

          FormData formData = FormData.fromMap({
            "file": file,
          });

          var url = getUploadFiles(tramiteId, user.username);
          dio.options.headers["authorization"] = "Bearer ${user.token}";
          var resp = await dio.post(url, data: formData);

          if (resp.statusCode == 200) {
            print(resp.data);
          } else {
            EasyLoading.dismiss();
          }
        }
        EasyLoading.dismiss();
        EasyLoading.showSuccess('$count imagenes adjuntas');
      }
    }
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
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            onPressed: savaImages,
            child: Column(
              children: [Text("Subir imagenes"), Icon(Icons.file_upload)],
            ),
          )
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
