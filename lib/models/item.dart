class TodoItem {
  String id;
  bool done;
  int points;
  List<TodoItem> subtasks;
  TodoItem({this.id, this.points, this.subtasks, this.done});

  Map<String, dynamic> toMap(String parent) {
    Map<String, dynamic> mapItem = {
      'id': this.id,
      'points': this.points,
      'parent': parent,
      'done': this.done == true ? 1 : 0
    };

    return mapItem;
  }
}