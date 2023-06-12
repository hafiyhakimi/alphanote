import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uuid/uuid.dart';
import 'calendaritem.dart';
import 'dart:async';

class CalendarItemDataSource extends CalendarDataSource {
  CalendarItemDataSource(List<CalendarItem> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

Future<List<CalendarItem>> getDataSource(uid) async {
  final List<CalendarItem> CalendarItems = <CalendarItem>[];
  final calendarRef = FirebaseFirestore.instance
      .collection('calendar')
      .doc(uid)
      .collection('user_calendar');

  try {
    final querySnapshot = await calendarRef.get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      CalendarItem calendarItem = CalendarItem(
          data['id'],
          data['eventName'],
          DateTime.parse(data['from']),
          DateTime.parse(data['to']),
          data['eventDescription'],
          Color(data['background']),
          data['isAllDay']);
      CalendarItems.add(calendarItem);
    }

    return CalendarItems;
  } catch (error) {
    // Handle any errors that occurred during fetching
    print('err:' + error.toString());
    return [];
  }
}

Future<int> addCalendarItem(CalendarItem item) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    print(item.background.value);
    String documentId = Uuid().v4(); // Generate a random ID using the 'uuid' package
    await FirebaseFirestore.instance
        .collection('calendar')
        .doc(user!.uid)
        .collection('user_calendar')
        .doc(documentId) // Specify the desired document ID
        .set({
      'id': documentId,
      'eventName': item.eventName,
      'from': item.from.toString(),
      'to': item.to.toString(),
      'eventDescription': item.eventDescription,
      'background': item.background.value,
      'isAllDay': item.isAllDay,
    });

    return 200; // Success status code
  } catch (error) {
    print('err: $error');
    return 500; // Error status code
  }
}
