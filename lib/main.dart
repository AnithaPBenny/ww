import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

///import 'package:waste_wise/adminanalytics.dart';
//import 'package:waste_wise/adminpaymentanalytics.dart';
import 'package:waste_wise/admincalendar.dart';
import 'package:waste_wise/admincomplaints.dart';
import 'package:waste_wise/adminhome.dart';
import 'package:waste_wise/adminlogin.dart';
import 'package:waste_wise/adminprofile.dart';
import 'package:waste_wise/adminsignup.dart';
import 'package:waste_wise/usercalendar.dart';
import 'package:waste_wise/useronlinepay.dart';
import 'package:waste_wise/usersettings.dart';
import 'package:waste_wise/userstatus.dart';
//import 'package:waste_wise/adminanalytics.dart';
import 'package:waste_wise/workercalendar.dart';
import 'package:waste_wise/workercollection.dart';
import 'package:waste_wise/login.dart';
import 'package:waste_wise/userofflinepay.dart';
import 'package:waste_wise/workerpayment.dart';
import 'package:waste_wise/signup.dart';
import 'package:waste_wise/splash.dart';
import 'package:waste_wise/userfeedback.dart';
import 'package:waste_wise/userlogin.dart';
import 'package:waste_wise/adminsettings.dart';
import 'package:waste_wise/userprofile.dart';
import 'package:waste_wise/usersignup.dart';
import 'package:waste_wise/workerhome.dart';
import 'package:waste_wise/workerlogin.dart';
import 'package:waste_wise/workerprofile.dart';
import 'package:waste_wise/workersettings.dart';
import 'package:waste_wise/workersignup.dart';
import 'package:waste_wise/userpayment.dart';
import 'package:waste_wise/userhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      projectId: 'wastewise-683b1',
      apiKey: "AIzaSyC9mYRq0Kp0R0AVdUZWGLrq1J4dY01mPGU",
      messagingSenderId: '',
      appId: '',
    ),
  );
  runApp(const WasteWiseApp());
}

class WasteWiseApp extends StatelessWidget {
  const WasteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/admin': (context) => AdminLoginPage(),
        '/user': (context) => UserLoginPage(),
        '/worker': (context) => WorkerLoginPage(),
        '/signup': (context) => const SignupPage(),
        '/adminsignup': (context) => const AdminSignupPage(
              key: null,
            ),
        '/workersignup': (context) => const WorkerSignupPage(),
        '/usersignup': (context) => const UserSignUpPage(),
        '/userhome': (context) => const UserHomePage(),
        '/userpayment': (context) => const PaymentPage1(),
        '/usercalendar': (context) => const UserCalendarPage(
              userWard: '',
            ),
        '/admincalendar': (context) => const AdminCalendarPage(
              adminWard: '',
            ),
        '/workercalendar': (context) => const WorkerCalendarPage(
              workerWard: '',
              workerEmail: '',
            ),
        '/usersettings': (context) => const UserSettingsPage(),
        '/adminsettings': (context) => const AdminSettingsPage(),
        '/wokersettings': (context) => const WorkerSettingsPage(),
        '/workerhome': (context) => const WorkerHomePage(),
        '/userfeedback': (context) => const FeedbackScreen(),
        '/collection': (context) => const WorkerCollection(),
        '/payment': (context) => const WorkerPayment(),
        '/adminhome': (context) => const AdminHomePage(),
        '/admincomplaints': (context) => const AdminComplaintReceivePage(),
        '/userstatus': (context) => UserStatusPage(),
        '/userofflinepay': (context) => const UserOfflinePayPage(
              userId: '',
            ),
        '/useronlinepay': (context) => const UserPaymentPage(),
        '/userprofile': (context) => const UserProfilePage(),
        '/adminprofile': (context) => AdminProfilePage(),
        '/workerprofile': (context) => WorkerProfilePage(),
      },
    );
  }
}
//main.dart
