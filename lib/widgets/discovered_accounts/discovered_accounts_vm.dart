import 'package:flutter/material.dart';

import '../../common_widgets/animated_removal_list/animated_removal_list_vm.dart';
import 'discovered_accounts_list_item.dart';

class DiscoveredAccountsVM extends ChangeNotifier{
  late final ListModel<DiscoveredAccountsListDataItem> listModel;
  DiscoveredAccountsVM(){
    listModel = ListModel(
      listKey:  GlobalKey<SliverAnimatedListState>(),
      removedItemBuilder: (DiscoveredAccountsListDataItem item, BuildContext context, Animation<double> animation) {
        return removedItemBuilder(item, context, animation);
    });
  }

  //todo: maybe this should be defined in the DiscoveredAccounts widget?
  removedItemBuilder(DiscoveredAccountsListDataItem item, BuildContext context, Animation<double> animation){
    return DiscoveredAccountsListItem(dataItem: item);
  }

  //typically called during the DiscoveredAccounts widget build
  Future<void> getDiscoveredAccounts() async {
    print('getDiscoveredAccounts called ${listModel.listKey.currentState}');
    //fetch data from the backend
    final dataItems = await fakeBackendCallToGetDiscoveredAccounts();
    //update the dataItems corresponding sliverAnimatedListState
    listModel.insertAll(dataItems);
    notifyListeners();
  }
}

Future<List<DiscoveredAccountsListDataItem>> fakeBackendCallToGetDiscoveredAccounts() async {
  return <DiscoveredAccountsListDataItem>[
    DiscoveredAccountsListDataItem(displayText: 'Account 0'),
    DiscoveredAccountsListDataItem(displayText: 'Account 1'),
    DiscoveredAccountsListDataItem(displayText: 'Account 2'),
  ];
}