// Displays its integer item as 'Item N' on a Card whose color is based on
// the item's value.
//
// The card turns gray when [selected] is true. This widget's height
// is based on the [animation] parameter. It varies as the animation value
// transitions from 0.0 to 1.0.
import 'package:flutter/material.dart';

//todo: this should accept a child widget. and shouldn't need TDataItem ...
class RemovableListItem<TDataItem> extends StatelessWidget {
  const RemovableListItem({
    super.key,
    this.onRemove,
    this.selected = false,
    required this.animation,
    required this.displayItemNumber,//todo: remove this
    required this.dataItem,
  }) : assert(displayItemNumber >= 0);

  final Animation<double> animation;
  final VoidCallback? onRemove;
  final int displayItemNumber;
  final bool selected;
  final TDataItem dataItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        right: 2.0,
        top: 2.0,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          onTap: onRemove,
          child: SizedBox(
            height: 80.0,
            child: Card(
              color:  Colors.black12,
              child: Center(
                child: Text(
                  'Item $displayItemNumber',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}