import 'package:flutter/material.dart';

class DiscoveredAccountsListDataItem {
  final String displayText;
  DiscoveredAccountsListDataItem({
    required this.displayText,
  });
}

class DiscoveredAccountsListItem extends StatelessWidget{
  final DiscoveredAccountsListDataItem dataItem;
  final VoidCallback removeItemFromList;

  const DiscoveredAccountsListItem({Key? key, required this.dataItem, required this.removeItemFromList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(child:Text(
            'Item ${dataItem.displayText}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(child: IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: removeItemFromList,
          tooltip: 'Remove the selected item.',
          iconSize: 32,
        ),)
      ],
    );

    return Card(
      color:  Colors.black12,
      child: Center(
        child: Text(
          'Item ${dataItem.displayText}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}