import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/provider_demo/todo_list_vm.dart';
import 'package:provider/provider.dart';

class TodoListItem extends StatelessWidget {
  final TodoListItemModel todoListItemModel;
  const TodoListItem({Key? key, required this.todoListItemModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building todo: ${todoListItemModel.displayText}');
    return Row(
      children: [
        Expanded(child: Text('${todoListItemModel.displayText}')),
        Expanded(
            child: Checkbox(
          value: todoListItemModel.isComplete,
          onChanged: (bool? value) {
            todoListItemModel.isComplete = value!;
            Provider.of<TodoListModel>(context, listen: false)
                .updateTodo(todoListItemModel);
          },
        ))
      ],
    );
  }
}
