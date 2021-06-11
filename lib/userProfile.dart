import 'package:app_reclamos/model/user.dart';
import 'package:flutter/material.dart';

import 'model/db.dart';

MyDB myDB = new MyDB();

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Datos"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Card(
                      elevation: 1.5,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 150,
                              width: 150,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                minRadius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 75,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                user.username,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                    Icons.card_membership,
                                                    color: Colors.green[600]),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Icon(Icons.person,
                                                    color: Colors.green[600]),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.location_city,
                                                  color: Colors.green[600],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Alias:",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Nombre:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Numero:",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  user.username,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  user.nombre,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  user.numero.toString(),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      )),
                )),
            // Container(
            //   padding:
            //       EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            //   width: double.infinity,
            //   height: 70,
            //   child: MaterialButton(
            //     child: Text("Regresar"),
            //     color: Colors.green,
            //     onPressed: () {},
            //   ),
            // )
          ],
        ));
  }
}
