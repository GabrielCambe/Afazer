import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:afazer/models/item.dart';

Future<Database> load_database() async {
  Future<Database> db = openDatabase(
    join(await getDatabasesPath(), 'todoList_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE TodoList (id TEXT, points INTEGER, parent TEXT, done INTEGER, key TEXT,  PRIMARY KEY(key))",
      );
    },
    version: 1,
    onOpen: (db) async {
      //Database database = await db;
      print('Opened database');
    }
  );
  print('load_database()');
  return db;
}

Future<List<Map<String, dynamic>>> read_from_database(Future<Database> database, String parent) async{
  Database db = await database;
  var result = await db.rawQuery('SELECT * FROM TodoList WHERE parent=?', [parent]);
  print("read_from_database");
  return result.toList();
}

Future<void> save_to_database(Future<Database> database, List<Map<String, dynamic>> mapList,) async {
  Database db = await database;
  var mapListIterator = mapList.iterator;
  while(mapListIterator.moveNext()){
    var res = await db.rawInsert(
        'INSERT or REPLACE INTO TodoList'
            '(id, points, parent, done, key)'
            'VALUES(?, ?, ?, ?, ?)', [mapListIterator.current['id'], mapListIterator.current['points'], mapListIterator.current['parent'], mapListIterator.current['done'], mapListIterator.current['id'] + mapListIterator.current['parent']]
    );
  }
  print("save_to_database");
}

Future<void> remove_from_database(Future<Database> database, TodoItem item) async{
  Database db = await database;
  var res = await db.rawDelete('DELETE FROM TodoList WHERE id=? OR parent=?', [item.id, item.id]);
  print("remove_from_database");
}

List<Map<String, dynamic>> get_map_from_list(List<TodoItem> todoList, String parent){
  List<Map<String, dynamic>> map = [];
  if(todoList.isNotEmpty){
    var todoIterator = todoList.iterator;
    while(todoIterator.moveNext()){
      if(todoIterator.current != null){
        map.add(todoIterator.current.toMap(parent));
      }
    }
  }
  print("get_map_from_list");
  return map;
}

List<TodoItem> get_list_from_map(List<Map<String, dynamic>> map){
  List<TodoItem> todoList = [];

  if(map.isEmpty){
    return todoList;
  }

  for (Map<String, dynamic> item in map) {
    List<TodoItem> subtasks = [];
    todoList.add(
        TodoItem(
            id: item['id'],
            points: item['points'],
            subtasks: subtasks,
            done: item['done'] == 1 ? true : false
        )
    );
  }

  print('get_list_from_map');

  return todoList;
}