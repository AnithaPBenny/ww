import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({Key? key}) : super(key: key);

  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  DatabaseReference adminsRef = FirebaseDatabase.instance.ref().child('admin');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String _selectedDistrict = 'Kottayam'; // Default district
  late String _selectedPanchayath = 'Bharanganam'; // Default panchayath

  final Map<String, List<String>> _panchayathData = {
    // 'Thiruvanathapuram': ['Panchayath 1', 'Panchayath 2', 'Panchayath 3'],
    'Kottayam': ['Bharanganam'],
    //  'Eranakulam': ['Panchayath 1', 'Panchayath 2', 'Panchayath 3'],
    // Add more districts and their respective panchayaths as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text('Admin SignUp', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 33, 243, 152),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              onChanged: (newValue) {
                setState(() {
                  _selectedDistrict = newValue!;
                  _selectedPanchayath = _panchayathData[newValue]![
                      0]; // Set default panchayath for the selected district
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
                String panchayath = _selectedPanchayath;
                String adminid = _adminIdController.text;
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

                  // Write admin details to the Realtime Database
                  adminsRef.child(userCredential.user!.uid).set({
                    'district': district,
                    'panchayath': panchayath,
                    'adminId': adminid,
                    'email': email,
                  });

                  _adminIdController.clear();
                  _emailController.clear();
                  _passwordController.clear();

                  // Navigate to the login page
                  Navigator.pushReplacementNamed(context, '/admin');
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
