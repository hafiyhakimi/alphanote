import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class NoteModel {
  final String? id;
  final String title;
  final String content;
  final DateTime dateCreated;
  final DateTime lastEdited;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.lastEdited,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      dateCreated: DateTime.parse(json['date_created'] as String),
      lastEdited: DateTime.parse(json['last_edited'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date_created': dateCreated.toIso8601String(),
      'last_edited': lastEdited.toIso8601String(),
    };
  }
}
