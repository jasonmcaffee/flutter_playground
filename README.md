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
  init(){
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
- Publish/Subscribe model: Widgets are able to easily re-build/update the UI by subscribing to notifications from ChangeNotifier notifyListeners() calls.
- Service Locator: Gaining access to ChangeNotifierProvider data (e.g. model created during create()) from deep down within a widget/component tree, without having to explicitly pass the data into each of the constructors of widgets/nodes in the tree.

Provider utilizes these main components to facilitate the above functionality:
- ChangeNotifier 
  - An [Observer Pattern](https://en.wikipedia.org/wiki/Observer_pattern) implementation that provides notifyListeners() and listener registry functions.
- ChangeNotifierProvider
  - Listener of ChangeNotifier's notifications (via notifyListeners() and addListener)
  - There are many caveats and best practices surrounding the use of ChangeNotifierProvider, which are well documented in the comments of its source code.
  - Abstracts away InheritedWidget, which is used to share data throughout ChangeNotifierProvider's child's widget tree via the build context.
- Build Context (passed to each widget's build function)
  - [extension methods](https://dart.dev/guides/language/extension-methods) for selecting, reading, etc data passed down the InheritedWidget tree.
    - context.read<TModel>() - get the instance provided by ChangeNotifierProvider's create() call.  e.g. TodoListModel
    - select<TModel, TDerivedValueToWatch>(lambdaFuncToSelectDerivedValue(model) => model.derivedValueToWatch ) - only rebuild when derivedValueToWatch changes reference (comparison function requires different instances to signal change)
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

//...

//TodoListPage widget
//change notifier provider allows all widgets in the TodoList widget tree to respond to events published by the ChangeNotifier model.
Widget build(BuildContext context) {
  return ChangeNotifierProvider<TodoListModel>(
    create: (context) => TodoListModel(),
    child: const TodoList(),
  );
}

//...
//TodoList
Widget build(BuildContext context) {
  //We use context as a service locator for TodoListModel, so that we get access to the instance created by the ChangeNotifierProvider above
  //We can also filter which data we care about having changed.
  //This allows us to only rebuild this widget when someState changes on TodoListModel.  
  //Other updates of the model (notifyListeners()) would be ignored, and would not cause this widget to rebuild.
  final someState = context.select<TodoListModel, String>((model) => model.someState);
  print('someState: $someState');
  
  //DONT use either Provider.of or context.watch (same thing) here, as any notifyListeners will trigger a rebuild,
  //and we typically don't want that behavior when dealing with a list of items.
  // final todoListModel = Provider.of<TodoListModel>(context); <- any notifyListeners() call in TodoListModel would trigger a rebuild
  // final todoListModel = context.watch<TodoListModel>(); <- any notifyListeners() call in TodoListModel would trigger a rebuild
  
  return AnimatedList(
      initialItemCount: context.read<TodoListModel>().todoListItems.length,
      itemBuilder: (context, index, _) {
        //use context to 
        final todoListModel = context.read<TodoListModel>();
        final todoListItemModel = todoListModel.todoListItems[index];
        return TodoListItem(todoListItemModelId: todoListItemModel.id);
      });
}

```

In more advanced scenarios, we must ensure that select is provided different instances to compare when it makes its determination whether state has changed, and subsequently rebuild the widget.
```dart
class TodoListModel extends ChangeNotifier {
  List<TodoListItemModel> todoListItems = [];
  
  //...
  
  //context.select requires that a new object be created so that the comparison of previous to new doesn't return true.
  updateTodo(TodoListItemModel todoListItemModel) {
    final index = todoListItems.indexOf(todoListItemModel);
    //construct a new instance by copying all state.  Libraries such as [Freezed](https://pub.dev/packages/freezed) can minimize the amount of copy code you hand roll.
    final newItem = TodoListItemModel(todoListItemModel.id,
        todoListItemModel.isComplete, todoListItemModel.displayText);
    //replace the old item instance with a new instance.
    todoListItems[index] = newItem;
    notifyListeners();
  }
}

//...

//TodoListItem widget
class TodoListItem extends StatelessWidget {
  final int todoListItemModelId;

  const TodoListItem({Key? key, required this.todoListItemModelId})
      : super(key: key);

  Widget build(BuildContext context) {
    //Rather than rebuilding regardless of which TodoListItemModel changes, or every time TodoListModel changes,
    //we can use select filtering so that we can avoid superfluous rebuilds.
    //Note: the logic inside of select detects changes only when the before and after objects compared must be different instances. 
    //e.g. if the instance of TodoListItemModel wasn't replaced, then this instance's build function wouldn't fire.
    final todoListItemModel = context.select<TodoListModel, TodoListItemModel>(
            (todoListModel) => todoListModel.getItemModelById(todoListItemModelId));

    return Text('${todoListItemModel.displayText}');
  }
}
```
