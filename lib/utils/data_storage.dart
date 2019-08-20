import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/item_Class.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  DatabaseHelper.internal();

  final String tablename = "todotable";
  final String columnname = "itemname";
  final String columndate = "datecreated";
  final String columnid = "id";

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initdb();

    return _db;
  }

  initdb() async {
    Directory documentdirectory = await getApplicationDocumentsDirectory();

    String path = join(documentdirectory.path, "notodolist.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);

    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tablename($columnid INTEGER PRIMARY KEY,$columnname TEXT,$columndate TEXT)");
  }

  Future<int> saveuser(Items item) async {
    var dbClient = await db;

    int res = await dbClient.insert("$tablename", item.toMap());

    return res;
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;

    var result = await dbClient.rawQuery("SELECT * FROM $tablename");

    return result.toList();
  }

  Future<int> count() async {
    var dbClient = await db;
    var result = Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tablename")
    );
    return result;
  }

  Future<Items> getSingleUser(int id) async {
    var dbClient = await db;

    var result = await dbClient.rawQuery(
        "SELECT * FROM $tablename WHERE $columnid= $id");

    return new Items.fromMap(result.first);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    var result = await dbClient.delete(tablename,
        where: "$columnid=?", whereArgs: [id]);

    return result;
  }

  Future<int> update(Items item) async{

    var dbClient= await db;

    return await dbClient.update(tablename, item.toMap(),
        where: "$columnid=?",whereArgs: [item.id]);

  }

  Future close()async{

    var dbClient= await db;
    dbClient.close();
  }
}
