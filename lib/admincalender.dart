import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminCalendarPage extends StatefulWidget {
  @override
  _AdminCalendarPageState createState() => _AdminCalendarPageState();
}

class _AdminCalendarPageState extends State<AdminCalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late Map<DateTime, List<String>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime(DateTime.now().year - 1);
    _lastDay = DateTime(DateTime.now().year + 1);
    _events = {};
  }

  void _addEvent(DateTime date) {
    setState(() {
      if (_events[date] == null) {
        _events[date] = [];
      }
    });
  }

  void _removeEvent(DateTime date) {
    setState(() {
      _events.remove(date);
    });
  }

  void _selectDay(DateTime selectedDate, DateTime focusedDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Assign Duty"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Date: $selectedDate"),
              TextField(
                decoration: const InputDecoration(labelText: "Worker Name"),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Type of Waste"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addEvent(selectedDate);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Page"),
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
              onDaySelected: _selectDay,
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Assigned Duties:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _events.length,
              itemBuilder: (context, index) {
                var date = _events.keys.elementAt(index);
                var duties = _events[date];
                return ListTile(
                  title: Text("Date: $date"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        duties!.map((duty) => Text("Duty: $duty")).toList(),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeEvent(date),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
