// import 'package:flutter/material.dart';
// import '../backend/noteprovider.dart';
// import '../backend/notemodel.dart';
// import '../backend/noteitem.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'addnote.dart';
// import 'editnote.dart';
// import '../../sidebarwidget.dart';
// import 'package:provider/provider.dart';
// import '../../authprovider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'displaynote.dart';

// class NoteMain extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final auth = authProvider.auth;
//     final uid = auth.currentUser!.uid;
//     final notesRef = FirebaseFirestore.instance.collection('notes').doc(uid).collection('user_notes');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notes'),
//       ),
//       drawer: SidebarWidget(),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: notesRef.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No notes found.'),
//             );
//           }
//           final notes = snapshot.data!.docs.map((doc) {
//             final note = NoteItem.fromMap(doc.data());
//             return note.copyWith(id: doc.id);
//           }).toList();          
//           return GridView.builder(
//             padding: EdgeInsets.all(16.0),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, // Adjust the crossAxisCount as needed
//               mainAxisSpacing: 16.0,
//               crossAxisSpacing: 16.0,
//               childAspectRatio: 1.0,
//             ),
//             itemCount: notes.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DisplayNote(
//                         note: notes[index],
//                       ),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   elevation: 4.0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           notes[index].title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddNote(),
//             ),
//           );
//         },
//         tooltip: 'Add Note',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../backend/noteprovider.dart';
import '../backend/notemodel.dart';
import '../backend/noteitem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'addnote.dart';
import 'editnote.dart';
import '../../sidebarwidget.dart';
import 'package:provider/provider.dart';
import '../../authprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'displaynote.dart';
import 'package:intl/intl.dart';

class NoteMain extends StatefulWidget {
  @override
  _NoteMainState createState() => _NoteMainState();
}

