// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:alphanoteapp/toDoList/body.dart';
// import 'package:alphanoteapp/toDoList/providers/todo_provider.dart';

// void runTodo(){
//    ChangeNotifierProvider(
//       create: (context) => TodoProvider(),
//       builder: (context, child) => const TodoList()
//   );
// }

// Widget build(BuildContext context) {
//   return Provider<Example>(
//     create: (_) => Example(),
//     // Will throw a ProviderNotFoundError, because `context` is associated
//     // to the widget that is the parent of `Provider<Example>`
//     child: Text(context.watch<Example>().toString()),
//   );
// }

// Widget build(BuildContext context) {
//   return Provider<Example>(
//       create: (_) => Example(),
//       // we use `builder` to obtain a new `BuildContext` that has access to the provider
//       builder: (context, child) {
//         // No longer throws
//         return Text(context.watch<Example>().toString());
//       });
// }

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DefaultTabController(
          length: 3,
          child: Body(),
        ));
  }
}
