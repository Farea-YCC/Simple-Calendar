// Entry point of the app
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp( MyApp());
  });
}

// Main app widget
class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: AppColors.lightContentColor,
              scaffoldBackgroundColor: AppColors.lightContentColor,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AppColors.darkContentColor,
              scaffoldBackgroundColor: AppColors.darkContentColor,
              appBarTheme:  AppBarTheme(
                backgroundColor: AppColors.darkContentColor,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              textTheme:  TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
              ),
            ),
            home:  CalendarScreen(),
          );
        },
      ),
    );
  }
}
class AddEventDialog extends StatefulWidget {
  final DateTime selectedDay;

   AddEventDialog({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color _selectedColor = Colors.blue;
  bool _isLoading = false;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Check form validity
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate a network delay
    await Future.delayed( Duration(milliseconds: 150));

    if (!mounted) return;

    // Add event to the provider
    Provider.of<EventProvider>(context, listen: false).addEvent(
      widget.selectedDay,
      Event(
        title: _titleController.text,
        description: _descriptionController.text,
        color: _selectedColor,
      ),
    );

    setState(() => _isLoading = false);

    // Close dialog
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: SingleChildScrollView(
        physics:  AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Event',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon:  Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    prefixIcon:  Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Event title cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Event Description',
                    prefixIcon:  Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Event description cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.03),
                Text(
                  'Event Color',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.015),
                SizedBox(
                  height: screenSize.height * 0.07,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colors.length,
                    itemBuilder: (context, index) {
                      final color = _colors[index];
                      return Padding(
                        padding:  EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: AnimatedContainer(
                            duration:  Duration(milliseconds: 200),
                            width: screenSize.width * 0.1,
                            height: screenSize.width * 0.1,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == color
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: _selectedColor == color
                                ?  Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                SizedBox(
                  width: double.infinity,
                  height: screenSize.height * 0.06,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(


                      color: Colors.white,
                      strokeWidth: 2,
                    )
                        : Text(
                      'Add Event',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class CalendarScreen extends StatefulWidget {
   CalendarScreen({super.key});
  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _toggleCalendarFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.month
          ? CalendarFormat.week
          : CalendarFormat.month;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: customAppBar(
        context,
        'Calendar',
        _toggleCalendarFormat,
        _calendarFormat,
      ),
      body: LayoutBuilder(
        builder: (context, raints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    raints.maxHeight * 0.6, // تخصيص 70% من ارتفاع الشاشة
                child: SingleChildScrollView(
                  child:TableCalendar(
                    currentDay: DateTime.now(),
                    availableGestures: AvailableGestures.horizontalSwipe,
                    firstDay: DateTime.utc(1990, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
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
                    eventLoader: (day) => eventProvider.getEventsForDay(day),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 1,
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.rectangle, // تعديل الشكل ليكون مستطيلًا
                        gradient:  LinearGradient(
                          colors: [Colors.blue, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(12), // زوايا مستديرة
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset:  Offset(0, 3),
                          ),
                        ],
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.rectangle, // تعديل الشكل ليكون مستطيلًا
                        gradient: LinearGradient(
                          colors: Theme.of(context).brightness == Brightness.dark
                              ? [
                            AppColors.lightContentColor,
                            AppColors.lightContentColor
                          ]
                              : [
                            AppColors.darkAppBarColor.withOpacity(0.9),
                            AppColors.darkAppBarColor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12), // زوايا مستديرة
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.lightContentColor.withOpacity(0.1)
                                : AppColors.darkAppBarColor.withOpacity(0.5),
                            blurRadius: 8,
                            offset:  Offset(0, 3),
                          ),
                        ],
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset:  Offset(1, 1),
                          ),
                        ],
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset:  Offset(1, 1),
                          ),
                        ],
                      ),
                      weekendTextStyle:  TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                      defaultTextStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                      outsideTextStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]
                            : Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    headerStyle:  HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  )
                ),
              ),
              SizedBox(
                height: raints.maxHeight * 0.4,
                child: ListView(
                  padding:  EdgeInsets.all(16),
                  children: [
                    if (_selectedDay != null) ...[
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay!),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18, // تعديل حجم النص حسب الحاجة
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                       SizedBox(height: 16),
                      ...eventProvider.getEventsForDay(_selectedDay!).map(
                            (event) => EventCard(
                              event: event,
                              onDelete: () {
                                eventProvider.removeEvent(_selectedDay!, event);
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailsScreen(
                                      event: event,
                                      selectedDay: _selectedDay!,
                                    ),
                                  ),
                                );
                              },
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Transform.translate(
        offset:  Offset(0,
            5), // Adjusts the button's position to account for the bottom navigation bar.
        child: FloatingActionButton.extended(
          // Background color of the button based on the current theme.
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkAppBarColor
              : AppColors.lightContentColor,

          // Action when the button is pressed. Opens the AddEventDialog.
          onPressed: () {
            if (_selectedDay != null) {
              showDialog(
                context: context,
                builder: (context) =>
                    AddEventDialog(selectedDay: _selectedDay!),
              );
            }
          },

          // Label and icon of the floating action button.
          label:  Text('Add Event'),
          icon:  Icon(Icons.add),
        ),
      ),
    );
  }
}

AppBar customAppBar(BuildContext context, String title,
    Function toggleCalendarFormat, CalendarFormat calendarFormat) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  DateTime? selectedDay = DateTime.now();
  return AppBar(
    title: Text(title),
    centerTitle: true,
    backgroundColor: ThemeMode.dark == themeProvider.themeMode
        ? AppColors.darkAppBarColor
        : AppColors.lightAppBarColor,
    leading: IconButton(
      icon:  Icon(Icons.menu, size: 35),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(context:   context,);
          },
        );
      },
    ),
    actions: [
      IconButton(
        icon: Icon(calendarFormat == CalendarFormat.month
            ? Icons.calendar_view_week
            : Icons.calendar_view_month),
        onPressed: () => toggleCalendarFormat(),
      ),
    ],
  );
}


class CustomAlertDialog extends StatelessWidget {
  final BuildContext context;
  final DateTime? selectedDay;

