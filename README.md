# flutter_playground
Playground for Flutter and Dart experimentation.

# Flutter Patterns and Tools

## Dependency Injection/Inversion of Control
Dependency Injection allows us to invert the control of what instantiates and/or finds dependencies in a class.

Rather than parent A instantiating child B, parent A is instead provided a mechanism for retrieving child B.

This becomes useful in testing, as it allows us to switch out the implementation or instance of child B, without having to change parent A.
It also frees parent A from the nuances of child B's instantiation.

### Service Locator
https://martinfowler.com/articles/injection.html#UsingAServiceLocator
[Get It](https://pub.dev/packages/get_it) is an Inversion of Control container that allows us to register and lookup objects through a singleton registry.

```dart
//singleton registry that is used throughout the entire application to register and locate objects.
final getIt = GetIt.instance;

//register a singleton with the service locator so that it can be looked up and used throughout the app
getIt.registerSingleton<ChildB>(ChildB());

//retrieve the ChildB instance from inside parent A
class ParentA{
  someParentFunction(){
    getIt<ChildB>().someChildFunction();
  }
}

```

## Event Driven Architecture
[Event Driven](https://martinfowler.com/articles/201701-event-driven.html)

It is often useful to decouple modules from each other by utilizing a publish/subscribe pattern.

e.g. rather than module A having a reference to modules B and C, in order to notify them of something that occurred in A, 
we can instead remove modules B and C from A, and instead publish an event from module A that B and C subscribe to.

This decoupling frees us to make changes to modules A, B, or C, without having to worry as much about impacts to other modules.

e.g. If we want to deprecate module B, we no longer have to go into module A to change references, function names, etc, and can instead
swap out B with a new module D that subscribes to events previously handled by B.

### Event Bus
[Event Bus](https://pub.dev/packages/event_bus) provides a convenient event bus implementation that utilizes generics to filter which event types to publish and subscribe to.

```dart
//instance of event bus shared by modules A, B, and C.  Often a singleton of event bus can be used throughout the entire app.
EventBus eventBus = EventBus();

//message types
class UserPressedButtonOne {}
class UserPressedButtonTwo {}

//module B subscribes to messages of type X, published by any module
class ModuleB {
  initState(){
    eventBus.on<UserPressedButtonOne>().listen((event) => {
      //respond to the event
    });
  }
}

//publish a message from
class ModuleA {
  someFunction(){
    eventBus.fire(UserPressedButtonOne());
  }
}

```

### Provider

[Provider](https://pub.dev/packages/provider) is a library that offers functionality for:
- Publish/Subscribe model: Widgets/components updating the UI by responding to events/notifications from ChangeNotifier notifyListeners() calls.
- Service Locator: Gaining access to providers/data deep down a widget/component tree, without having to explicitly pass the data down to each node in the tree.


```dart
//change notifier
class TodoListModel extends ChangeNotifier {
  var someState = 'initial state';
  
  doSomethingThatChangesState(){
    someState = 'changed!';
    //publish: let all subscribers know that state has been changed
    notifyListeners();
  }
}

//TodoListPage widget
//change notifier provider allows all widgets in the TodoList widget tree to respond to events published by the ChangeNotifier model.
Widget build(BuildContext context) {
  return ChangeNotifierProvider<TodoListModel>(
    create: (context) => TodoListModel()..fetchTodoListItems(),
    child: const TodoList(),
  );
}

//TodoListItem widget 
//here we can use select filtering so that we only update this Widget's UI when its item is changed.
Widget build(BuildContext context) {
  //find the immutable instance so that we only update when there is a new instance/update to a single item.
  //if the instance wasn't replaced, then the build function doesn't fire.
  final todoListItemModel = context.select<TodoListModel, TodoListItemModel>(
          (todoListModel) => todoListModel.getItemModelById(todoListItemModelId));

  return Text('${todoListItemModel.displayText}');
}

```
