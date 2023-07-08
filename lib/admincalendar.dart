import 'dart:async';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class ScheduledEvent {
  String id;
  DateTime scheduledDate;
  String selectedWard;
  String selectedWasteType;

  ScheduledEvent({
    required this.id,
    required this.scheduledDate,
    required this.selectedWard,
    required this.selectedWasteType,
  });
}

class AdminCalendarPage extends StatefulWidget {
  final String adminWard;

  const AdminCalendarPage({Key? key, required this.adminWard})
      : super(key: key);

  @override
  _AdminCalendarPageState createState() => _AdminCalendarPageState();
}

class _AdminCalendarPageState extends State<AdminCalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late User? _user; // Firebase user reference
// Define the _scheduledDate variable
  Timer? _timer;
  var _selectedWard;
  var _selectedWasteType;
  var _wardList = ['1', '2', '3']; // Sample ward list
  var _wasteTypeList = [
    'Medicine strips',
    'Toiletry tubes',
    'Broken glass'
  ]; // Sample waste type list
  List<ScheduledEvent> _scheduledEvents = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      // This is just an example of a running timer.
      // Adjust it according to your specific use case.
      // Make sure to cancel it in the dispose() method.
    });
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime(DateTime.now().year - 1);
    _lastDay = DateTime(DateTime.now().year + 1);
    _initializeUser();
    _retrieveScheduledEvents(); // Fetch the scheduled events from the database
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it is still active
    super.dispose();
  }

  // Initialize the Firebase user
  void _initializeUser() {
    _user = FirebaseAuth.instance.currentUser;
  }

  // Method to handle scheduling a date and saving it to the Realtime Database
  Future<void> _scheduleDate() async {
    try {
      if (_user != null) {
        final database = FirebaseDatabase.instance;
        final userRef = database.reference().child('admin').child(_user!.uid);

        // Update to use 'admincalendar' child node
        final eventRef = userRef.child('admincalendar').push();

        final newEvent = ScheduledEvent(
          id: eventRef.key ?? '',
          scheduledDate: _selectedDay,
          selectedWard: _selectedWard,
          selectedWasteType: _selectedWasteType,
        );

        await eventRef.set({
          'scheduledDate':
              DateFormat('dd-MM-yyyy').format(newEvent.scheduledDate),
          'selectedWard': newEvent.selectedWard,
          'selectedWasteType': newEvent.selectedWasteType,
        });

        setState(() {
          _scheduledEvents.add(newEvent);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Date scheduled successfully')),
        );
      }
    } catch (e) {}
  }

  // Fetch the scheduled events from the database
  void _retrieveScheduledEvents() async {
    try {
      if (_user != null) {
        final database = FirebaseDatabase.instance;
        final userRef = database.reference().child('admin').child(_user!.uid);

        // Update to fetch from 'admincalendar' child node
        final eventRef = userRef.child('admincalendar');

        final DataSnapshot snapshot = (await eventRef.once()) as DataSnapshot;
        final Object? eventsData = snapshot.value;

        if (eventsData != null) {
          final List<ScheduledEvent> events = [];

          setState(() {
            _scheduledEvents = events;
          });
        }
      }
    } catch (e) {}
  }

  Widget _buildScheduledDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _scheduledEvents.map((event) {
        final formattedDate =
            DateFormat('yyyy-MM-dd').format(event.scheduledDate);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Scheduled Date: $formattedDate',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteEvent(event.id); // Delete the event
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _deleteEvent(String eventId) async {
    try {
      if (_user != null) {
        final database = FirebaseDatabase.instance;
        final userRef = database.reference().child('admin').child(_user!.uid);

        await userRef.child('admincalendar').child(eventId).remove();

        setState(() {
          _scheduledEvents.removeWhere((event) => event.id == eventId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting event')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Calendar Page"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              selectedDayPredicate: (date) => isSameDay(_selectedDay, date),
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onDaySelected: (selectedDate, focusedDate) {
                setState(() {
                  _selectedDay = selectedDate;
                  _focusedDay = focusedDate;
                });
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, _) => Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildScheduledDate(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: _selectedWard,
                onChanged: (newValue) {
                  setState(() {
                    _selectedWard = newValue!;
                  });
                },
                hint: const Text('Select Ward'),
                items: _wardList.map((ward) {
                  return DropdownMenuItem<String>(
                    value: ward,
                    child: Text(ward),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: _selectedWasteType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedWasteType = newValue!;
                  });
                },
                hint: const Text('Select Waste Type'),
                items: _wasteTypeList.map((wasteType) {
                  return DropdownMenuItem<String>(
                    value: wasteType,
                    child: Text(wasteType),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedWard != null && _selectedWasteType != null) {
                  _scheduleDate();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Schedule Date'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedWard = null;
            _selectedWasteType = null;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
