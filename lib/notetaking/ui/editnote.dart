import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../backend/noteitem.dart';

class EditNote extends StatefulWidget {
  final NoteItem note;

  const EditNote({Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _content;

  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseDatabase = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _title = widget.note.title;
    _content = widget.note.content;
  }

  Future<void> _updateNote() async {
  final currentUser = _firebaseAuth.currentUser;
  final key = widget.note.snapshot?.key;

  if (currentUser != null && key != null) {
      try {
        await FirebaseDatabase.instance
            .reference()
            .child('notes')
            .child(key)
            .update({
              'title': _title,
              'content': _content,
              'updatedAt': ServerValue.timestamp,
            });
        Navigator.pop(context);
      } catch (e) {
        print('Failed to update note: $e');
      }

  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _formKey.currentState?.save();
                _updateNote();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (widget.note.snapshot?.key != null) {
                _firebaseDatabase
                  .reference()
                  .child('notes')
                  .child(widget.note.snapshot!.key!)
                  .remove()
                  .then((_) {
                    Navigator.pop(context);
                  })
                  .catchError((error) {
                    print("Failed to delete note: $error");
                  });
              } else {
                print('Failed to delete note: snapshot key is null');
              }
            },


          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: _content,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _content = value!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
