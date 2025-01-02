import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class CalendarEvent {
  final String title;
  final String description;
  final Color color;
  final DateTime gregorianDate;
  final HijriCalendar hijriDate;

  CalendarEvent({
    required this.title,
    required this.description,
    required this.gregorianDate,
    required this.color,
  }) : hijriDate = HijriCalendar.fromDate(gregorianDate);

  CalendarEvent copyWith({
    String? title,
    String? description,
    Color? color,
    DateTime? gregorianDate,
  }) {
    return CalendarEvent(
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      gregorianDate: gregorianDate ?? this.gregorianDate,
    );
  }
}