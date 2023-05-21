import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_time_picker/date_time_picker.dart';

class calendar_main extends StatefulWidget {
  calendar_main({Key? key}) : super(key: key);

  @override
  State<calendar_main> createState() => _calendar_main();
}

class _calendar_main extends State<calendar_main> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
      body: content(),
    );
  }

  Widget content() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Selected Day = " + today.toString().split(" ")[0]),
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: _onDaySelected,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Event'),
                content: Container(
                  width: 300,
                  child: Form(
// key: _formAddEventKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
// controller: titleInput,

                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (title) {
                            if (title == null || title.isEmpty) {
                              return 'Please enter a title.';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              icon: const Icon(Icons.label),
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Event Title"
                          ),
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          icon: const Icon(Icons.event),
                          dateMask: 'dd-MM-yyyy AT HH:mm',
                          firstDate: DateTime.now(),
                          lastDate: DateTime(9999),
                          dateLabelText: 'Starting Date and Time',
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          dateMask: 'dd-MM-yyyy AT HH:mm',
                          icon: const Icon(Icons.event),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(9999),
                          dateLabelText: 'End Date and Time',
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("OK"),
                    onPressed: null,
                  ),
                  ElevatedButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
