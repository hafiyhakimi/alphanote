import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class NoteItem extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final String lastUpdated;
  final VoidCallback onTap;
  final DataSnapshot? snapshot;
  final String userId;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.lastUpdated,
    required this.onTap,
    this.snapshot,
    required this.userId,
  });

  factory NoteItem.fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value as Map<dynamic, dynamic>?;
    return NoteItem(
      id: snapshot.key!,
      title: value?['title'] ?? '',
      content: value?['content'] ?? '',
      lastUpdated: value?['lastUpdated'] ?? '',
      snapshot: snapshot,
      onTap: () {},
      userId: value?['userId'] ?? '',
    );
  }

  factory NoteItem.fromMap(Map<dynamic, dynamic> map) {
    return NoteItem(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      lastUpdated: map['lastUpdated'] as String? ?? '',
      onTap: () {},
      userId: map['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastUpdated': lastUpdated,
      'userId': userId,
    };
  }

  Map<String, dynamic> get value {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastUpdated': lastUpdated,
    };
  }

  NoteItem copyWith({
    String? id,
    String? title,
    String? content,
    String? lastUpdated,
    VoidCallback? onTap,
    DataSnapshot? snapshot,
    String? userId,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      onTap: onTap ?? this.onTap,
      snapshot: snapshot ?? this.snapshot,
      userId: userId ?? this.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Last updated: $lastUpdated',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
