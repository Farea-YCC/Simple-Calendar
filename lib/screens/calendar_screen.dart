import 'package:dual_calendar/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import '../providers/calendar_provider.dart';
import '../models/calendar_type.dart';
import '../widgets/app_drawer.dart';
import '../widgets/calendar_header.dart';
import '../widgets/event_card.dart';
import '../widgets/add_event_dialog.dart';
import '../screens/event_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  String _formatHijriDate(HijriCalendar hijri) {
    return '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear}';
  }

  @override
  Widget build(BuildContext context) {
    final ln10 = AppLocalizations.of(context)!;
    return Consumer<CalendarProvider>(
      builder: (context, calendarProvider, child) {
        return Scaffold(
          drawer: const AppDrawer(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CalendarHeader(
              onToggleCalendarFormat: () {
                calendarProvider.toggleCalendarView();
              },
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: SingleChildScrollView(
                        child: TableCalendar(
                          locale: ln10.localeName,
                          firstDay: DateTime.utc(2000, 1, 1),
                          lastDay: DateTime.utc(2050, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: calendarProvider.isWeekView
                              ? CalendarFormat.week
                              : CalendarFormat.month,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });

                            final events =
                                calendarProvider.getEventsForDay(selectedDay);
                            if (events.isNotEmpty) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                builder: (context) {
                                  return SafeArea(
                                    child: DraggableScrollableSheet(
                                      expand: false,
                                      initialChildSize: 0.5,
                                      minChildSize: 0.3,
                                      maxChildSize: 0.8,
                                      builder: (context, scrollController) {
                                        return ListView.builder(
                                          controller: scrollController,
                                          padding: const EdgeInsets.all(16),
                                          itemCount: events.length,
                                          itemBuilder: (context, index) {
                                            final event = events[index];
                                            return EventCard(
                                              event: event,
                                              onDelete: () {
                                                calendarProvider
                                                    .removeEvent(event);
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetailsScreen(
                                                    event: event,
                                                    selectedDay: _selectedDay!,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          eventLoader: (day) =>
                              calendarProvider.getEventsForDay(day),
                          calendarStyle: const CalendarStyle(
                            markersMaxCount: 1,
                            markerSize: 8,
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          onHeaderTapped: (day) async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: _focusedDay,
                              firstDate: DateTime.utc(1999, 1, 1),
                              lastDate: DateTime.utc(2030, 12, 31),
                            );
                            if (newDate != null) {
                              setState(() {
                                _focusedDay = newDate;
                                _selectedDay = newDate;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    if (_selectedDay != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          calendarProvider.currentCalendarType ==
                                  CalendarType.gregorian
                              ? _selectedDay!.toString().split(' ')[0]
                              : _formatHijriDate(
                                  HijriCalendar.fromDate(_selectedDay!)),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_selectedDay != null) {
                final event = await showDialog<CalendarEvent>(
                  context: context,
                  builder: (context) => AddEventDialog(
                    selectedDay: _selectedDay!,
                  ),
                );

                if (event != null) {
                  calendarProvider.addEvent(event);
                }
              }
            },
            label: Text(ln10.addEvent),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
