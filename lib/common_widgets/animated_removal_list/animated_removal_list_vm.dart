import 'package:flutter/material.dart';

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
    required this.removedItemBuilder,
    Iterable<TDataItem>? dataItems,
  }) : dataItems = List<TDataItem>.from(dataItems ?? <TDataItem>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder<TDataItem> removedItemBuilder;
  final List<TDataItem> dataItems;

  SliverAnimatedListState get _sliverAnimatedListState => listKey.currentState!;

  void insert(int index, TDataItem item) {
    dataItems.insert(index, item);
    _sliverAnimatedListState.insertItem(index);
  }

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

  TDataItem operator [](int index) => dataItems[index];

  int indexOf(TDataItem item) => dataItems.indexOf(item);
}