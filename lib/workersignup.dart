import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerSignupPage extends StatefulWidget {
  WorkerSignupPage({Key? key}) : super(key: key);

  @override
  _WorkerSignupPageState createState() => _WorkerSignupPageState();
}

class _WorkerSignupPageState extends State<WorkerSignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _panchayatController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  late String _selectedDistrict;
  late String _selectedWard;
  final List<String> _districts = [
    'Thiruvananthapuram',
    'Kottayam',
    'Ernakulam',
    // Add more districts as needed
  ];
  final List<String> _wards = [
    '1',
    '2',
    '3',
    // Add more wards as needed
  ];

  @override
  void initState() {
    _selectedDistrict = _districts[0]; // Initialize with the first district
    _selectedWard = _wards[0]; // Initialize with the first ward
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worker SignUp',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 243, 152),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              onChanged: (newValue) {
                setState(() {
                  _selectedDistrict = newValue!;
                });
              },
              items: _districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'District'),
            ),
            TextField(
              controller: _panchayatController,
              decoration: const InputDecoration(labelText: 'Panchayat'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedWard,
              onChanged: (newValue) {
                setState(() {
                  _selectedWard = newValue!;
                });
              },
              items: _wards.map((ward) {
                return DropdownMenuItem<String>(
                  value: ward,
                  child: Text(ward),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Ward'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'WorkerId'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String district = _selectedDistrict;
                String panchayat = _panchayatController.text;
                String ward = _selectedWard;
                String workerId = _nameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;

                if (!isValidEmail(email)) {
                  showAlertDialog(
                    context,
                    'Invalid Email',
                    'Please enter a valid email address.',
                  );
                  return;
                }

                try {
                  final UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Access the user object using userCredential.user

                  _panchayatController.clear();
                  _nameController.clear();
                  _emailController.clear();
                  _passwordController.clear();

                  // Navigate to the login page
                  Navigator.pushReplacementNamed(context, '/workerlogin');
                } catch (e) {
                  if (e is FirebaseAuthException &&
                      e.code == 'email-already-in-use') {
                    showAlertDialog(
                      context,
                      'Email Already in Use',
                      'The email address is already in use by another account.',
                    );
                  } else {
                    print(e.toString());
                  }
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate the email format
    RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
    );
    return emailRegex.hasMatch(email);
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
