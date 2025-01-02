import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import 'edit_event_screen.dart';
import '../providers/calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailsScreen extends StatelessWidget {
  final CalendarEvent event;
  final DateTime selectedDay;

  const EventDetailsScreen({
    Key? key,
    required this.event,
    required this.selectedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitleDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final editedEvent = await Navigator.push<CalendarEvent>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEventScreen(
                    event: event,
                    selectedDay: selectedDay,
                  ),
                ),
              );
              if (editedEvent != null && context.mounted) {
                Provider.of<CalendarProvider>(context, listen: false)
                    .updateEvent(event, editedEvent);
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Event'),
                  content:
                      const Text('Are you sure you want to delete this event?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<CalendarProvider>(context, listen: false)
                            .removeEvent(event);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close details screen
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 10,
              color: event.color,
            ),
            const SizedBox(height: 8),
            Card(
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: Center(
                  child: Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
