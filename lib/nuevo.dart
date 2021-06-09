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

class AddTramite extends StatefulWidget {
  final id;
  AddTramite(this.id);

  @override
  AddState createState() => AddState(id);
}

class AddState extends State<AddTramite> {
  Tramite tramite = new Tramite();
  String token = "";

  int id;
  AddState(this.id);

  final txtTramite = TextEditingController();

  @override
  void initState() {
    super.initState();

    txtTramite.addListener(_printLatestValue);

    myDB.create().then((value) {
      myDB.getUser().then((value) {
        setState(() {
          token = value.token;
        });
      });
      getLog();
    });
  }

  getLog() async {
    if (id > 0)
      myDB.getTramite(id).then((_tramite) {
        txtTramite.text = _tramite.tramiteId.toString();
      });
  }

  _printLatestValue() {
    var tramiteId = int.parse(txtTramite.text);
    var newTramite = new Tramite(id: id, tramiteId: tramiteId, username: '');
    setState(() {
      tramite = newTramite;
    });
  }

  saveTramite() async {
    EasyLoading.show(status: 'Guardando');
    var resp = await http.post(
      getTramite(tramite.tramiteId),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      var newTramite = Tramite.fromJson(json.decode(resp.body));
      EasyLoading.dismiss();
      myDB.addTramite(newTramite).then((value) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyApp())));
    } else if (resp.statusCode == 500) {
      EasyLoading.dismiss();
      EasyLoading.showError('Error en la aplicacion');
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError(resp.body);
    }
  }

  final decorationStart = InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'No tramite',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nuevo tramite"),
        ),
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(children: <Widget>[
            SizedBox(height: 50),
            TextField(
                decoration: decorationStart,
                controller: txtTramite,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
            SizedBox(height: 30),
            Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: MaterialButton(
                  elevation: 10,
                  onPressed: saveTramite,
                  color: Colors.green,
                  child: Text("Guardar tramite",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                )),
          ]),
        )));
  }
}
