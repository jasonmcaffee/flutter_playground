import 'package:flutter/material.dart';
import '../../view_models/discovered_accounts_list_data_item.dart';

//issue with stateful widgets in sliveranimatedlist
//https://github.com/flutter/flutter/issues/101551

class DiscoveredAccountsListItem extends StatefulWidget{
  final DiscoveredAccountsListDataItem dataItem;
  final Function(DiscoveredAccountsListItemState listItemStatePressed) onLinkAccountToBUPressed;

  const DiscoveredAccountsListItem({Key? key, required this.dataItem, required this.onLinkAccountToBUPressed}) : super(key: key);
  // @override
  // State<StatefulWidget> createState() => DiscoveredAccountsListItemState();
  @override
  State<StatefulWidget> createState(){
    print('create state called for ${dataItem.displayText}');
    return DiscoveredAccountsListItemState();
  }

}

class DiscoveredAccountsListItemState extends State<DiscoveredAccountsListItem>{
  late DiscoveredAccountsListDataItem _dataItem;
  @override
  initState(){
    super.initState();
    _dataItem = widget.dataItem;
  }
  setIsLoading(bool isLoading){
    _dataItem.isLoading = isLoading;
    setState((){
      print('setIsLoading called: $isLoading for ${widget.dataItem.displayText}');
      _dataItem = _dataItem;
    });
  }

  _setDataItemIfNeeded(){
    if(_dataItem != widget.dataItem){
      print('data items dont match so updating state');
        setState((){
          _dataItem = widget.dataItem;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _dataItem.isLoading ? '...backend call' : widget.dataItem.displayText;
    print('build called for ${widget.dataItem.displayText} isLoading: ${_dataItem.isLoading} state. state _dataItem.displayText: ${_dataItem.displayText}');
    //hack
    _setDataItemIfNeeded();

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