import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/provider_demo/todo_list.dart';
import 'package:flutter_playground/widgets/provider_demo/todo_list_vm.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoListPageState();
}

//ChangeNotifierProvider of TodoListModel
class TodoListPageState extends State<TodoListPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel()..fetchTodoListItems(),
      child: const TodoList(),
    );
  }
}
