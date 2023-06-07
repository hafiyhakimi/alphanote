import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// class NoteItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String content;
//   // final String lastUpdated;
//   final Timestamp lastUpdated; // Updated to Timestamp
//   final VoidCallback onTap;
//   final DataSnapshot? snapshot;
//   final String userId;

//   NoteItem({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.lastUpdated,
//     required this.onTap,
//     this.snapshot,
//     required this.userId,
//   });

//   factory NoteItem.fromSnapshot(DataSnapshot snapshot) {
//     final value = snapshot.value as Map<String, dynamic>;
//     final timestamp = value['lastUpdated'] as Timestamp; // Get the Timestamp value
//     return NoteItem(
//       id: snapshot.key!,
//       title: value['title']?.toString() ?? '',
//       content: value['content']?.toString() ?? '',
//       // lastUpdated: value['lastUpdated']?.toString() ?? '',
//       lastUpdated: timestamp, // Assign the Timestamp value
//       snapshot: snapshot,
//       onTap: () {},
//       userId: value['userId']?.toString() ?? '',
//     );
//   }

//   factory NoteItem.fromMap(Map<String, dynamic>? map) {
//     final timestamp = map?['lastUpdated'] as Timestamp; // Get the Timestamp value
//     return NoteItem(
//       id: map?['id']?.toString() ?? '',
//       title: map?['title']?.toString() ?? '',
//       content: map?['content']?.toString() ?? '',
//       // lastUpdated: map?['lastUpdated']?.toString() ?? '',
//       lastUpdated: timestamp, // Assign the Timestamp value
//       onTap: () {},
//       snapshot: null,
//       userId: map?['userId']?.toString() ?? '',
//     );
//   }

//   static DateTime _parseDateTime(Timestamp timestamp) {
//     return timestamp.toDate();
//   }


//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'content': content,
//       'lastUpdated': lastUpdated,
//       'userId': userId,
//     };
//   }

//   Map<String, dynamic> get value {
//     return {
//       'id': id,
//       'title': title,
//       'content': content,
//       'lastUpdated': lastUpdated,
//     };
//   }

//   // NoteItem copyWith({
//   //   String? id,
//   //   String? title,
//   //   String? content,
//   //   String? lastUpdated,
//   //   VoidCallback? onTap,
//   //   DataSnapshot? snapshot,
//   //   String? userId,
//   // }) {
//   //   return NoteItem(
//   //     id: id ?? this.id,
//   //     title: title ?? this.title,
//   //     content: content ?? this.content,
//   //     lastUpdated: lastUpdated ?? this.lastUpdated,
//   //     onTap: onTap ?? this.onTap,
//   //     snapshot: snapshot ?? this.snapshot,
//   //     userId: userId ?? this.userId,
//   //   );
//   // }

//   NoteItem copyWith({
//     String? id,
//     String? title,
//     String? content,
//     Timestamp? lastUpdated, // Updated to Timestamp
//     VoidCallback? onTap,
//     DataSnapshot? snapshot,
//     String? userId,
//   }) {
//     return NoteItem(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       content: content ?? this.content,
//       lastUpdated: lastUpdated ?? this.lastUpdated,
//       onTap: onTap ?? this.onTap,
//       snapshot: snapshot ?? this.snapshot,
//       userId: userId ?? this.userId,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final format = DateFormat('yyyy-MM-dd HH:mm:ss');
//      final formattedDate = format.format(lastUpdated.toDate()); // Convert Timestamp to DateTime and format
    
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               content,
//               // maxLines: 100,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               'Last updated: $formattedDate', // Display the formatted date
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontSize: 14.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class NoteItem extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final Timestamp lastUpdated;
  final VoidCallback onTap;
  final String userId;
  final DataSnapshot? snapshot;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.lastUpdated,
    required this.onTap,
    required this.userId,
    this.snapshot,
  });

  factory NoteItem.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return NoteItem(
      id: snapshot.id,
      title: data['title']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      lastUpdated: data['lastUpdated'] as Timestamp,
      onTap: () {},
      userId: data['userId']?.toString() ?? '',
    );
  }

  factory NoteItem.fromMap(Map<String, dynamic>? map) {
    return NoteItem(
      id: map?['id']?.toString() ?? '',
      title: map?['title']?.toString() ?? '',
      content: map?['content']?.toString() ?? '',
      lastUpdated: map?['lastUpdated'] as Timestamp,
      onTap: () {},
      userId: map?['userId']?.toString() ?? '',
    );
  }

  DateTime _parseDateTime(Timestamp timestamp) {
    return timestamp.toDate();
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
    Timestamp? lastUpdated, // Updated to Timestamp
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
    final format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final formattedDate = format.format(_parseDateTime(lastUpdated));
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Last updated: $formattedDate',
              style: const TextStyle(
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
