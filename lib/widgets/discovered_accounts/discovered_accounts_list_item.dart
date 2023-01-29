import 'package:flutter/material.dart';
import '../../view_models/discovered_accounts_list_data_item.dart';

class DiscoveredAccountsListItem extends StatelessWidget{
  final DiscoveredAccountsListDataItem dataItem;
  final VoidCallback onLinkAccountToBUPressed;

  const DiscoveredAccountsListItem({Key? key, required this.dataItem, required this.onLinkAccountToBUPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(child:Text(
            '${dataItem.displayText}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(child: IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: onLinkAccountToBUPressed,
          tooltip: 'Remove the selected item.',
          iconSize: 32,
        ),)
      ],
    );
  }
}