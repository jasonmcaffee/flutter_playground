import 'package:flutter/material.dart';
import '../../common_widgets/animated_removal_list/animated_removal_list_vm.dart';
import '../../view_models/discovered_accounts_list_data_item.dart';

class DiscoveredAccountsVM extends ChangeNotifier{
  late final ListModel<DiscoveredAccountsListDataItem> listModel;
  DiscoveredAccountsVM(){
    listModel = ListModel(
      listKey:  GlobalKey<SliverAnimatedListState>(),
    );
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

  Future<void> linkAccountToBu(DiscoveredAccountsListDataItem dataItem) async {
    return fakeBackendCallToLinkAccountToBU();
  }
}

Future<List<DiscoveredAccountsListDataItem>> fakeBackendCallToGetDiscoveredAccounts() async {
  return <DiscoveredAccountsListDataItem>[
    DiscoveredAccountsListDataItem(displayText: 'Account 0'),
    DiscoveredAccountsListDataItem(displayText: 'Account 1'),
    DiscoveredAccountsListDataItem(displayText: 'Account 2'),
    DiscoveredAccountsListDataItem(displayText: 'Account 3'),
    DiscoveredAccountsListDataItem(displayText: 'Account 4'),
    DiscoveredAccountsListDataItem(displayText: 'Account 5'),
    DiscoveredAccountsListDataItem(displayText: 'Account 6'),
    DiscoveredAccountsListDataItem(displayText: 'Account 7'),
    DiscoveredAccountsListDataItem(displayText: 'Account 8'),
    DiscoveredAccountsListDataItem(displayText: 'Account 9'),
  ];
}

Future<void> fakeBackendCallToLinkAccountToBU() async {
  await Future.delayed(const Duration(seconds: 3));
}