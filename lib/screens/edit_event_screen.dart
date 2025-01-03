import 'package:dual_calendar/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/calendar_provider.dart';
import 'event_details_screen.dart';

class EditEventScreen extends StatefulWidget {
  final CalendarEvent event;
  final DateTime selectedDay;
  const EditEventScreen({
    Key? key,
    required this.event,
    required this.selectedDay,
  }) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _selectedColor = widget.event.color;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editEvent),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final editedEvent = CalendarEvent(
                title: _titleController.text,
                description: _descriptionController.text,
                gregorianDate: widget.selectedDay,
                color: _selectedColor,
              );

              Provider.of<CalendarProvider>(context, listen: false)
                  .updateEvent(widget.event, editedEvent);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event updated successfully')),
              );

              Navigator.pop(context,
                  editedEvent); // إرسال الحدث المحدث إلى الشاشة السابقة
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 9,
                children: Colors.primaries.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.white
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
