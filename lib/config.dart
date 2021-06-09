import 'package:app_reclamos/model/user.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'model/db.dart';

MyDB myDB = new MyDB();

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  User user = new User(nombre: "", numero: 0, username: "");
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

  void _salir() {
    myDB.deteteUser().then((value) => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()))
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar sessión'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Estas seguro de cerrar la aplicación?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Confirmar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _salir();
                }),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            "assets/images/splash.png",
            width: 150,
            height: 200,
            scale: 1,
          )),
      new ListTile(
          title: Text("Cerrar Session"),
          trailing: Icon(Icons.power_settings_new),
          onTap: _showMyDialog)
    ]));
  }
}
