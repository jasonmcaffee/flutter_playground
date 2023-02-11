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
    //DONT use either Provider.of or context.watch (same thing) here, as any notifyListeners will trigger a rebuild.
    // final todoListModel = Provider.of<TodoListModel>(context);
    // final todoListModel = context.watch<TodoListModel>();

    //instead, either listen for length change or for hasInitialLoadOccurred.
    //avoiding length here in case we want to remove items without rebuilding everything.
    // final length = context.select<TodoListModel, int>(
    //     (todoListModel) => todoListModel.todoListItems.length);

    final hasInitialLoadOccurred = context.select<TodoListModel, bool>((model) => model.hasInitialLoadOccurred);
    print('hasInitialLoadOccurred: $hasInitialLoadOccurred');
    return AnimatedList(
        initialItemCount: context.read<TodoListModel>().todoListItems.length,
        // initialItemCount: length,
        itemBuilder: (context, index, _) {
          final todoListModel = context.read<TodoListModel>();
          final todoListItemModel = todoListModel.todoListItems[index];
          return TodoListItem(todoListItemModelId: todoListItemModel.id);
        });
  }
}
