import 'package:alphanoteapp/toDoList/body.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DefaultTabController(
        length: 3,
        child: Body(),
      )
    );
  }
}