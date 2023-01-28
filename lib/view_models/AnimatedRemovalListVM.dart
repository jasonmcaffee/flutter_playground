import 'package:flutter/material.dart';

class ListDataItem {
  late String displayName;
  ListDataItem({
    required this.displayName
  });
}

/// VM responsible for maintain list state, including list data items and associated SliverAnimatedListState
class AnimatedRemovalListVM extends ChangeNotifier{
  //todo: ListDataItem should be a generic
  late final List<ListDataItem> listDataItems;

  //in order to modify the SliverAnimatedList, we must expose a key to its state
  final GlobalKey<SliverAnimatedListState> listKey = GlobalKey<SliverAnimatedListState>();

  //constructor
  AnimatedRemovalListVM({
    required listDataItems,
  });

}