import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waste_wise/adminanalytics.dart';
import 'package:waste_wise/admincalender.dart';
import 'package:waste_wise/adminhome.dart';
import 'package:waste_wise/adminlogin.dart';
import 'package:waste_wise/adminsignup.dart';
import 'package:waste_wise/card.dart';
import 'package:waste_wise/workercollection.dart';
import 'package:waste_wise/login.dart';
import 'package:waste_wise/upi.dart';
import 'package:waste_wise/userofflinepay.dart';
import 'package:waste_wise/workerpayment.dart';
import 'package:waste_wise/signup.dart';
import 'package:waste_wise/splash.dart';
import 'package:waste_wise/userfeedback.dart';
import 'package:waste_wise/userlogin.dart';
import 'package:waste_wise/settings.dart';
import 'package:waste_wise/userprofile.dart';
import 'package:waste_wise/usersignup.dart';
import 'package:waste_wise/workerhome.dart';
import 'package:waste_wise/workerlogin.dart';
import 'package:waste_wise/workersignup.dart';
import 'package:waste_wise/userpayment.dart';
import 'package:waste_wise/userhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/admin': (context) => AdminLoginPage(),
        '/user': (context) => UserLoginPage(),
        '/worker': (context) => WorkerLoginPage(),
        '/signup': (context) => SignupPage(),
        '/adminsignup': (context) => AdminSignupPage(
              key: null,
            ),
        '/workersignup': (context) => WorkerSignupPage(),
        '/usersignup': (context) => UserSignUpPage(),
        '/userhome': (context) => UserHomePage(),
        '/userpayment': (context) => PaymentPage1(),
        '/admincalender': (context) => AdminCalendarPage(),
        '/usersettings': (context) => SettingsPage(),
        '/workerhome': (context) => WorkerHomePage(),
        '/userfeedback': (context) => RatingScreen(),
        '/collection': (context) => WorkerCollection(),
        '/payment': (context) => WorkerPayment(),
        '/workeranalytics': (context) => AnalyticsPage(),
        '/adminhome': (context) => const AdminHomePage(),
        '/card': (context) => CardPage(),
        '/upi': (context) => UpiPage(),
        '/userofflinepay': (context) => UserOfflinePayPage(),
        '/adminanalytics': (context) => AdminAnalyticsPage(
              animate: true,
              seriesList: [],
            ),
        '/userprofile': (context) => const ProfilePage(
              email: '',
              name: '',
              phone: '',
              photoUrl: '',
            ),
      },
    );
  }
}
//main.dart