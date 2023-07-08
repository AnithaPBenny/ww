import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:table_calendar/table_calendar.dart';

class UserCalendarPage extends StatefulWidget {
  final String userWard;

  const UserCalendarPage({Key? key, required this.userWard}) : super(key: key);

  @override
  _UserCalendarPageState createState() => _UserCalendarPageState();
}

class _UserCalendarPageState extends State<UserCalendarPage> {
  late List<Map<String, dynamic>> scheduledDates = [];
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _adminCalendarRef = FirebaseDatabase.instance
      .ref()
      .child('admin')
      .child('yDdcxznuLSa5e9qTt5NW6nxHJLt1')
      .child('admincalendar');

  @override
  void initState() {
    super.initState();
    _fetchScheduledDates();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  void _fetchScheduledDates() {
    print('Fetching scheduled dates...');
    _adminCalendarRef.onValue.listen((event) {
      print('onValue listener triggered');
      final DataSnapshot snapshot = event.snapshot;
      final dynamic value = snapshot.value;
      print('Fetched data: $value');
      if (value is Map<dynamic, dynamic>) {
        List<Map<String, dynamic>> scheduledDatesList = [];

        value.entries.forEach((entry) {
          final scheduledDateData = entry.value;
          if (scheduledDateData is Map<dynamic, dynamic>) {
            final scheduledDate = scheduledDateData['scheduledDate'] as String?;
            final selectedWard = scheduledDateData['selectedWard'] as String?;
            final selectedWasteType =
                scheduledDateData['selectedWasteType'] as String?;

            if (scheduledDate != null &&
                selectedWard != null &&
                selectedWasteType != null) {
              final formattedScheduledDate = {
                'scheduledDate': scheduledDate,
                'selectedWard': selectedWard,
                'selectedWasteType': selectedWasteType,
              };
              scheduledDatesList.add(formattedScheduledDate);
            }
          }
        });

        setState(() {
          scheduledDates = scheduledDatesList;
          print('Fetched data: $scheduledDatesList');
        });
      } else {
        setState(() {
          scheduledDates = [];
        });
      }
    }, onError: (error) {
      setState(() {
        scheduledDates = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Calendar Page"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Scheduled Dates:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            scheduledDates.isEmpty
                ? const Text('No scheduled dates available')
                : Expanded(
                    child: ListView.builder(
                      itemCount: scheduledDates.length,
                      itemBuilder: (BuildContext context, int index) {
                        final scheduledDateData = scheduledDates[index];
                        final scheduledDate =
                            scheduledDateData['scheduledDate'];
                        final selectedWard = scheduledDateData['selectedWard'];
                        final selectedWasteType =
                            scheduledDateData['selectedWasteType'];

                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('scheduledDate: $scheduledDate'),
                                Text('selectedWard: $selectedWard'),
                                Text('selectedWasteType: $selectedWasteType'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
//User calendar page