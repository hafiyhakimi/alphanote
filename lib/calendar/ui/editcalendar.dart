import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/calendaritem.dart';
import 'calendar_main.dart';

class EditCalendar extends StatefulWidget {
  final CalendarItem calendar;

  const EditCalendar({Key? key, required this.calendar}) : super(key: key);

  @override
  _EditCalendarState createState() => _EditCalendarState();
}

class _EditCalendarState extends State<EditCalendar> {
  final _formKey = GlobalKey<FormState>();

  late String _id;
  late String _title;
  late DateTime _from;
  late DateTime _to;
  late String _content;
  late Color? _selectedColor;
  late bool _isAllDay;

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void toggleAllDay(bool? value) {
    if (value != null) {
      setState(() {
        _isAllDay = value;
        if (_isAllDay) {
          _to = _from;
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();

    _id = widget.calendar.id ?? '';
    _title = widget.calendar.eventName;
    _from = widget.calendar.from;
    _to = widget.calendar.to;
    _content = widget.calendar.eventDescription;
    _selectedColor = widget.calendar.background;
    _isAllDay = widget.calendar.isAllDay;
  }

  Future<void> _updateCalendar(BuildContext context) async {
    final currentUser = _firebaseAuth.currentUser;
    final calRef = _firestore
        .collection('calendar')
        .doc(currentUser?.uid)
        .collection('user_calendar')
        .doc(widget.calendar.id);
    print(calRef.path);

    if (currentUser != null) {
      try {
        if(_isAllDay){
          await calRef.update({
            'eventName': _title,
            'from': _from.toString(),
            'to': _from.toString(),
            'eventDescription': _content,
            'background': _selectedColor?.value,
            'isAllDay': _isAllDay,
          });
        } else {
          await calRef.update({
            'eventName': _title,
            'from': _from.toString(),
            'to': _to.toString(),
            'eventDescription': _content,
            'background': _selectedColor?.value,
            'isAllDay': _isAllDay,
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => calendar_main()),
        );
      } catch (e) {
        print('Failed to update calendar: $e');
      }
    }
  }

  Future<void> _deleteCalendar(BuildContext context) async {
    final currentUser = _firebaseAuth.currentUser;
    final calRef = _firestore
        .collection('calendar')
        .doc(currentUser?.uid)
        .collection('user_calendar')
        .doc(widget.calendar.id);

    if (currentUser != null) {
      try {
        await calRef.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => calendar_main()),
        );
      } catch (e) {
        print('Failed to delete calendar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _formKey.currentState?.save();
                _updateCalendar(context);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteCalendar(context);
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
                  decoration: InputDecoration(
                      icon: const Icon(Icons.title),
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        bottom: 11,
                        top: 11,
                        right: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[1000],
                      hintStyle: TextStyle(color: Colors.grey[800])),
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
                SizedBox(height: 16),
                DateTimePicker(
                  initialValue: _from.toString(),
                  type: DateTimePickerType.dateTime,
                  dateMask: 'dd-MM-yyyy AT HH:mm',
                  firstDate: DateTime.now(),
                  lastDate: DateTime(9999),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    labelText: "Starting Date and Time",
                    filled: true,
                    fillColor: Colors.grey[1000],
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 15,
                      bottom: 11,
                      top: 11,
                      right: 15,
                    ),
                    icon: const Icon(Icons.access_time_outlined),
                  ),
                  onSaved: (value) {
                    _from = DateTime.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                if(!_isAllDay)
                  DateTimePicker(
                    initialValue: _to.toString(),
                    type: DateTimePickerType.dateTime,
                    dateMask: 'dd-MM-yyyy AT HH:mm',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(9999),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      labelText: "Ending Date and Time",
                      filled: true,
                      fillColor: Colors.grey[1000],
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        bottom: 11,
                        top: 11,
                        right: 15,
                      ),
                      icon: Padding(padding: EdgeInsets.only(left: 23.9)),
                    ),
                    onSaved: (value) {
                      _to = DateTime.parse(value!);
                    },
                  ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('All Day'),
                    const SizedBox(width: 229.5),
                    Switch(
                      value: _isAllDay,
                      onChanged: toggleAllDay,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _content,
                  maxLines: 8,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.segment),
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        bottom: 11,
                        top: 11,
                        right: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[1000],
                      hintStyle: TextStyle(color: Colors.grey[800])),
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
                SizedBox(height: 10),
                DropdownButtonFormField<Color>(
                  value: Colors.red,
                  onChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  items: [
                    DropdownMenuItem<Color>(
                      value: Colors.red,
                      child: Text(
                        'Red',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    DropdownMenuItem<Color>(
                      value: Colors.blue,
                      child: Text(
                        'Blue',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    DropdownMenuItem<Color>(
                      value: Colors.purple,
                      child: Text(
                        'Purple',
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    DropdownMenuItem<Color>(
                      value: Colors.green,
                      child: Text(
                        'Green',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    DropdownMenuItem<Color>(
                      value: Colors.orange,
                      child: Text(
                        'Orange',
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    icon: const Icon(Icons.color_lens),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 15,
                      bottom: 11,
                      top: 11,
                      right: 15,
                    ),
                    filled: true,
                    fillColor: Colors.grey[1000],
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a color';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedColor = value;
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
