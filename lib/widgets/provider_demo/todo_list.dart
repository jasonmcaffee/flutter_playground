import 'package:flutter/material.dart';
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
    final todoListModel = Provider.of<TodoListModel>(context);
    return AnimatedList(
        initialItemCount: todoListModel.todoListItems.length,
        itemBuilder: (context, index, _) {
          final todoListItem = todoListModel.todoListItems[index];
          return Text('${todoListItem.displayText}');
        });
  }
}
