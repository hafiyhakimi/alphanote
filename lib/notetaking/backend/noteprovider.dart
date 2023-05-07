import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'notemodel.dart';
import 'noteitem.dart';

class NoteProvider extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late List<NoteItem> _notes;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<NoteItem> get notes => _notes;

  Future<List<NoteItem>> fetchNotes() async {
  final User? user = _auth.currentUser;
  if (user == null) {
    return [];
  }

  _isLoading = true;
  notifyListeners();

  final dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child('notes')
      .orderByChild('userId')
      .equalTo(user.uid)
      .once();

  final notes = (dataSnapshot.snapshot.value as Map<dynamic, dynamic>)
      .entries
      .map((entry) {
    return NoteItem.fromMap(
        Map<String, dynamic>.from(entry.value));
  }).toList();

  _isLoading = false;
  _notes = notes;
  notifyListeners();

  return notes;
}


  Future<void> addNote(NoteItem note) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final DatabaseReference databaseReference =
        await FirebaseDatabase.instance.reference().child('notes').push();
    final String id = databaseReference.key ?? '';

    await databaseReference.set(note.copyWith(id: id, userId: user.uid).toMap());
    _notes.add(note.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateNote(NoteItem note) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await FirebaseDatabase.instance.reference().child('notes/${note.id}').update(note.toMap());
    final int index = _notes.indexWhere((element) => element.id == note.id);
    _notes[index] = note;
    notifyListeners();
  }

  Future<void> deleteNote(NoteItem note) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await FirebaseDatabase.instance.reference().child('notes/${note.id}').remove();
    _notes.remove(note);
    notifyListeners();
  }
}
