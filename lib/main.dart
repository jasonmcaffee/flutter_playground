import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    setState(() {
      final indexToRemove = 1;
      final item = items.removeAt(indexToRemove);
      listKey.currentState!.removeItem(
        indexToRemove,
            (context, animation) => _buildItem(item, animation),
      );
      print("remove: $items");
    });
  }

  Widget _buildItem(ItemModel item, Animation<double> animation) {
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
  late int id2;

  @override
  void initState() {
    print('init state called for widget.item.id ${widget.item.id}');
    super.initState();
    // id2 = Random().nextInt(1000);
    id2 = widget.item.id;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     child: ListTile(
  //       title: Text("${widget.item.id} - $id2"),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          setState((){
            id2 = 0;
          });
        },
        child: Card(
          child: ListTile(
          title: Text("${widget.item.id} - $id2"),
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


// import 'package:flutter/material.dart';
// import 'package:flutter_playground/widgets/SliverAnimatedListFromFlutterDev.dart';
// import 'package:flutter_playground/widgets/discovered_accounts/discovered_accounts.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.primaries.first,
//       ),
//       home: const MyHomePage(title: 'Flutter Playground'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Main build called');
//     Size size = MediaQuery.of(context).size;
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Animated List',
//             ),
//             const SizedBox(
//               width: 500,
//               height: 500,
//               child: DiscoveredAccounts(),
//               // child: SliverAnimatedListSample(),
//             ),
//             // const SliverAnimatedListSample(),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
