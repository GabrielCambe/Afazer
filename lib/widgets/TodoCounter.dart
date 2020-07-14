import 'package:afazer/models/item.dart';
import 'package:flutter/material.dart';

class TodoCounter extends StatelessWidget {
  TodoItem item;

  TodoCounter(TodoItem item) {
    this.item = item;
  }

  int getDoneCount(List<TodoItem> list) {
    var iterator = list.iterator;
    int count = 0;
    while (iterator.moveNext()) {
      if (iterator.current.done == true) {
        count = count + 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.getDoneCount(this.item.subtasks).toString() + '/' +
          this.item.subtasks.length.toString()),
    );
  }
}