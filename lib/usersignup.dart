import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserSignUpPage extends StatefulWidget {
  const UserSignUpPage({Key? key}) : super(key: key);

  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _username = TextEditingController();
  late String _selectedDistrict = 'Kottayam'; // Default district
  late String _selectedPanchayath = 'Bharanganam'; // Default panchayath
  late String _selectedWard;
  final Map<String, List<String>> _panchayathData = {
    'Kottayam': ['Bharanganam'],
  };
  final List<String> _wards = ['1', '2', '3'];

  @override
  void initState() {
    _selectedWard = _wards[0]; // Initialize with the first ward
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'User SignUp',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 243, 152),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDistrict = newValue!;
                    _selectedPanchayath = _panchayathData[newValue]![0];
                  });
                },
                items: _panchayathData.keys.map((district) {
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
                items: _panchayathData[_selectedDistrict]!.map((panchayath) {
                  return DropdownMenuItem<String>(
                    value: panchayath,
                    child: Text(panchayath),
                  );
                }).toList(),
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
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
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
                  String ward = _selectedWard;
                  String username = _username.text;
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

                    User? user = userCredential.user;

                    DatabaseReference usersRef =
                        FirebaseDatabase.instance.ref().child('users');
                    usersRef.child(user!.uid).set({
                      'username': username,
                      'district': district,
                      'panchayat': panchayat,
                      'ward': ward,
                    });

                    _username.clear();
                    _emailController.clear();
                    _passwordController.clear();

                    Navigator.pushReplacementNamed(context, '/user');
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
      ),
    );
  }

  bool isValidEmail(String email) {
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
