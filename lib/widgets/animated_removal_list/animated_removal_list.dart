import 'package:flutter/material.dart';

import 'list_item.dart';

//resources
//https://api.flutter.dev/flutter/widgets/SliverAnimatedList-class.html

class SliverAnimatedListSample extends StatefulWidget {
  const SliverAnimatedListSample({super.key});

  @override
  State<SliverAnimatedListSample> createState() =>
      _SliverAnimatedListSampleState();
}

class _SliverAnimatedListSampleState extends State<SliverAnimatedListSample> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late ListModel<int> _listModel;
  // int? _selectedItem;
  late int
      _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _listModel = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      displayItemNumber: _listModel[index],
      // selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          // _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  /// The builder function used to build items that have been removed.
  ///
  /// Used to build an item after it has been removed from the list. This method
  /// is needed because a removed item remains visible until its animation has
  /// completed (even though it's gone as far this ListModel is concerned). The
  /// widget will be used by the [AnimatedListState.removeItem] method's
  /// [AnimatedRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      int displayItemNumber, BuildContext context, Animation<double> animation) {
    print('buildRemovedItem called for displayItemNumber: $displayItemNumber');
    return CardItem(
      animation: animation,
      displayItemNumber: displayItemNumber,
    );
  }

  // insert at the end of the list
  void _insert() {
    final int index = _listModel.length;
    _listModel.insert(index, _nextItem++);
  }

  // Remove the selected item from the list model.
  void _remove() {
    final indexToRemove = _listModel.length - 1;
    _listModel.removeAt(indexToRemove);
    // _listKey.currentState?.removeItem(indexToRemove, (context, animation){
    //   return _buildRemovedItem(indexToRemove, context, animation);
    // });
    // if (_selectedItem != null) {
    //   _list.removeAt(_list.length);
    //   setState(() {
    //     _selectedItem = null;
    //   });
    // } else {
    //   _scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
    //     content: Text(
    //       'Select an item to remove from the list.',
    //       style: TextStyle(fontSize: 20),
    //     ),
    //   ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            createSliverAppBar(),
            SliverAnimatedList(
              key: _listKey,
              initialItemCount: _listModel.length,
              itemBuilder: _buildItem,
            ),
          ],
        )
    );
  }

  Widget createSliverAppBar(){
    return SliverAppBar(
      title: const Text(
        'SliverAnimatedList',
        style: TextStyle(fontSize: 30),
      ),
      expandedHeight: 60,
      centerTitle: true,
      backgroundColor: Colors.amber[900],
      leading: IconButton(
        icon: const Icon(Icons.add_circle),
        onPressed: _insert,
        tooltip: 'Insert a new item.',
        iconSize: 32,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: _remove,
          tooltip: 'Remove the selected item.',
          iconSize: 32,
        ),
      ],
    );
  }
}

typedef RemovedItemBuilder = Widget Function(
    int item, BuildContext context, Animation<double> animation);

// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    final removedItemDisplayNumber = removedItem.hashCode;
    print('removed item index: $index removedItemDisplayNumber: ${removedItemDisplayNumber}');
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation){
          print('animatedList removeItem builder called index: $index');
          return removedItemBuilder(removedItemDisplayNumber, context, animation);
        }

      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

