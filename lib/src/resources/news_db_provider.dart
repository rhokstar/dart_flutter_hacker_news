import 'package:sqflite/sqflite.dart'; // Cannot test because you cannot create DB in local...
import 'package:path_provider/path_provider.dart';

// File system
import 'dart:io';
import 'package:path/path.dart';

import 'dart:async';
import '../models/item_model.dart';

import './repository.dart';

// Init
// Abstract class Source and Cache implements here
class NewsDBProvider implements Source, Cache {
  // Create instance variable for database from sqflite
  // Link to DB
  Database db;

  // Call DB Init
  NewsDBProvider() {
    init();
  }

  // You can implement an abstract class qualifier but herein lies the problem is the functionality of the function
  @override
  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    return null;
  }

  // Init DB here
  // Cannot use asynchronus logic in a contructor, so use init instead
  // There's no 'return' statement, use void.
  void init() async {
    // PathProvder module. Works with mobile device directories. Returns a reference to a folder on the device.
    // dart:io = Directory documentsDirectory, a folder reference
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Constructs the file path i.e. /directory/items.db
    // If getting null values, rename the DB name
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(
      path, // Create a DB on device or just open the DB if it exists.
      version: 1, // Assign a version. If schema changes, version up
      // Inital setup of DB if this is the first time app is opened
      onCreate: (Database newDb, int verson) {
        // SQL statements here using triple quotes at start and end
        // SQLITE and Dart have differnt type systems so there's some translation involved
        // Notice conversion of values for 'dead'
        newDb.execute("""
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        """);
      },
    );
  }

  // Fetch
  // If there's a 'return' statement, null can also be returned
  Future<ItemModel> fetchItem(int id) async {
    // Query the DB
    // Getting back a list of maps (key, value, dynamic, etc.)
    final maps = await db.query(
      // DB name
      "Items",
      // Get all columns. You can also get one column as well.
      columns: null,
      // Get the ID
      where: "id = ?",
      // Also prevents SQL injection attacks by sanitizing arguments
      whereArgs: [id],
    );

    // Look at maps and check if there's at least 1 record
    if (maps.length > 0) {
      // Take first map out of the list of maps
      // Will also convert specific values to conform with ItemModel
      return ItemModel.fromDb(maps.first);
    }

    // If no results, null
    return null;
  }

  // Async not required
  // Insert item into database. Item needs to be a converted into SQL compliant types.
  // Annotate: Future resolves with an int. See db.insert.
  Future<int> addItem(ItemModel item) {
    // If same ID exists, ignore writing to DB
    return db.insert("Items", item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}

// Make one connection to DB available.
final newsDBProvider = NewsDBProvider();
