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
    Iterable<TDataItem>? dataItems,
  }) : dataItems = List<TDataItem>.from(dataItems ?? <TDataItem>[]);

  //required for us to access the SliverAnimatedListState, which holds the UI representation of our data list, and is needed to update the UI.
  final GlobalKey<SliverAnimatedListState> listKey;
  //underlying data structure
  final List<TDataItem> dataItems;

  //state of the sliverAnimatedList which is used to remove items from the UI.
  // SliverAnimatedListState get _sliverAnimatedListState => listKey.currentState!;
  SliverAnimatedListState get _sliverAnimatedListState => listKey.currentState!;

  //insert an item into the dataItems and corresponding sliverAnimatedListState
  void insert(int index, TDataItem item) {
    dataItems.insert(index, item);
    _sliverAnimatedListState.insertItem(index);
  }

  void insertAtEnd(TDataItem item){
    final index = dataItems.length;
    dataItems.insert(index, item);
    _sliverAnimatedListState.insertItem(index);
  }

  void insertAll(List<TDataItem> dataItems){
    for(var dataItem in dataItems){
      insertAtEnd(dataItem);
    }
  }

  //remove the item at the specified index from the dataItems and sliverAnimatedListState
  //calls removedItemBuilder function so that the UI can do animations and render what the item
  //should look like as it's being removed from the list.
  //todo: slideAnimation
  TDataItem removeAt(int index, Widget Function(BuildContext context, TDataItem dataItem, Animation<double> animation, int index) buildRemovedItem) {
    final TDataItem removedDataItem = dataItems.removeAt(index);
    final removedItemDisplayNumber = removedDataItem.hashCode;
    print('removed item index: $index removedItemDisplayNumber: ${removedItemDisplayNumber}');
    if (removedDataItem != null) {
      _sliverAnimatedListState.removeItem(
          index,
              (BuildContext context, Animation<double> animation){
            print('animatedList removeItem builder called index: $index');
            return buildRemovedItem(context, removedDataItem, animation, index);
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