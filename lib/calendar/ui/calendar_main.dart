import 'package:alphanoteapp/calendar/backend/calendaritem.dart';
import 'package:alphanoteapp/calendar/ui/addCalendarItemWidget.dart';
import 'package:alphanoteapp/calendar/ui/editcalendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alphanoteapp/calendar/backend/calendarprovider.dart';
import 'package:intl/intl.dart';

import '../../authprovider.dart';

class calendar_main extends StatefulWidget {
  calendar_main({Key? key}) : super(key: key);

  @override
  State<calendar_main> createState() => _calendar_main();
}

class _calendar_main extends State<calendar_main> {
  DateTime today = DateTime.now();
  List<CalendarItem> calendarItems = [];
  bool isLoading = true;
  late String uid;
  late CalendarController _calendarController;
  CalendarView _currentView = CalendarView.month;

  @override
  void initState() {
    super.initState();
    fetchCalendarController();
    fetchData();
  }

  Future<void> fetchCalendarController() async {
    _calendarController = await CalendarController();
  }

  void refreshCalendar() {
    isLoading = true;
    fetchData(); // Fetch data again to update the calendar
  }

  Future<void> fetchData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final auth = authProvider.auth;
      final uid = auth.currentUser!.uid;
      this.uid = uid;
      final data = await getDataSource(uid);
      setState(() {
        calendarItems = data;
        isLoading = false;
      });
    } catch (error) {
      // Handle any errors that occurred during fetching
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '',
      _subjectDescription = '';
  Color? _headerColor, _viewHeaderColor, _calendarColor;

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final CalendarItem appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.eventName;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      _subjectDescription = appointmentDetails.eventDescription;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('$_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '$_subjectDescription',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('Close')),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCalendar(
                            calendar: appointmentDetails,
                          ),
                        ),
                      );
                    },
                    child: new Text('Edit'))
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    _calendarController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        actions: [
          PopupMenuButton<CalendarView>(
            icon: Icon(Icons.settings, color: Colors.white),
            onSelected: (CalendarView view) {
              setState(() {
                _currentView = view;
                print(_currentView.name);
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: CalendarView.month,
                child: Text('Month'),
              ),
              PopupMenuItem(
                value: CalendarView.week,
                child: Text('Week'),
              ),
              PopupMenuItem(
                value: CalendarView.day,
                child: Text('Day'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            _calendarController.backward!();
                          });
                        },
                      ),
                      SizedBox(width: 16),
                      Text(
                        (_calendarController.displayDate != null
                            ? DateFormat('MMMM yyyy')
                                .format(_calendarController.displayDate!)
                            : DateFormat('MMMM yyyy').format(DateTime.now())),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            _calendarController.forward!();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfCalendar(
                    controller: _calendarController,
                    viewHeaderStyle:
                        ViewHeaderStyle(backgroundColor: _viewHeaderColor),
                    backgroundColor: _calendarColor,
                    view: _currentView,
                    allowedViews: [
                      CalendarView.day,
                      CalendarView.week,
                      CalendarView.workWeek,
                      CalendarView.month,
                      CalendarView.timelineDay,
                      CalendarView.timelineWeek,
                      CalendarView.timelineWorkWeek
                    ],
                    headerDateFormat: '\n',
                    dataSource: CalendarItemDataSource(calendarItems),
                    onTap: calendarTapped,
                    monthViewSettings: MonthViewSettings(
                      showAgenda: true,
                      showTrailingAndLeadingDates: true,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCalendarItemWidget(
                      onItemAdded: refreshCalendar,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
