import 'package:flutter/material.dart';
import 'package:flutter_playground/common_widgets/animated_removal_list/animated_removal_list.dart';
import 'package:flutter_playground/widgets/discovered_accounts/discovered_accounts_list_item.dart';
import 'package:provider/provider.dart';
import '../../view_models/discovered_accounts_list_data_item.dart';
import 'discovered_accounts_vm.dart';

class DiscoveredAccounts extends StatefulWidget {
  const DiscoveredAccounts({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DiscoveredAccountsState();
}

class DiscoveredAccountsState extends State<DiscoveredAccounts> {
  late final DiscoveredAccountsVM discoveredAccountsVM;
  @override
  initState() {
    print('DiscoveredAccountsState initState');
    discoveredAccountsVM = DiscoveredAccountsVM();
    discoveredAccountsVM
        .getDiscoveredAccounts(); //the list will re-render after this call completes
  }

  @override
  Widget build(BuildContext context) {
    print('DiscoveredAccountsState build called');
    return Scaffold(
        body: AnimatedRemovalList<DiscoveredAccountsListDataItem,
          DiscoveredAccountsListItemState>(
            listModel: discoveredAccountsVM.listModel,
            buildItem: (BuildContext context,
                DiscoveredAccountsListDataItem dataItem,
                GlobalKey<DiscoveredAccountsListItemState> listItemKey,
                Animation<double> animation,
                int index,
                VoidCallback removeItemFromList) {
              return buildItem(index, dataItem, listItemKey, discoveredAccountsVM,
                  removeItemFromList);
            },
            buildRemovedItem: (BuildContext context,
                DiscoveredAccountsListDataItem dataItem,
                Animation<double> animation,
                int index) {
              return buildRemovedItem(context, dataItem, animation, index);
            },
        )
    );
  }

  //called on for each item from getDiscoveredAccounts call to listModel.insertAll(dataItems)
  Widget buildItem(
      int index,
      DiscoveredAccountsListDataItem dataItem,
      GlobalKey<DiscoveredAccountsListItemState> listItemKey,
      DiscoveredAccountsVM discoveredAccountsVM,
      VoidCallback removeItemFromList) {
    DiscoveredAccountsListDataItem dataItem =
        discoveredAccountsVM.listModel[index];
    print('buildItem called for ${dataItem.displayText} index: $index');
    return DiscoveredAccountsListItem(
        key: listItemKey,
        dataItem: dataItem,
        onLinkAccountToBUPressed: (discoveredAccountsListItemState) {
          onLinkAccountToBUPressed(
              dataItem, removeItemFromList, discoveredAccountsListItemState);
        });
  }

  onLinkAccountToBUPressed(
      DiscoveredAccountsListDataItem dataItem,
      VoidCallback removeItemFromList,
      DiscoveredAccountsListItemState discoveredAccountsListItemState) async {
    try {
      discoveredAccountsListItemState.setIsLoading(true);
      await DiscoveredAccountsVM().linkAccountToBu(dataItem);
      // discoveredAccountsListItemState.setIsLoading(false);
      removeItemFromList();
    } catch (e) {
      print('error linkAccountToBU $e');
    }
  }

  Widget buildRemovedItem(
      BuildContext context,
      DiscoveredAccountsListDataItem dataItem,
      Animation<double> animation,
      int index) {
    DiscoveredAccountsListDataItem d =
        DiscoveredAccountsListDataItem(displayText: 'removed');
    return DiscoveredAccountsListItem(
      dataItem: d,
      onLinkAccountToBUPressed: (_) => {},
    );
  }
}
