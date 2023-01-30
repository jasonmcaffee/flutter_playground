import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedList1App extends StatelessWidget {
  const AnimatedList1App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimatedList Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AnimatedList Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final listKey = GlobalKey<AnimatedListState>();

  final List<ItemModel> items = [];

  @override
  Widget build(BuildContext context) {
    print('MyHomePageState build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedList(
        key: listKey,
        initialItemCount: items.length,
        itemBuilder: (context, index, animation) =>
            _buildItem(items[index], animation),
      ),
      floatingActionButton: Wrap(
        children: [
          FloatingActionButton(
            onPressed: _addItem,
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _removeItem,
            tooltip: 'Remove',
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }

  void _addItem() {
    // setState(() {
    //   final index = items.length;
    //   items.add(ItemModel(Random().nextInt(1000)));
    //   listKey.currentState!.insertItem(index);
    //   print("add: $items");
    // });
    final index = items.length;
    items.add(ItemModel(Random().nextInt(1000)));
    listKey.currentState!.insertItem(index);
    print("add: $items");
  }

  void _removeItem() {
    const indexToRemove = 1;
    final item = items.removeAt(indexToRemove);
    listKey.currentState!.removeItem(
      indexToRemove,
      (context, animation) => _buildItem(item, animation),
    );
  }

  Widget _buildItem(ItemModel item, Animation<double> animation) {
    print('_buildItem called');
    return SizeTransition(
      key: ObjectKey(item),
      sizeFactor: animation,
      child: ListItem(
        item: item,
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final ItemModel item;

  const ListItem({super.key, required this.item});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late bool isPressed;
  @override
  void initState() {
    print('init state called for widget.item.id ${widget.item.id}');
    super.initState();
    isPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isPressed = true;
          });
        },
        child: Card(
          color: isPressed ? Colors.green : Colors.grey,
          child: ListTile(
            title: Text("${widget.item.id}"),
          ),
        ));
  }
}

class ItemModel {
  final int id;

  ItemModel(this.id);

  @override
  String toString() {
    return id.toString();
  }
}
