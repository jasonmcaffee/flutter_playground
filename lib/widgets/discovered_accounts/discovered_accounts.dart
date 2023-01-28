import 'package:flutter/material.dart';
import 'package:flutter_playground/common_widgets/animated_removal_list/animated_removal_list.dart';
import 'package:flutter_playground/widgets/discovered_accounts/discovered_accounts_list_item.dart';
import 'package:provider/provider.dart';

import 'discovered_accounts_vm.dart';
class DiscoveredAccounts extends StatelessWidget{
  const DiscoveredAccounts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const AnimatedRemovalList();
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_){
          return DiscoveredAccountsVM()..getDiscoveredAccounts();
        },
        child: Consumer<DiscoveredAccountsVM>(
          builder: (context, discoveredAccountsVM, _){
            return AnimatedRemovalList(
                listModel: discoveredAccountsVM.listModel,
                buildItem: <DiscoveredAccountsListDataItem>(BuildContext context, DiscoveredAccountsListDataItem dataItem, Animation<double> animation, int index){
                  return itemBuilder(index, discoveredAccountsVM);
                }
            );
          },
        )
      )
    );
  }

  //called on for each item from getDiscoveredAccounts
  Widget itemBuilder(int index, DiscoveredAccountsVM discoveredAccountsVM){
    DiscoveredAccountsListDataItem dataItem = discoveredAccountsVM.listModel[index];
    return DiscoveredAccountsListItem(dataItem: dataItem);
  }
}