import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'ClientModel.dart';
import 'clases/usuario.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;
  Database _database2;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future<Database> get database2 async {
    if (_database2 != null) return _database2;
    // if _database is null we instantiate it
    _database2 = await initDB2();
    return _database2;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "blocked BIT"
          ")");
      print("init2onfinre");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,first_name,last_name,blocked)"
        " VALUES (?,?,?,?)",
        [id, newClient.firstName, newClient.lastName, newClient.blocked]);
    return raw;
  }

  blockOrUnblock(Client client) async {
    final db = await database;
    Client blocked = Client(
        id: client.id,
        firstName: client.firstName,
        lastName: client.lastName,
        blocked: !client.blocked);
    var res = await db.update("Client", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return res;
  }

  updateClient(Client newClient) async {
    final db = await database;
    var res = await db.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getBlockedClients() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);

    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    print("zzzzzzzz ${list[0].firstName} ]");
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Client");
  }

  blockOrUnblock2(User user) async {
    final db = await database2;
    User blocked = User(
        id: user.id,
        nombre: user.nombre,
        tier1: user.tier1,
        tier2: user.tier2,
        tier3: user.tier3,
        puntaje: user.puntaje,
        reward: user.reward,
        actividad: !user.actividad,
        tierActual: user.tierActual,
        Fechacreacion: user.Fechacreacion,
        Fechaedicion: user.Fechaedicion);
    var res = await db
        .update("User", blocked.toMap(), where: "id = ?", whereArgs: [user.id]);
    return res;
  }

  initDB2() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB2.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "id INTEGER PRIMARY KEY,"
          "Nombre TEXT,"
          "tier1 INTEGER,"
          "tier2 INTEGER,"
          "tier3 INTEGER,"
          "puntaje INTEGER,"
          "reward INTEGER,"
          "activo BIT,"
          "tieractual TEXT,"
          "fechadeedicion DATETIME,"
          "fechacreacion DATETIME"
          ")");
      print("init2onfinre!!");
    });
  }

  Future<List<User>> getAllClients2() async {
    final db = await database2;
    var res = await db.query("User");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    print("zzzzzzzz ${list[0].actividad}   list[]");
    getAllClients();
    return list;
  }

  deleteClient2(int id) async {
    final db = await database2;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  newUser(User newClient) async {
    final db = await database2;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into User (id,Nombre,tier1,tier2,tier3,puntaje,reward,activo,tieractual,fechadeedicion,fechacreacion)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          id,
          newClient.nombre,
          newClient.tier1,
          newClient.tier2,
          newClient.tier3,
          0,
          0,
          true,
          newClient.tierActual,
          "${DateTime.now()}",
          "${DateTime.now()}"
        ]);
    return raw;
  }

  editUser(User newClient) async {
    final db = await database2;
    var raw = await db.rawUpdate(
        "UPDATE User SET  Nombre = ?,tier1 = ?,tier2 = ?,tier3 = ?,puntaje  = ?,reward = ?,activo  = ?,tieractual = ?,fechadeedicion = ? WHERE id = ?",
        [
          newClient.nombre,
          newClient.tier1,
          newClient.tier2,
          newClient.tier3,
          newClient.puntaje,
          newClient.reward,
          newClient.actividad,
          newClient.tierActual,
          "${DateTime.now()}",
          newClient.id
        ]);
    return raw;
  }

  editUsersinmodificarfecha(User newClient) async {
    final db = await database2;
    var raw = await db.rawUpdate(
        "UPDATE User SET  Nombre = ?,tier1 = ?,tier2 = ?,tier3 = ?,puntaje  = ?,reward = ?,activo  = ?,tieractual = ? WHERE id = ?",
        [
          newClient.nombre,
          newClient.tier1,
          newClient.tier2,
          newClient.tier3,
          newClient.puntaje,
          newClient.reward,
          newClient.actividad,
          newClient.tierActual,
          newClient.id
        ]);
    return raw;
  }
}
