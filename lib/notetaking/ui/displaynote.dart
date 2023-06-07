import 'package:flutter/material.dart';
import '../backend/noteitem.dart';
import 'editnote.dart';
import 'package:intl/intl.dart';

// class DisplayNote extends StatelessWidget {
//   final NoteItem note;

//   DisplayNote({required this.note});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Note Details'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditNote(
//                     note: note,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(
//                   color: Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   note.title,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24.0,
//                     fontFamily: 'SF Pro Text',
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Container(
//               width: double.infinity,
//               height: 200.0,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(
//                   color: Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     note.content,
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontFamily: 'SF Pro Text',
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DisplayNote extends StatelessWidget {
  final NoteItem note;

  DisplayNote({required this.note});

  @override
  Widget build(BuildContext context) {
    DateTime lastUpdated = note.lastUpdated.toDate(); // Convert Timestamp to DateTime
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNote(
                    note: note,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    fontFamily: 'SF Pro Text',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SF Pro Text',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Last Updated: ${DateFormat.yMMMMd().add_jm().format(lastUpdated)}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}