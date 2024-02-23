import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/global/modals/todo_item.dart';

//Shared Preferences is a simple and efficient way to store small amounts of data
// while SQLite is useful for storing large amounts of structured data.
class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'todo_items';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // Get the path for storing the database
    String path = await getDatabasesPath();
    // Set the path for the database
    path = join(path, 'todo_app.db');
    // Open the database (or create if it doesn't exist)
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            type TEXT,
            completed INTEGER
          )
        ''');
      },
    );
  }
  //Add todo item to the database
  Future<int> insertTodoItem(TodoItem todoItem) async {
    Database db = await database;
    return await db.insert(tableName, todoItem.toMap());
  }
  //Update todo item from the database
  Future<int> updateTodoItem(TodoItem todoItem) async {
    Database db = await database;
    return await db.update(
      tableName,
      todoItem.toMap(),
      where: 'id = ?',
      whereArgs: [todoItem.id],
    );
  }
  //Delete todo item from the database
  Future<int> deleteTodoItem(int id) async {
    Database db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //Get all todo items from the database
  Future<List<TodoItem>> getTodoItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return TodoItem.fromMap(maps[index]);
    });
  }
}
