import 'package:flutter/material.dart';

import 'animated_removal_list_vm.dart';
import 'removal_list_item.dart';

//resources
//https://api.flutter.dev/flutter/widgets/SliverAnimatedList-class.html

//function signature for creating a new item
typedef BuildItem<TDataItem> = Widget Function (BuildContext context, TDataItem dataItem, Animation<double> animation, int index, VoidCallback removeItemFromListCallback);
typedef RemoveItem<TDataItem> = Widget Function (BuildContext context, TDataItem dataItem, Animation<double> animation, int index);

class AnimatedRemovalList<TDataItem> extends StatefulWidget {
  //model for syncing sliverAnimatedState and dataItems.
  //is referenced by AnimatedRemovalListState during initState
  final ListModel<TDataItem> listModel;
  final BuildItem<TDataItem> buildItem;
  final RemoveItem<TDataItem> buildRemovedItem;
  //constructor
  const AnimatedRemovalList({
    super.key,
    required this.listModel,
    required this.buildItem,
    required this.buildRemovedItem,
  });

  //state
  //per flutter, don't pass any data here.  rather, reference the widget's property
  //https://dart-lang.github.io/linter/lints/no_logic_in_create_state.html
  //https://stackoverflow.com/questions/50287995/passing-data-to-statefulwidget-and-accessing-it-in-its-state-in-flutter
  @override
  State<AnimatedRemovalList> createState() =>
      _AnimatedRemovalListState<TDataItem>();
}


class _AnimatedRemovalListState<TDataItem> extends State<AnimatedRemovalList<TDataItem>> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //responsible for wrapping the underlying data model and SliverListAnimatedState model, in order to keep them both in sync.
  late ListModel<TDataItem> _listModel;

  //no constructor, as we are not allowed to pass constructor params.  everything must be done in initState

  @override
  void initState() {
    super.initState();
    _listModel = widget.listModel;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    final dataItem = _listModel[index];
    return widget.buildItem(context, dataItem, animation, index, ()=> _removeItem(context, index, animation));
  }

  Widget _removeItem(BuildContext context, int index, Animation<double> animation){
    final dataItem = _listModel[index];
    _listModel.removeAt(index);
    return widget.buildRemovedItem(context, dataItem, animation, index);
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
      dataItem: displayItemNumber,
      onRemove: (){
        _remove();
      },
    );
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
              key: _listModel.listKey,
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
        onPressed: (){},
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