   CustomAlertDialog({
    required this.context,
    this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title:  Center(
        child: Text(
          "Calendar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        ListTile(
          leading:  Icon(Icons.dark_mode),
          title:  Text(
            'Mode Switch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            final themeProvider =
            Provider.of<ThemeProvider>(context, listen: false);
            themeProvider.toggleTheme();
            Navigator.pop(context); // Close the Dialog after toggling the theme
          },
        ),
         Divider(height: 30),
        ListTile(
          leading:  Icon(
            Icons.share,
          ),
          title:  Text(
            'Share',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () async {
             String url =
                '';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
         Divider(height: 10),

        ListTile(
          leading:  Icon(Icons.verified_sharp),
          title:  Text(
            'Version',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing:  Text(
            '2.0.1',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/AboutUsPage');
          },
        ),
         Divider(height: 10),

        ListTile(
          leading:  Icon(Icons.policy),
          title:  Text(
            'App Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/PrivacyPolicy');
          },
        ),
         Divider(height: 10),

        ListTile(
          leading:  Icon(Icons.star),
          title:  Text(
            'Rate App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () async {
             String url =
                'https://play.google.com/store/apps/details?id=com.ahmedelshazly2020d.sales_managers&pcampaignid=web_share';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
         Divider(height: 10),

        ListTile(
          leading:  Icon(Icons.exit_to_app),
          title:  Text(
            'Exit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              headerAnimationLoop: false,
              animType: AnimType.bottomSlide,
              title: 'Confirm Exit',
              desc: 'Are you sure you want to exit the app?',
              btnCancelOnPress: () {},
              btnOkColor: Colors.blue,
              btnOkOnPress: () {
                SystemNavigator.pop();
              },
            ).show();
          },
        ),
      ],
    );
  }
}



class AppColors {
  static  Color lightContentColor = Color(0xFFF5F5F5);
  static  Color lightAppBarColor = Color(0xFFFFFFFF);
  static  Color darkAppBarColor = Color(0xFF1C3946);
  static  Color darkContentColor = Color(0xFF143241);
  static  Color iconColor = Color(0xFFF64E4E);
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

   EventCard({
    super.key,
    required this.event,
    required this.onDelete, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkAppBarColor
          : AppColors.lightContentColor,
      elevation: 5,
      margin:  EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 12,
          height: double.infinity,
          color: event.color,
        ),
        title: Text(
          event.title,
          style:  TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.description),
        trailing: IconButton(
          icon:  Icon(Icons.delete, color: AppColors.iconColor),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}

class Event {
  final String title;
  final String description;
  final Color color;

  Event({
    required this.title,
    required this.description,
    this.color = Colors.blue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description;

  @override
  int get hashCode => title.hashCode ^ description.hashCode;
}

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  Map<DateTime, List<Event>> get events => _events;

  List<Event> getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void addEvent(DateTime date, Event event) {
    final normalizedDay = DateTime(date.year, date.month, date.day);
    if (_events[normalizedDay] != null) {
      _events[normalizedDay]!.add(event);
    } else {
      _events[normalizedDay] = [event];
    }
    notifyListeners();
  }

  void removeEvent(DateTime date, Event event) {
    final normalizedDay = DateTime(date.year, date.month, date.day);
    if (_events[normalizedDay] != null) {
      _events[normalizedDay]!.remove(event);
      if (_events[normalizedDay]!.isEmpty) {
        _events.remove(normalizedDay);
      }
      notifyListeners();
    }
  }

  void clearEventsForDay(DateTime date) {
    final normalizedDay = DateTime(date.year, date.month, date.day);
    if (_events.containsKey(normalizedDay)) {
      _events.remove(normalizedDay);
      notifyListeners();
    }
  }
  void updateEvent(DateTime day, Event oldEvent, Event newEvent) {
    final normalizedDay = DateTime(day.year, day.month, day.day);

    if (_events[normalizedDay] != null) {
      final index = _events[normalizedDay]!.indexOf(oldEvent);
      if (index != -1) {
        _events[normalizedDay]![index] = newEvent;
        notifyListeners();  // Notify listeners after updating
      }
    }
  }

}
class EventDetailsScreen extends StatefulWidget {
  late final  Event event;
  final DateTime selectedDay;
   EventDetailsScreen({
    super.key,
    required this.event,
    required this.selectedDay,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final updatedEvent = eventProvider.getEventsForDay(widget.selectedDay)
        .firstWhere((e) => e == widget.event, orElse: () => widget.event);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Event'),
                  content: Text('Are you sure you want to delete this event?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                eventProvider.removeEvent(widget.selectedDay, updatedEvent);
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () async {
              final editedEvent = await Navigator.push<Event>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEventScreen(
                    event: updatedEvent,
                    selectedDay: widget.selectedDay,
                  ),
                ),
              );
              if (editedEvent != null) {
                setState(() {
                  widget.event = editedEvent; // Update local reference
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${updatedEvent.title}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Description: ${updatedEvent.description}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Event Color:'),
                SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: updatedEvent.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditEventScreen extends StatefulWidget {
  final Event event;
  final DateTime selectedDay;

   EditEventScreen({
    Key? key,
    required this.event,
    required this.selectedDay,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
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

  void _saveChanges() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title cannot be empty!')),
      );
      return;
    }

    final updatedEvent = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      color: _selectedColor,
    );

    // Update the event in the provider
    Provider.of<EventProvider>(context, listen: false).updateEvent(
      widget.selectedDay,
      widget.event, // Old event
      updatedEvent, // New event
    );

    // Return the updated event to the previous screen
    Navigator.pop(context, updatedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        actions: [
          IconButton(
            onPressed: _saveChanges,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Event Description',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Event Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: Colors.primaries.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: _selectedColor == color
                        ? Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
