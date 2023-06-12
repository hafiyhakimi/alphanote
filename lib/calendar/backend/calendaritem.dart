import 'dart:ui';

class CalendarItem {
  CalendarItem(this.id, this.eventName, this.from, this.to, this.eventDescription,
      this.background, this.isAllDay);

  String? id;
  String eventName;
  DateTime from;
  DateTime to;
  String eventDescription;
  Color background;
  bool isAllDay;

  @override
  String toString() {
    return 'CalendarItem(id: $id, eventName: $eventName, from: $from, to: $to, eventDescription: $eventDescription, background: $background, isAllDay: $isAllDay)';
  }
}
