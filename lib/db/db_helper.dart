import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'student.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            rollNo TEXT,
            course TEXT,
            email TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }
  
// UPDATE
Future<int> updateStudent(Student student) async {
  final db = await database;
  return await db.update(
    'students',
    student.toMap(),
    where: 'id = ?',
    whereArgs: [student.id],
  );
}

  // INSERT
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }
  // SEARCH
Future<List<Student>> searchStudents(String keyword) async {
  final db = await database;

  final result = await db.query(
    'students',
    where: '''
      name LIKE ? OR
      rollNo LIKE ?
    ''',
    whereArgs: ['%$keyword%', '%$keyword%'],
  );

  return result.map((e) => Student(
  id: e['id'] as int,
  name: e['name'] as String,
  rollNo: e['rollNo'] as String,
  course: e['course'] as String,
  email: e['email'] as String,
  phone: e['phone'] as String,
)).toList();

}

  // READ
  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('students');

    return result.map((e) => Student(
      id: e['id'],
      name: e['name'],
      rollNo: e['rollNo'],
      course: e['course'],
      email: e['email'],
      phone: e['phone'],
    )).toList();
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
