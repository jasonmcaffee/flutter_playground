import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/event_bus_demo/event_types.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

class UserInteractions extends StatelessWidget {
  const UserInteractions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
          child: Text('Press me to fire event'),
          onPressed: () {
            serviceLocator<EventBus>().fire(UserInteractionOne(Random().nextInt(100)));
          }
      )
    ],);
  }

}