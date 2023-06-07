import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/noteitem.dart';
import 'notemain.dart';

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
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _title = widget.note.title;
    _content = widget.note.content;
  }

  Future<void> _updateNote() async {
    final currentUser = _firebaseAuth.currentUser;
    final noteRef = _firestore.collection('notes').doc(currentUser?.uid).collection('user_notes').doc(widget.note.id);

    if (currentUser != null) {
      try {
        await noteRef.update({
          'title': _title,
          'content': _content,
          'lastUpdated': DateTime.now(), // Update the 'lastUpdated' field
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoteMain()),
        );
      } catch (e) {
        print('Failed to update note: $e');
      }
    }
  }

  Future<void> _deleteNote() async {
    final currentUser = _firebaseAuth.currentUser;
    final noteRef = _firestore.collection('notes').doc(currentUser?.uid).collection('user_notes').doc(widget.note.id);

    if (currentUser != null) {
      try {
        await noteRef.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoteMain()),
        );
      } catch (e) {
        print('Failed to delete note: $e');
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
              _deleteNote();
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
