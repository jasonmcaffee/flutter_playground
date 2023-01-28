import 'package:flutter/material.dart';


//function signature used for creating a new item to represent the item being removed from the list.
//creating a new widget instance to render how the item looks as it's being removed allows
//us the provider of the RemovedItemBuilder function to perform animations.
//It seems like an odd approach, but that's how Flutter documentation suggests doing it.
typedef RemovedItemBuilder<TDataItem> = Widget Function(
    TDataItem item, BuildContext context, Animation<double> animation);

// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<TDataItem> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder, //it's odd that this widget creating function is in this data class, but this is how Flutter documentation suggests doing it.  An event would be a better approach
    Iterable<TDataItem>? dataItems,
  }) : dataItems = List<TDataItem>.from(dataItems ?? <TDataItem>[]);

  //required for us to access the SliverAnimatedListState, which holds the UI representation of our data list, and is needed to update the UI.
  final GlobalKey<SliverAnimatedListState> listKey;
  //function to be called which returns the widget that should be displayed as the item is being removed off of the list
  final RemovedItemBuilder<TDataItem> removedItemBuilder;
  //underlying data structure
  final List<TDataItem> dataItems;

  //state of the sliverAnimatedList which is used to remove items from the UI.
  SliverAnimatedListState get _sliverAnimatedListState => listKey.currentState!;

  //insert an item into the dataItems and corresponding sliverAnimatedListState
  void insert(int index, TDataItem item) {
    dataItems.insert(index, item);
    _sliverAnimatedListState.insertItem(index);
  }

  //remove the item at the specified index from the dataItems and sliverAnimatedListState
  //calls removedItemBuilder function so that the UI can do animations and render what the item
  //should look like as it's being removed from the list.
  //todo: slideAnimation
  TDataItem removeAt(int index) {
    final TDataItem removedDataItem = dataItems.removeAt(index);
    final removedItemDisplayNumber = removedDataItem.hashCode;
    print('removed item index: $index removedItemDisplayNumber: ${removedItemDisplayNumber}');
    if (removedDataItem != null) {
      _sliverAnimatedListState.removeItem(
          index,
              (BuildContext context, Animation<double> animation){
            print('animatedList removeItem builder called index: $index');
            return removedItemBuilder(removedDataItem, context, animation);
          }
      );
    }
    return removedDataItem;
  }

  int get length => dataItems.length;

  //index operator to return the dataItem at the specified index.  e.g. ListModel[1]
  TDataItem operator [](int index) => dataItems[index];

  int indexOf(TDataItem item) => dataItems.indexOf(item);
}

// class ListDataItem {
//   late String displayName;
//   ListDataItem({
//     required this.displayName
//   });
// }
//
// /// VM responsible for maintain list state, including list data items and associated SliverAnimatedListState
// class AnimatedRemovalListVM extends ChangeNotifier{
//   //todo: ListDataItem should be a generic
//   late final List<ListDataItem> listDataItems;
//
//   //in order to modify the SliverAnimatedList, we must expose a key to its state
//   final GlobalKey<SliverAnimatedListState> listKey = GlobalKey<SliverAnimatedListState>();
//
//   //constructor
//   AnimatedRemovalListVM({
//     required listDataItems,
//   });
//
// }