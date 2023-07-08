import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  DatabaseReference _complaintsRef =
      FirebaseDatabase.instance.ref().child('complaints');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? submittedComplaint;
  String? selectedWard;
  String? selectedComplaintType;

  List<String> wardList = [
    'Ward 1',
    'Ward 2',
    'Ward 3',
    // Add more wards as needed
  ];

  List<String> complaintTypes = [
    'Worker is not coming on date',
    'Woker is misbehaving',
    'Not picking the type specified on month',
    'Others'
    // Add more complaint types as needed
  ];

  Future<void> _submitComplaint(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final name = _nameController.text;
      final complaint = _complaintController.text;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      try {
        await _complaintsRef.push().set({
          'userId': uid,
          'name': name,
          'ward': selectedWard,
          'complaint': complaint,
          'complaintType': selectedComplaintType,
          'date': date,
        });

        setState(() {
          submittedComplaint = complaint;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Complaint Submitted'),
              content: Text('Your complaint has been submitted: $complaint'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Clear the input fields
        _nameController.clear();
        _complaintController.clear();
        selectedWard = null;
        selectedComplaintType = null;
      } catch (e) {
        print('Error submitting complaint: $e');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to submit complaint.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _addNewComplaint() {
    setState(() {
      submittedComplaint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report your Complaint'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  // Update the name
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedWard,
                onChanged: (value) {
                  setState(() {
                    selectedWard = value;
                  });
                },
                items: wardList.map((ward) {
                  return DropdownMenuItem<String>(
                    value: ward,
                    child: Text(ward),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Select your ward',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedComplaintType,
                onChanged: (value) {
                  setState(() {
                    selectedComplaintType = value;
                  });
                },
                items: complaintTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Select complaint type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              if (submittedComplaint == null)
                TextField(
                  controller: _complaintController,
                  onChanged: (value) {
                    // Update the complaint text
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your complaint',
                    border: OutlineInputBorder(),
                  ),
                )
              else
                Text('Submitted Complaint: $submittedComplaint'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (submittedComplaint == null) {
                    _submitComplaint(context);
                  } else {
                    _addNewComplaint();
                  }
                },
                child: Text(submittedComplaint == null ? 'Submit' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
