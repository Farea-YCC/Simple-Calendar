import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
class EventCard extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 12,
          height: double.infinity,
          color: event.color,
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}