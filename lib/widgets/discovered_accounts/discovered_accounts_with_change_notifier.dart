// import 'package:flutter/material.dart';
// import 'package:flutter_playground/common_widgets/animated_removal_list/animated_removal_list.dart';
// import 'package:flutter_playground/widgets/discovered_accounts/discovered_accounts_list_item.dart';
// import 'package:provider/provider.dart';
// import '../../view_models/discovered_accounts_list_data_item.dart';
// import 'discovered_accounts_vm.dart';
//
// class DiscoveredAccounts extends StatelessWidget{
//   const DiscoveredAccounts({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // return const AnimatedRemovalList();
//     return Scaffold(
//       body: ChangeNotifierProvider(//wait for vm getDiscoveredAccounts to return before rendering
//         create: (_){
//           return DiscoveredAccountsVM()..getDiscoveredAccounts();
//         },
//         child: Consumer<DiscoveredAccountsVM>(
//           builder: (context, discoveredAccountsVM, _){
//             print('building AnimatedRemovalList');
//             return AnimatedRemovalList<DiscoveredAccountsListDataItem>(
//                 listModel: discoveredAccountsVM.listModel,
//                 buildItem: (BuildContext context, DiscoveredAccountsListDataItem dataItem, Animation<double> animation, int index, VoidCallback removeItemFromList){
//                   return buildItem(index, dataItem, discoveredAccountsVM, removeItemFromList);
//                 },
//                 buildRemovedItem: (BuildContext context, DiscoveredAccountsListDataItem dataItem, Animation<double> animation, int index){
//                   return buildRemovedItem(context, dataItem, animation, index);
//                 },
//             );
//           },
//         )
//       )
//     );
//   }
//
//   //called on for each item from getDiscoveredAccounts call to listModel.insertAll(dataItems)
//   Widget buildItem(int index,  DiscoveredAccountsListDataItem dataItem, DiscoveredAccountsVM discoveredAccountsVM, VoidCallback removeItemFromList){
//     print('buildItem called for index: $index');
//     DiscoveredAccountsListDataItem dataItem = discoveredAccountsVM.listModel[index];
//     return DiscoveredAccountsListItem(dataItem: dataItem, onLinkAccountToBUPressed: (discoveredAccountsListItemState){
//       onLinkAccountToBUPressed(dataItem, removeItemFromList, discoveredAccountsListItemState);
//     });
//   }
//
//   onLinkAccountToBUPressed(DiscoveredAccountsListDataItem dataItem, VoidCallback removeItemFromList, DiscoveredAccountsListItemState discoveredAccountsListItemState) async{
//     try {
//       discoveredAccountsListItemState.setIsLoading(true);
//       await DiscoveredAccountsVM().linkAccountToBu(dataItem);
//       removeItemFromList();
//     }catch(e){
//       print('error linkAccountToBU $e');
//     }
//   }
//
//   Widget buildRemovedItem(BuildContext context, DiscoveredAccountsListDataItem dataItem, Animation<double> animation, int index){
//     DiscoveredAccountsListDataItem d = DiscoveredAccountsListDataItem(displayText: 'removed...');
//     return DiscoveredAccountsListItem(dataItem: d, onLinkAccountToBUPressed: (_)=>{},);
//   }
// }