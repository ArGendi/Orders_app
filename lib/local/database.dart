import 'package:notes/models/client.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'notes.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE clients(name TEXT, armTall TEXT, waistTall TEXT, jeepTall TEXT, chestRound TEXT, waistRound TEXT, sidesRound TEXT, shouldersTall TEXT)",
        );
      },
    );
  }

  // insert data
  Future insertClient(Client client) async {
    final Database db = await initializedDB();
    await db.insert('clients', client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // retrieve data
  Future<List<Client>> retrieveClients() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('clients');
    return queryResult.map((e) => Client.fromMap(e)).toList();
  }

  // delete user
  Future<void> deleteClient(String name) async {
    final db = await initializedDB();
    await db.delete(
    'clients',
    where: "name = ?",
    whereArgs: [name],
    );
  }

  Future<void> updateDog(Client client) async {
  final db = await initializedDB();
  await db.update(
    'clients',
    client.toMap(),
    where: 'name = ?',
    whereArgs: [client.name],
  );
}
}
