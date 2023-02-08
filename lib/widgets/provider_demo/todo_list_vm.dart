import 'package:flutter/material.dart';

class TodoListItemModel {
  bool isComplete = false;
  String displayText;
  TodoListItemModel(this.isComplete, this.displayText);
}

class TodoListModel extends ChangeNotifier {
  List<TodoListItemModel> todoListItems = [];

  Future<void> fetchTodoListItems() async {
    Future.delayed(const Duration(seconds: 1));
    todoListItems = [
      TodoListItemModel(false, 'clean bathrooms'),
      TodoListItemModel(false, 'buy groceries'),
      TodoListItemModel(false, 'update todo list'),
      TodoListItemModel(false, 'mop floors'),
      TodoListItemModel(false, 'car wash'),
      TodoListItemModel(false, 'get hair cut'),
    ];
    notifyListeners();
  }

  updateTodo(TodoListItemModel todoListItemModel) {
    notifyListeners();
  }
}
