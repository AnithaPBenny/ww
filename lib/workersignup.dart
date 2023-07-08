import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WorkerSignupPage extends StatefulWidget {
  const WorkerSignupPage({Key? key}) : super(key: key);

  @override
  _WorkerSignupPageState createState() => _WorkerSignupPageState();
}

class _WorkerSignupPageState extends State<WorkerSignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('workers');

  final TextEditingController _panchayatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late String _selectedDistrict;
  late String _selectedPanchayath;
  final List<String> _districts = [
    // 'Thiruvananthapuram',
    'Kottayam',
    // 'Ernakulam',
    // Add more districts as needed
  ];
  final Map<String, List<String>> _panchayathData = {
    'Kottayam': ['Bharanganam'],
    // Add more districts and their respective panchayaths as needed
  };

  @override
  void initState() {
    _selectedDistrict = 'Kottayam'; // Initialize with the default district
    _selectedPanchayath =
        'Bharanganam'; // Initialize with the default panchayat
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            DropdownButtonFormField<String>(
              value: _selectedPanchayath,
              onChanged: (newValue) {
                setState(() {
                  _selectedPanchayath = newValue!;
                });
              },
              items: _panchayathData[_selectedDistrict]?.map((panchayath) {
                return DropdownMenuItem<String>(
                  value: panchayath,
                  child: Text(panchayath),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Panchayat'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Worker ID'),
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
                String panchayat = _selectedPanchayath;
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

                  // Save worker's details to the database
                  await _database.push().set({
                    'district': district,
                    'panchayat': panchayat,
                    'workerId': workerId,
                    'email': email,
                  });

                  _nameController.clear();
                  _emailController.clear();
                  _passwordController.clear();

                  // Navigate to the login page
                  Navigator.pushReplacementNamed(context, '/worker');
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
