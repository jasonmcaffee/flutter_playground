import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playground/widgets/event_bus_demo/event_types.dart';
import 'package:flutter_playground/widgets/event_bus_demo/user_interactions.dart';
import 'package:get_it/get_it.dart';
final serviceLocator = GetIt.instance;
class EventBusPage extends StatefulWidget{
  const EventBusPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventBusPageState();
}

class _EventBusPageState extends State<EventBusPage> {
  var message = 'No event yet...';
  late StreamSubscription userInteractionOneSubscription;
  @override
  initState(){
    super.initState();
    //register a singleton instance of eventbus with serviceLocator
    //typically this would go higher up in the app.
    serviceLocator.registerSingleton<EventBus>(EventBus());

    //listen for UserInteractionOne events and set state so we can show the event occurring on screen
    userInteractionOneSubscription = serviceLocator<EventBus>().on<UserInteractionOne>().listen((event) {
      setState((){
        message ='event received with data: ${event.data}';
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('$message'),
      UserInteractions()
    ],);
  }

  @override
  dispose(){
    super.dispose();
    //stop listening to events
    userInteractionOneSubscription.cancel();
  }
}