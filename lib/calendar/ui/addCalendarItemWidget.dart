import 'package:alphanoteapp/calendar/backend/calendaritem.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:alphanoteapp/calendar/backend/calendarprovider.dart';
import 'package:intl/intl.dart';

class AddCalendarItemWidget extends StatefulWidget {
  final VoidCallback onItemAdded; // Callback function to trigger calendar refresh

  AddCalendarItemWidget({required this.onItemAdded});

  @override
  _AddCalendarItemWidgetState createState() => _AddCalendarItemWidgetState();
}

class _AddCalendarItemWidgetState extends State<AddCalendarItemWidget> {
  final _formKey = GlobalKey<FormState>();
  String eventId = '';
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  Color? _selectedColor = Colors.red;
  bool isAllDay = false;
  
  

  void toggleAllDay(bool? value) {
    if (value != null) {
      setState(() {
        isAllDay = value;
        if (isAllDay) {
          _endController.clear();
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottomOpacity: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (title) {
                    if (title == null || title.isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
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
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Add Event Title",
                  ),
                ),
                SizedBox(height: 10),
                DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  controller: _startController,
                  dateMask: 'dd-MM-yyyy AT HH:mm',
                  firstDate: DateTime.now(),
                  lastDate: DateTime(9999),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Starting Date and Time",
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
                ),
                SizedBox(height: 10),
                if (!isAllDay)
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    controller: _endController,
                    dateMask: 'dd-MM-yyyy AT HH:mm',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(9999),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Ending Date and Time",
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
                  ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('All Day'),
                    const SizedBox(width: 229.5),
                    Switch(
                      value: isAllDay,
                      onChanged: toggleAllDay,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _contentController,
                  textInputAction: TextInputAction.next,
                  maxLines: 8,
                  enableSuggestions: false,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (content) {
                    if (content == null || content.isEmpty) {
                      return 'Please enter some content.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: const Icon(Icons.segment),
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
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Add Notes",
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<Color>(
                  value: _selectedColor,
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
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final title = _titleController.text;
                        final content = _contentController.text;
                        final start = DateTime.parse(_startController.text);
                        final end = isAllDay ? DateTime.parse(_startController.text) : DateTime.parse(_endController.text);

                        CalendarItem item = CalendarItem(
                            null,
                            title,
                            start,
                            end!,
                            content,
                            _selectedColor!,
                            isAllDay);

                        final statusCode = await addCalendarItem(item);

                        if (statusCode == 200) {
                          widget.onItemAdded();
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Success'),
                              content: Text('Calendar Item: $title added.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Error'),
                              content: Text('An error occurred.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}