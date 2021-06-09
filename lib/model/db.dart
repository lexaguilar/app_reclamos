import 'package:app_reclamos/model/user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tramite.dart';

class MyDB {
  Future<Database> database;

  Future create() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      join(await getDatabasesPath(), 'flujo_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Users(username TEXT, nombre TEXT, numero INT2, token TEXT)",
        );

        return await db.execute(
          "CREATE TABLE IF NOT EXISTS tramites(id INTEGER PRIMARY KEY AUTOINCREMENT, tramiteId INT2, username TEXT, cnpoliza TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> addTramite(Tramite tramite) async {
    // Get a reference to the database.
    final Database db = await database;
    var sql =
        "INSERT INTO tramites (tramiteId,username,cnpoliza) VALUES(${tramite.tramiteId}, '${tramite.username}', '${tramite.cnpoliza}')";

    await db.rawInsert(sql);
  }

  Future<List<Tramite>> getTramites() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The menu.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * from tramites Order by tramiteId desc");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Tramite(
          id: maps[i]['id'],
          tramiteId: maps[i]['tramiteId'],
          cnpoliza: maps[i]['cnpoliza'],
          username: maps[i]['username']);
    });
  }

  Future<Tramite> getTramite(int id) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The menu.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM tramites WHERE id=$id');

    final result = List.generate(maps.length, (i) {
      return Tramite(
          id: maps[i]['id'],
          tramiteId: maps[i]['tramiteId'],
          username: maps[i]['username']);
    });

    return result.length > 0 ? result[0] : new Tramite();
  }

  Future<void> deleteTramite(int id) async {
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      "tramites",
      // Use a `where` clause to delete a specific dog.
      where: "tramiteId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> addUser(User user) async {
    // Get a reference to the database.
    final Database db = await database;
    var sql =
        "INSERT INTO Users (username, nombre, numero, token) VALUES('${user.username}','${user.nombre}','${user.numero}','${user.token}')";

    await db.rawInsert(sql);
  }

  Future<User> getUser() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The menu.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM Users');

    final result = List.generate(maps.length, (i) {
      return User(
          username: maps[i]['username'],
          nombre: maps[i]['nombre'],
          token: maps[i]['token'],
          numero: maps[i]['numero']);
    });

    return result.length > 0 ? result[0] : new User();
  }

  Future<void> deteteUser() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The menu.

    await db.rawQuery('DELETE FROM Users');
  }
}
