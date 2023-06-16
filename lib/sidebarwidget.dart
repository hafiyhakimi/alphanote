import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notetaking/ui/notemain.dart';
import 'todolist/providers/todo_provider.dart';
import 'todolist/toDolist.dart';
import 'main.dart';
import 'notetaking/ui/notemain2.dart';
import 'authprovider.dart';
import 'calendar/ui/calendar_main.dart';

class SidebarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final auth = authProvider.auth;
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/pfp.jpeg'),
                  radius: 50,
                ),
                SizedBox(height: 10),
                Text(
                  user?.displayName ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('To-do List'),
            onTap: () {
              // TODO: implement action for Option 2

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                    create: (context) => TodoProvider(),
                    builder: (context, child) => const TodoList()
                )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteMain()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => calendar_main()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // TODO: implement action for Option 5
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () async {
              await auth.signOut();
              authProvider.clearUser();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
