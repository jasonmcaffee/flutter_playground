import 'package:flutter/material.dart';
import '../../view_models/discovered_accounts_list_data_item.dart';

//issue with stateful widgets in sliveranimatedlist
//https://github.com/flutter/flutter/issues/101551

class DiscoveredAccountsListItem extends StatefulWidget{
  final DiscoveredAccountsListDataItem dataItem;
  final Function(DiscoveredAccountsListItemState listItemStatePressed) onLinkAccountToBUPressed;

  const DiscoveredAccountsListItem({Key? key, required this.dataItem, required this.onLinkAccountToBUPressed}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DiscoveredAccountsListItemState();
}

class DiscoveredAccountsListItemState extends State<DiscoveredAccountsListItem>{
  late bool _isLoading = false;

  @override
  initState(){
    super.initState();
    // print('initState for ${widget.dataItem.displayText}');
    _isLoading = false;
  }
  setIsLoading(bool isLoading){
    setState((){
      print('setIsLoading called: $isLoading for ${widget.dataItem.displayText}');
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _isLoading ? '...${widget.dataItem.displayText}' : widget.dataItem.displayText;
    print('build called for ${widget.dataItem.displayText} isLoading: $_isLoading');
    return Row(
      children: [
        Expanded(child:Text(
            displayText,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(child: IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () {
            setIsLoading(true);
            widget.onLinkAccountToBUPressed(this);
          },
          tooltip: 'Remove the selected item.',
          iconSize: 32,
        ),)
      ],
    );
  }
}