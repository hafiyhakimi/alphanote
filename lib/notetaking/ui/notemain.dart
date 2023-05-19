import 'package:flutter/material.dart';
import '../backend/noteprovider.dart';
import '../backend/notemodel.dart';
import '../backend/noteitem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'addnote.dart';
import 'editnote.dart';
import '../../sidebarwidget.dart';

class NoteMain extends StatelessWidget {
  const NoteMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      drawer: const SidebarWidget(),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.reference().child('notes').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notes = <NoteItem>[];

          final eventSnapshot = snapshot.data!;
          if (eventSnapshot.snapshot.value != null) {
            final data = (eventSnapshot.snapshot.value as Map<dynamic, dynamic>)
                .cast<String, dynamic>();
            data.forEach((key, value) {
              final note = NoteItem.fromMap(value as Map<String, dynamic>);
              NoteItem updatedNote = note.copyWith(id: key);
              notes.add(note);
            });
          }

          if (notes.isEmpty) {
            return const Center(
              child: Text('No notes found.'),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index].title),
                subtitle: Text(notes[index].content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNote(
                        note: notes[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
