import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/provider_demo/todo_list_item.dart';
import 'package:flutter_playground/widgets/provider_demo/todo_list_vm.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final todoListModel = Provider.of<TodoListModel>(context);
    // final todoListModel = context.watch<TodoListModel>();
    final length = context.select<TodoListModel, int>(
        (todoListModel) => todoListModel.todoListItems.length);
    return AnimatedList(
        initialItemCount: length,
        itemBuilder: (context, index, _) {
          final todoListModel = context.read<TodoListModel>();
          final todoListItemModel = todoListModel.todoListItems[index];
          return TodoListItem(todoListItemModelId: todoListItemModel.id);
        });
  }
}