class _NoteMainState extends State<NoteMain> {
  final TextEditingController _searchController = TextEditingController();
  late List<NoteItem> _notes;
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _notes = [];
    _categories = ['Today', 'Yesterday', 'Last 7 Days', 'Previous Month', 'Previous 2 Months'];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NoteItem> filterNotesByCategory(String category) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    switch (category) {
      case 'Today':
        return _notes.where((note) {
          final noteDateTime = note.lastUpdated.toDate();
          return noteDateTime.year == today.year &&
              noteDateTime.month == today.month &&
              noteDateTime.day == today.day;
        }).toList();
      case 'Yesterday':
        final DateTime yesterday = today.subtract(Duration(days: 1));
        return _notes.where((note) {
          final noteDateTime = note.lastUpdated.toDate();
          return noteDateTime.year == yesterday.year &&
              noteDateTime.month == yesterday.month &&
              noteDateTime.day == yesterday.day;
        }).toList();
      case 'Last 7 Days':
        final DateTime yesterday = today.subtract(Duration(days: 1));
        final DateTime lastWeek = today.subtract(Duration(days: 6));
        return _notes.where((note) {
          final noteDateTime = note.lastUpdated.toDate();
          final noteDate = DateTime(noteDateTime.year, noteDateTime.month, noteDateTime.day);
          return noteDate.isAfter(lastWeek.subtract(Duration(days: 1))) &&
              noteDate.isBefore(yesterday);
        }).toList();
      // case 'Last 30 Days':
      //   final DateTime lastWeek = today.subtract(Duration(days: 6));
      //   final DateTime lastMonth = today.subtract(Duration(days: 29));
      //   return _notes.where((note) {
      //     final noteDateTime = note.lastUpdated.toDate();
      //     final noteDate = DateTime(noteDateTime.year, noteDateTime.month, noteDateTime.day);
      //     return noteDate.isAfter(lastMonth.subtract(Duration(days: 1))) &&
      //         noteDate.isBefore(lastWeek);
      //   }).toList();
      case 'Previous Month':
        final DateTime previousMonth = DateTime(now.year, now.month - 1);
        return _notes.where((note) {
          final noteDateTime = note.lastUpdated.toDate();
          return noteDateTime.year == previousMonth.year &&
              noteDateTime.month == previousMonth.month;
        }).toList();
      case 'Previous 2 Months':
        final DateTime previous2Months = DateTime(now.year, now.month - 2);
        return _notes.where((note) {
          final noteDateTime = note.lastUpdated.toDate();
          return noteDateTime.year == previous2Months.year &&
              noteDateTime.month == previous2Months.month;
        }).toList();
      default:
        return _notes;
    }
  }

  List<String> getCategoriesWithNotes(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final List<String> categoriesWithNotes = [];
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(Duration(days: 1));
    final DateTime lastWeek = today.subtract(Duration(days: 6));
    final DateTime lastMonth = today.subtract(Duration(days: 29));
    final DateTime previousMonth = DateTime(now.year, now.month - 1);
    final DateTime previous2Months = DateTime(now.year, now.month - 2);

    _notes.forEach((note) {
      final noteDateTime = note.lastUpdated.toDate();
      final noteDate = DateTime(noteDateTime.year, noteDateTime.month, noteDateTime.day);

      if (filterNotesByCategory('Today').contains(note)) {
        if (!categoriesWithNotes.contains('Today')) {
          categoriesWithNotes.add('Today');
        }
      } else if (filterNotesByCategory('Yesterday').contains(note)) {
        if (!categoriesWithNotes.contains('Yesterday')) {
          categoriesWithNotes.add('Yesterday');
        }
      } else if (noteDate.isAfter(lastWeek) && noteDate.isBefore(yesterday)) {
        if (!categoriesWithNotes.contains('Last 7 Days') && filterNotesByCategory('Last 7 Days').contains(note)) {
          categoriesWithNotes.add('Last 7 Days');
        }
      // } else if (noteDate.isAfter(lastMonth) && noteDate.isBefore(lastWeek)) {
      //   if (!categoriesWithNotes.contains('Last 30 Days') && filterNotesByCategory('Last 30 Days').contains(note)) {
      //     categoriesWithNotes.add('Last 30 Days');
      //   }
      } else if (noteDate.year == previousMonth.year && noteDate.month == previousMonth.month) {
        if (!categoriesWithNotes.contains('Previous Month') && filterNotesByCategory('Previous Month').contains(note)) {
          categoriesWithNotes.add('Previous Month');
        }
      } else if (noteDate.year == previous2Months.year && noteDate.month == previous2Months.month) {
        if (!categoriesWithNotes.contains('Previous 2 Months') && filterNotesByCategory('Previous 2 Months').contains(note)) {
          categoriesWithNotes.add('Previous 2 Months');
        }
      }
    });

    // Sort the categories in descending order
    categoriesWithNotes.sort((a, b) => _categories.indexOf(b).compareTo(_categories.indexOf(a)));

    return categoriesWithNotes;
  }

  List<NoteItem> searchNotes(String query) {
    if (query.isEmpty) {
      return _notes;
    }
    return _notes.where((note) => note.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final auth = authProvider.auth;
    final uid = auth.currentUser!.uid;
    final notesRef = FirebaseFirestore.instance.collection('notes').doc(uid).collection('user_notes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      drawer: SidebarWidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: notesRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No notes found.'),
                  );
                }
                _notes = snapshot.data!.docs.map((doc) {
                  final note = NoteItem.fromSnapshot(doc);
                  return note;
                }).toList();

                final filteredNotes = searchNotes(_searchController.text);
                final categoriesWithNotes = getCategoriesWithNotes(snapshot.data!);

                // Sort the categories according to the defined order
                categoriesWithNotes.sort((a, b) => _categories.indexOf(a).compareTo(_categories.indexOf(b)));

                return ListView.builder(
                  itemCount: categoriesWithNotes.length,
                  itemBuilder: (context, index) {
                    final category = categoriesWithNotes[index];
                    final categoryNotes = filterNotesByCategory(category);
                    if (categoryNotes.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Adjust the crossAxisCount as needed
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: categoryNotes.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DisplayNote(
                                      note: categoryNotes[index],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        categoryNotes[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
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

