import 'package:flutter/material.dart';

class TodoListItem {
  bool isComplete = false;
  String displayText;
  TodoListItem(this.isComplete, this.displayText);
}

class TodoListModel extends ChangeNotifier {
  List<TodoListItem> todoListItems = [];

  Future<void> fetchTodoListItems() async {
    Future.delayed(const Duration(seconds: 1));
    todoListItems = [
      TodoListItem(false, 'clean bathroom'),
    ];
    notifyListeners();
  }
}
