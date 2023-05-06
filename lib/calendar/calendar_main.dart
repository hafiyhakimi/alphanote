import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calendar_main extends StatefulWidget {
  calendar_main({Key? key}) : super(key: key);

  @override
  State<calendar_main> createState() => _calendar_main();
}

class _calendar_main extends State<calendar_main> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String realTimeValue = '0';
  String getOnceValue = '0';
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
    DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('count');
    _testRef.onValue.listen(
      (event) {
        setState(() {
          realTimeValue = event.snapshot.value.toString();
        });
      },
    );

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
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Event Title"),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: TextFormField(
//controller: reminderNumber,
                                keyboardType: TextInputType.number,
                                enableSuggestions: false,
                                autocorrect: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.notification_add),
                                  labelText: "Reminder Time",
                                ),
                              ),
                            ),
                          ],
                        )
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text("Real Time Counter : $realTimeValue",
                  style: TextStyle(fontSize: 20))),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () async {
              final snapshot = await _testRef.get();
              if (snapshot.exists) {
                setState(() {
                  getOnceValue = snapshot.value.toString();
                });
              } else {
                print("No Data Available");
              }
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  "Get Once",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text("Get Once Counter : $getOnceValue",
                  style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}
