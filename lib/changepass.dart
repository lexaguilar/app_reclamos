import 'package:app_reclamos/const/uri.dart';
import 'package:app_reclamos/model/tramite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'model/db.dart';
import 'model/tramite.dart';
import 'dart:io';
import 'dart:convert';

MyDB myDB = new MyDB();

class ChangePass extends StatefulWidget {
  @override
  ChangePassState createState() => ChangePassState();
}

class ChangePassState extends State<ChangePass> {
  String token = "";
  String username = "";
  ChangePassState();

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final repeatPassController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // oldPassController.addListener(_printLatestValue);
    // newPassController.addListener(_printLatestValue);

    myDB.create().then((value) {
      myDB.getUser().then((value) {
        setState(() {
          token = value.token;
          username = value.username;
        });
      });
    });
  }

//   _printLatestValue() {
//     var oldPass = int.parse(oldPassController.text);
//     var newPass = int.parse(newPassController.text);
//   }

  changePass() async {
    EasyLoading.show(status: 'Cambiando contraseña');

    if (newPassController.text.length < 5) {
      EasyLoading.showError('La nueva contraseña debe tener 5 digitos');
      EasyLoading.dismiss();
    } else {
      final body = jsonEncode({
        'oldPass': oldPassController.text,
        'newPass': newPassController.text,
        'repeatPass': repeatPassController.text
      });

      var resp = await http.post(changePassUrl(username),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token'
          },
          body: body);

      if (resp.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else if (resp.statusCode == 500) {
        EasyLoading.dismiss();
        EasyLoading.showError('Error en la aplicacion');
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(resp.body);
      }
    }
  }

  final decorationStartOld = InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Contraseña actual',
  );
  final decorationStartNew = InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Nueva contraseña',
  );
  final decorationStartRepeat = InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Repetir contraseña',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cambiar contraseña"),
        ),
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(children: <Widget>[
            SizedBox(height: 10),
            TextField(
                obscureText: true,
                decoration: decorationStartOld,
                controller: oldPassController),
            SizedBox(height: 10),
            TextField(
                obscureText: true,
                decoration: decorationStartNew,
                controller: newPassController),
            SizedBox(height: 10),
            TextField(
                obscureText: true,
                decoration: decorationStartRepeat,
                controller: repeatPassController),
            SizedBox(height: 30),
            Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: MaterialButton(
                  elevation: 10,
                  onPressed: changePass,
                  color: Colors.green,
                  child: Text("Cambiar contraseña",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                )),
          ]),
        )));
  }
}
