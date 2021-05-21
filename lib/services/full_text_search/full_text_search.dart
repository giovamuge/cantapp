import 'dart:core';

import 'package:cantapp/common/shared.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../song/song_model.dart';
import '../firestore_path.dart';
import 'bm25.dart';

class FullTextSearch {
  FullTextSearch._();

  static final FullTextSearch instance = FullTextSearch._();
  static Database _database;

  static final String table = 'songs';

  Future<Database> get database async {
    if (_database == null) _database = await initialization();
    return _database;
  }

  Future<Database> initialization() async {
    // Open the database and store the reference.
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'search_songs_database.db'),
      // When the database is first created, create a table to store songs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
            "CREATE VIRTUAL TABLE $table USING fts4(title, artist, id UNINDEXED)");
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts songs into the database
  Future<void> insertSong(SongLight song) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the song into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same song is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSong(SongLight song) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given song.
    await db.update(
      table,
      song.toMap(),
      // Ensure that the song has a matching id.
      where: "id = ?",
      // Pass the song's id as a whereArg to prevent SQL injection.
      whereArgs: [song.id],
    );
  }

  Future<void> insertSongs(List<SongLight> songs) async {
    final db = await database;
    final batch = db.batch();
    songs.forEach((song) => batch.insert(table, song.toMap()));
    batch.commit();
  }

  Future<void> updateSongs(List<SongLight> songs) async {
    final db = await database;
    final batch = db.batch();
    songs.forEach((song) => batch.update(table, song.toMap()));
    batch.commit(continueOnError: true);
  }

  Future<void> deleteSongs() async {
    final Database db = await database;
    db.execute("DELETE FROM $table");
  }

  Future<bool> anySongs() async {
    return await countSongs() > 0;
  }

  Future<int> countSongs() async {
    final Database db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(result);
  }

  Future<List<SongResult>> search(String text) async {
    final Database db = await database;
    var rows = await db.query(
      table,
      columns: [
        'title',
        'artist',
        'id',
        'matchinfo($table, \'$bm25FormatString\') as info',
      ],
      where: '$table MATCH ?',
      whereArgs: ['*$text*'],
    );

    if (rows.length == 0) {
      print('no such results');
      return [];
    }

    rows = rows.map((row) {
      return {
        'title': row['title'],
        'artist': row['artist'],
        'id': row['id'],
        'rank': bm25(row['info']),
      };
    }).toList();

    rows.sort((a, b) => (a['rank'] as double).compareTo(b['rank']));

    final List<SongResult> result = rows
        .take(15)
        .map((e) => SongResult(
            title: e['title'], artist: e['artist'], objectID: e['id']))
        .toList();

    print(result.map((e) => e.title).join(', '));

    return result;
  }

  Future<void> all() async {
    final Database db = await database;
    final result = await db.rawQuery('SELECT * FROM $table');
    print('songs lenght: ${result.length}');
  }

  Future<void> fetchFromFirestore(String uid, String version) async {
    FirebaseFirestore.instance
        .doc(FirestorePath.songsIndex(version))
        .get()
        .then(
      (value) async {
        final index = value.data()["index"];
        final songs = List.from(index)
            .map((maps) => SongLight.fromJsonIndexSongs(maps))
            .toList();
        final Timestamp updatedAt = value.data()["updatedAt"];
        final shared = Shared();
        final latestUpdate = await shared.getSongsIndexUpdatedAt();
        final updatedAtDateTime = updatedAt.toDate();
        final bool needUpdated = latestUpdate?.isBefore(updatedAtDateTime);

        if (needUpdated != null && !needUpdated) return;
        if (await countSongs() > 0) await deleteSongs();

        // inserisco tutte le canzoni
        FullTextSearch.instance.insertSongs(songs);
        await shared.setSongsIndexUpdatedAt(DateTime.now());
      },
    );
  }

  Future close() async => instance.close();

  /** Some Examples */

  // Future<void> selectAll() async {
  //   final Database db = await database;

  //   // final cursor = await db.rawQuery(
  //   //     "SELECT title, artist, matchinfo(songs, 'pcnalx') as info FROM songs WHERE songs MATCH 'pro*'");
  //   // final cursor =
  //   //     await db.rawQuery("SELECT * FROM songs WHERE title MATCH 'pro*'");

  //   // final matchinfo = cursor.getBlob(3).toIntArray()

  //   final cursor = await db.query(
  //     table,
  //     columns: [
  //       'title',
  //       'artist',
  //       'matchinfo(songs, \'pcnalx\') as info',
  //     ],
  //     where: '$table MATCH ?',
  //     whereArgs: ['prova'],
  //   );

  //   if (cursor.isNotEmpty) {
  //     List<SongLight> songs = [];
  //     cursor.forEach((element) {
  //       // Read and prepare matchinfo blob
  //       var matchinfo = element["info"];

  //       // Calculate score based on matchinfo values
  //       // Here I'm only using the first column (title) to calculate the score
  //       final double scoreData = score(matchinfo: matchinfo, column: 0);

  //       final song =
  //           SongLight(title: element["title"], artist: element["title"]);

  //       songs.add(song);
  //     });
  //   }

  //   // return movies.sortedByDescending { it.score }

  //   print(cursor);
  // }

  // example() async {
  //   final table = 'bm25_test';

  //   final db = await openDatabase(join(await getDatabasesPath(), 'example.db'),
  //       version: 1, onCreate: (Database db, int version) async {
  //     await db.execute('CREATE VIRTUAL TABLE $table USING fts4(name)');
  //   });

  //   await db.insert(table, {'rowid': 1, 'name': 'Sam Rivers'},
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   await db.insert(table, {'rowid': 2, 'name': 'Samwise "Sam" Gamgee'},
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   await db.insert(table, {'rowid': 3, 'name': 'Sam'},
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   await db.insert(table, {'rowid': 4, 'name': 'Sam Seaborn'},
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   await db.insert(table, {'rowid': 5, 'name': 'Samwell "Sam" Tarly'},
  //       conflictAlgorithm: ConflictAlgorithm.replace);

  //   print(names);

  //   await db.close();
  // }
}
