import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'const/uri.dart';
import 'main.dart';
import 'model/db.dart';
import 'model/user.dart';

MyDB myDB = new MyDB();

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  User user = new User();

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void initState() {
    super.initState();

    txtUsername.addListener(_printLatestValue);
    txtPassword.addListener(_printLatestValue);

    myDB.create();
  }

  _printLatestValue() {
    var username = txtUsername.text;

    var newUser = new User(username: username);

    setState(() {
      user = newUser;
    });
  }

  login() async {
    EasyLoading.show(status: 'Iniciando sesion');
    var password = txtPassword.text;
    var resp = await http.post(PATH_LOGIN,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': user.username,
          'password': password,
        }));

    if (resp.statusCode == 200) {
      EasyLoading.dismiss();
      var newUser = User.fromJson(json.decode(resp.body));
      myDB.addUser(newUser).then((value) => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp())));
    } else if (resp.statusCode == 500) {
      EasyLoading.dismiss();
      EasyLoading.showError('Error en la aplicacion');
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Credenciales no validas');
    }
  }

  final decorationStart = InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Usuario',
  );
  final decorationEnd =
      InputDecoration(border: OutlineInputBorder(), labelText: 'Contraseña');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: EdgeInsets.all(25),
      child: Column(children: <Widget>[
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.only(top: 35, bottom: 5, left: 40, right: 40),
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/splash.png",
            width: 200,
            scale: 1,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          decoration: decorationStart,
          controller: txtUsername,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: decorationEnd,
          controller: txtPassword,
          obscureText: true,
        ),
        SizedBox(height: 20),
        MaterialButton(
          elevation: 10,
          onPressed: login,
          child: Text("Iniciar", style: TextStyle(fontSize: 20)),
        )
      ]),
    )));
  }
}
