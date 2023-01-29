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
  // late ListModel<TDataItem> _listModel;

  //no constructor, as we are not allowed to pass constructor params.  everything must be done in initState

  @override
  void initState() {
    super.initState();
    // _listModel = widget.listModel;
  }

  //Called on by SliverAnimatedList's itemBuilder, which is used to build out its widget items when its state is changed by _listModel.listKey.currentState.insertItem
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    final dataItem = widget.listModel[index];
    return widget.buildItem(context, dataItem, animation, index, ()=> _removeItemAndBuildRemovedItem(context, index, animation, dataItem));
  }

  //called on by the ListItem widget, which is passed a reference to this function so it can call when it is ready for the
  //item to be removed from the list.
  //note: don't use index as it's typically outdated, as it's from a closure and becomes stale when other items are removed
  _removeItemAndBuildRemovedItem(BuildContext context, int likelyIncorrectIndex, Animation<double> animation, TDataItem dataItem){
    final indexToRemove = widget.listModel.indexOf(dataItem);
    print('_removeItemAndBuildRemovedItem removing $indexToRemove original index: $likelyIncorrectIndex');
    widget.listModel.removeAt(indexToRemove, (BuildContext context, TDataItem dataItem, Animation<double> animation, int index) {
      return widget.buildRemovedItem(context, dataItem, animation, index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            createSliverAppBar(),
            SliverAnimatedList(
              key: widget.listModel.listKey,
              initialItemCount: widget.listModel.length,
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
      actions: <Widget>[],
    );
  }
}


