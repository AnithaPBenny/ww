import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminSignupPage extends StatefulWidget {
  AdminSignupPage({Key? key}) : super(key: key);

  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _panchayatController = TextEditingController();
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String _selectedDistrict;
  final List<String> _districts = [
    'Thiruvanathapuram',
    'Kottayam',
    'Eranakulam',
    // Add more districts as needed
  ];

  @override
  void initState() {
    _selectedDistrict = _districts[0]; // Initialize with the first district
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Admin SignUp', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 33, 243, 152),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
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
            decoration: const InputDecoration(labelText: 'Panchayath'),
          ),
          TextField(
            controller: _adminIdController,
            decoration: const InputDecoration(labelText: 'Admin ID'),
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
              String panchayath = _panchayatController.text;
              String workerid = _adminIdController.text;
              String email = _emailController.text;
              String password = _passwordController.text;

              if (!isValidEmail(email)) {
                showAlertDialog(context, 'Invalid Email',
                    'Please enter a valid email address.');
                return;
              }

              try {
                final UserCredential userCredential =
                    await _auth.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                // Access the user object using userCredential.user

                _districtController.clear();
                _panchayatController.clear();
                _adminIdController.clear();
                _emailController.clear();
                _passwordController.clear();

                // Navigate to the login page
                Navigator.pushReplacementNamed(context, '/adminlogin');
              } catch (e) {
                if (e is FirebaseAuthException &&
                    e.code == 'email-already-in-use') {
                  showAlertDialog(context, 'Email Already in Use',
                      'The email address is already in use by another account.');
                } else {
                  print(e.toString());
                }
              }
            },
            child: const Text('Sign Up'),
          )
        ]),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate the email format
    RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
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
