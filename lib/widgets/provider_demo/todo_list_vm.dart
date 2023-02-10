import 'package:flutter/material.dart';

@immutable
class TodoListItemModel {
  int id;
  bool isComplete;
  String displayText;
  TodoListItemModel(this.id, this.isComplete, this.displayText);

  // @override
  // int get hashCode => id;
  //
  // @override
  // bool operator ==(Object other) {
  //   return false;
  //   // return other is TodoListItemModel && other.id == id;
  // }
}

class TodoListModel extends ChangeNotifier {
  List<TodoListItemModel> todoListItems = [];

  Future<void> fetchTodoListItems() async {
    Future.delayed(const Duration(seconds: 1));
    todoListItems = [
      TodoListItemModel(1, false, 'clean bathrooms'),
      TodoListItemModel(2, false, 'buy groceries'),
      TodoListItemModel(3, false, 'update todo list'),
      TodoListItemModel(4, false, 'mop floors'),
      TodoListItemModel(5, false, 'car wash'),
      TodoListItemModel(6, false, 'get hair cut'),
    ];
    notifyListeners();
  }

  TodoListItemModel getItemModelById(int id) {
    return todoListItems.firstWhere((element) => element.id == id);
  }

  //context.select requires that a new object be created so that the comparison of previous to new doesn't return true.
  updateTodo(TodoListItemModel todoListItemModel) {
    final index = todoListItems.indexOf(todoListItemModel);
    final newItem = TodoListItemModel(todoListItemModel.id,
        todoListItemModel.isComplete, todoListItemModel.displayText);
    todoListItems[index] = newItem;
    notifyListeners();
  }
}
