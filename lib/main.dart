import 'dart:async';

import 'package:app_reclamos/changepass.dart';
import 'package:app_reclamos/nuevo.dart';
import 'package:app_reclamos/tramites.dart';
import 'package:app_reclamos/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'login.dart';
import 'model/db.dart';

MyDB myDB = new MyDB();
void main() {
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mis tramites'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _timer;

  // String username = "";
  // bool exists = false;
  // bool verificando = true;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    myDB.create().then((value) => {
          myDB.getUser().then((value) => {if (value.token == null) _salir()})
        });
  }

  void _navegate() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new AddTramite(0)));
  }

  void _salir() {
    myDB.deteteUser().then((value) => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => new Login()))
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

  Widget myDrawer() {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                "assets/images/splash.png",
                width: 80,
                height: 70,
                scale: 1,
              )),
          new ListTile(
            title: Text("Mis tramites"),
            trailing: Icon(Icons.list),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
          new ListTile(
            title: Text("Mis datos"),
            trailing: Icon(Icons.person),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new UserProfile()));
            },
          ),
          new ListTile(
            title: Text("Cambiar contraseña"),
            trailing: Icon(Icons.https),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new ChangePass()));
            },
          ),
          new ListTile(
              title: Text("Salir"),
              trailing: Icon(Icons.power_settings_new),
              onTap: _showMyDialog)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                icon: Icon(Icons.power_settings_new), onPressed: _showMyDialog)
          ],
        ),
        body: new Tramites(),
        floatingActionButton: new FloatingActionButton(
          heroTag: "btn1",
          onPressed: _navegate,
          tooltip: 'Nuevo',
          child: Icon(Icons.add),
        ));
  }
}
