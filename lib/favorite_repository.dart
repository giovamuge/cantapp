import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String favoriteDbName = 'favorite_database.db';
final String favoriteTable = 'favorites';

class FavoriteRepository {
  // get and instance database
  Future<Database> get database async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), favoriteDbName),
      // When the database is first created, create a table to store songs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE favorites(id INTEGER PRIMARY KEY, uid TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

// Define a function that inserts songs into the database
  Future<void> add(String uid) async {
    // Get a reference to the database.
    final Database db = await database;

    final Favorite fav = new Favorite(uid: uid);

    // Insert the song into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same song is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      favoriteTable,
      fav.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> remove(String uid) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the song from the Database.
    await db.delete(
      favoriteTable,
      // Use a `where` clause to delete a specific song.
      where: "uid = ?",
      // Pass the song's id as a whereArg to prevent SQL injection.
      whereArgs: [uid],
    );
  }

  Future<bool> exist(String uid) async {
    // Get a reference to the database.
    final db = await database;

    // Check the song from the Database.
    final result = await db.query(
      favoriteTable, columns: ['uid'],
      // Use a `where` clause to delete a specific song.
      where: "uid = ?",
      // Pass the song's id as a whereArg to prevent SQL injection.
      whereArgs: [uid],
    );

    return result.isNotEmpty;
  }

  Future<List<Favorite>> favorites() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(favoriteTable);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) => Favorite(uid: maps[i]['uid']));
  }
}

// Update the song class to include a `toMap` method.
class Favorite {
  // final int id;
  final String uid;

  Favorite({/*this.id,*/ this.uid});

  // Convert a song into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {/*'id': id,*/ 'uid': uid};
  }
}
