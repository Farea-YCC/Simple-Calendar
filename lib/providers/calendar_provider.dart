import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../models/calendar_type.dart';

import 'package:flutter/material.dart';
import '../models/calendar_type.dart';
import '../models/calendar_event.dart';

class CalendarProvider with ChangeNotifier {
  CalendarType _currentCalendarType = CalendarType.gregorian;
  final Map<DateTime, List<CalendarEvent>> _events = {};
  bool _isWeekView = false;

  // Getters
  CalendarType get currentCalendarType => _currentCalendarType;
  Map<DateTime, List<CalendarEvent>> get events => _events;
  bool get isWeekView => _isWeekView;

  // Toggle between Gregorian and Hijri Calendar
  void toggleCalendarType() {
    _currentCalendarType = _currentCalendarType == CalendarType.gregorian
        ? CalendarType.hijri
        : CalendarType.gregorian;
    notifyListeners();
  }

  // Toggle between Week View and Month View
  void toggleCalendarView() {
    _isWeekView = !_isWeekView;
    notifyListeners();
  }

  // Get events for a specific day (supports Gregorian/Hijri logic)
  List<CalendarEvent> getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return _events[normalizedDay] ?? [];
  }

  // Add an event to the calendar
  void addEvent(CalendarEvent event) {
    final normalizedDay = _normalizeDate(event.gregorianDate);

    if (_events.containsKey(normalizedDay)) {
      _events[normalizedDay]!.add(event);
    } else {
      _events[normalizedDay] = [event];
    }
    notifyListeners();
  }

  void removeEvent(CalendarEvent event) {
    final normalizedDay = _normalizeDate(event.gregorianDate);

    if (_events[normalizedDay] != null) {
      _events[normalizedDay]!.removeWhere((e) =>
          e.title == event.title && e.gregorianDate == event.gregorianDate);

      if (_events[normalizedDay]!.isEmpty) {
        _events.remove(normalizedDay);
      }

      notifyListeners();
    }
  }

  void updateEvent(CalendarEvent oldEvent, CalendarEvent newEvent) {
    removeEvent(oldEvent);
    addEvent(newEvent);

    notifyListeners();
  }

  // Private method to normalize a DateTime (remove time)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get all events for the current week
  List<CalendarEvent> getEventsForWeek(DateTime startOfWeek) {
    final eventsForWeek = <CalendarEvent>[];
    for (int i = 0; i < 7; i++) {
      final day = _normalizeDate(startOfWeek.add(Duration(days: i)));
      eventsForWeek.addAll(getEventsForDay(day));
    }
    return eventsForWeek;
  }
}
