import 'package:flutter/material.dart';

class DiscoveredAccountsListDataItem {
  final String displayText;
  DiscoveredAccountsListDataItem({
    required this.displayText
  });
}

class DiscoveredAccountsListItem extends StatelessWidget{
  const DiscoveredAccountsListItem({Key? key, required this.dataItem}) : super(key: key);
  final DiscoveredAccountsListDataItem dataItem;

  @override
  Widget build(BuildContext context) {

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