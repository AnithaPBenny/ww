import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminComplaintReceivePage extends StatefulWidget {
  const AdminComplaintReceivePage({Key? key}) : super(key: key);

  @override
  _AdminComplaintReceivePageState createState() =>
      _AdminComplaintReceivePageState();
}

class _AdminComplaintReceivePageState extends State<AdminComplaintReceivePage> {
  final _complaintsRef = FirebaseDatabase.instance.ref().child('complaints');

  List<Map<String, String>> _userComplaints = [];

  @override
  void initState() {
    super.initState();
    _fetchUserComplaints();
  }

  void _fetchUserComplaints() {
    _complaintsRef.onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      final dynamic value = snapshot.value;
      if (value is Map<dynamic, dynamic>) {
        List<Map<String, String>> updatedComplaints = [];

        value.entries.forEach((entry) {
          final complaintData = entry.value;
          if (complaintData is Map<dynamic, dynamic>) {
            final complaint = complaintData['complaint'] as String?;
            final name = complaintData['name'] as String?;
            final ward = complaintData['ward'] as String?;
            final date = complaintData['date'] as String?;
            final complaintType = complaintData['complaintType'] as String?;

            if (complaint != null &&
                name != null &&
                ward != null &&
                date != null &&
                complaintType != null) {
              final formattedComplaint = {
                'name': name,
                'ward': ward,
                'complaint': complaint,
                'date': date,
                'complaintType': complaintType,
              };
              updatedComplaints.add(formattedComplaint);
            }
          }
        });

        setState(() {
          _userComplaints = updatedComplaints;
        });
      } else {
        setState(() {
          _userComplaints = [];
        });
      }
    }, onError: (error) {
      setState(() {
        _userComplaints = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Complaint Receive'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _userComplaints.length,
          itemBuilder: (BuildContext context, int index) {
            final complaint = _userComplaints[index];
            final name = complaint['name'];
            final ward = complaint['ward'];
            final complaintType = complaint['complaintType'];
            final complaintText = complaint['complaint'];
            final submittedDate = complaint['date'];
            return Card(
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $name'),
                    Text('Ward: $ward'),
                    const SizedBox(height: 8),
                    Text('complaintType: $complaintType'),
                    Text('Complaint: $complaintText'),
                    const SizedBox(height: 8),
                    Text('Submitted Date: $submittedDate'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
