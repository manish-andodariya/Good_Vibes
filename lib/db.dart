import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> database;
main() async {
  database = openDatabase(join(await getDatabasesPath(), 'quote_database.db'),
      onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE dogs(id INTEGER PRIMARY KEY, text TEXT, author TEXT)",
    );
  });
}

Future<void> insertQuote(Quote quote) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. Also specify the
  // `conflictAlgorithm`. In this case, if the same dog is inserted
  // multiple times, it replaces the previous data.
  await db.insert(
    'quote',
    quote.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Quote>> quote() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('quote');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Quote(
      id: maps[i]['id'],
      text: maps[i]['text'],
      author: maps[i]['author'],
    );
  });

  Future<void> deleteQuote(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'quote',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

class Quote {
  final int id;
  final String text;
  final String author;

  Quote({this.id, this.text, this.author});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, text: $text, author: $author}';
  }
}
