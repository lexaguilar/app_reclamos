import 'package:app_reclamos/upload.dart';
import 'package:flutter/material.dart';

import 'model/db.dart';
import 'model/tramite.dart';
import 'nuevo.dart';

MyDB myDB = new MyDB();

class Tramites extends StatefulWidget {
  @override
  _TramitesState createState() => _TramitesState();
}

class _TramitesState extends State<Tramites> {
  List<Tramite> tramites = [];

  @override
  void initState() {
    super.initState();

    myDB.create().then((value) => loadTramites());
  }

  Future loadTramites() async {
    final listTramites = await myDB.getTramites();
    setState(() {
      tramites = listTramites;
    });
  }

  final boxDecoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[200])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            child: tramites.length != 0
                ? ListView.builder(
                    padding: EdgeInsets.all(4),
                    itemCount: tramites.length,
                    itemBuilder: (BuildContext context, int index) {
                      var currentTramite = tramites[index];
                      return Card(
                        child: Column(
                          children: <Widget>[
                            Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Tramite ${currentTramite.tramiteId} eliminado'),
                                    action: SnackBarAction(
                                      label: "DESHACER",
                                      onPressed: () {
                                        myDB
                                            .addTramite(currentTramite)
                                            .then((value) => loadTramites());
                                      },
                                    ),
                                  ));

                                  myDB
                                      .deleteTramite(currentTramite.tramiteId)
                                      .then((value) => loadTramites());
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 15.0),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: ListTile(
                                  title:
                                      Text(currentTramite.tramiteId.toString()),
                                  subtitle: Text(currentTramite.cnpoliza),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadScreen(currentTramite
                                                        .tramiteId)));
                                      },
                                      child: Icon(Icons.photo)),
                                  onLongPress: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddTramite(currentTramite.id))),
                                ))
                          ],
                        ),
                      );
                    })
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('No hay tramites en su lista'),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Actualizar lista',
                          onPressed: loadTramites,
                        ),
                        Text('Actualizar')
                      ],
                    ),
                  ),
            onRefresh: loadTramites));
  }
}
