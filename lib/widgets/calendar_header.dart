import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calendar_provider.dart';
import '../models/calendar_type.dart';

class CalendarHeader extends StatelessWidget {
  final Function() onToggleCalendarFormat;

  const CalendarHeader({
    Key? key,
    required this.onToggleCalendarFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        return AppBar(
          title: Text(
            provider.currentCalendarType == CalendarType.gregorian
                ? 'Gregorian Calendar'
                : 'Hijri Calendar',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => provider.toggleCalendarType(),
              tooltip: 'Toggle Calendar Type',
            ),
            IconButton(
              icon: const Icon(Icons.view_week),
              onPressed: onToggleCalendarFormat,
              tooltip: 'Toggle Calendar Format',
            ),
          ],
        );
      },
    );
  }
}