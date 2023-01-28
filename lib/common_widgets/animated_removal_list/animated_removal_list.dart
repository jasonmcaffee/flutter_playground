import 'package:flutter/material.dart';

import 'animated_removal_list_vm.dart';
import 'list_item.dart';

//resources
//https://api.flutter.dev/flutter/widgets/SliverAnimatedList-class.html

class AnimatedRemovalList extends StatefulWidget {
  const AnimatedRemovalList({super.key});

  @override
  State<AnimatedRemovalList> createState() =>
      _AnimatedRemovalListState();
}

class _AnimatedRemovalListState extends State<AnimatedRemovalList> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  //responsible for wrapping the underlying data model and SliverListAnimatedState model, in order to keep them both in sync.
  late ListModel<int> _listModel;
  // int? _selectedItem;
  late int
      _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _listModel = ListModel<int>(
      listKey: _listKey,
      dataItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return RemovableListItem(
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
    return RemovableListItem(
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


