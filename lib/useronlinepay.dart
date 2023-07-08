import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPaymentPage extends StatefulWidget {
  const UserPaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<UserPaymentPage> {
  Razorpay? _razorpay;
  String selectedMonth = 'January'; // Initial value for the selected month
  String status = 'Pending'; // Initial value for the status
  late DatabaseReference _paymentRef;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Initialize Firebase Realtime Database reference
    _paymentRef = FirebaseDatabase.instance.reference().child('payments');
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  void openPaymentPortal() async {
    var options = {
      'key': 'rzp_test_RYesHpd4pMNk8i',
      'amount': 5000,
      'name': 'Kerala GOV',
      'description': 'Payment',
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(String? paymentId) {
    Fluttertoast.showToast(
      msg: "SUCCESS PAYMENT: $paymentId",
      timeInSecForIosWeb: 4,
    );

    // Save payment details to the database
    _savePaymentDetails(paymentId!, 'Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: ${response.code} - ${response.message}",
      timeInSecForIosWeb: 4,
    );

    _savePaymentDetails('', 'Success');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET IS : ${response.walletName}",
      timeInSecForIosWeb: 4,
    );
  }

  void _savePaymentDetails(String paymentId, String status) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final selectedMonth = this.selectedMonth;

      final paymentDetails = {
        'user_id': userId,
        'month': selectedMonth,
        'status': status,
        'payment_mode': 'online',
      };

      _paymentRef.push().set(paymentDetails).then((_) {
        Fluttertoast.showToast(
          msg: "Payment details saved successfully!",
          timeInSecForIosWeb: 4,
        );
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: "Failed to save payment details: $error",
          timeInSecForIosWeb: 4,
        );
        // Save the payment details with an error status
        paymentDetails['status'] = 'Error';
        _paymentRef.push().set(paymentDetails);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 27, 222, 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 22.0,
            color: Color.fromARGB(255, 12, 228, 9),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Rs.50',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 57, 245, 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18.0),
          DropdownButton<String>(
            value: selectedMonth,
            hint: Text('Select a month'),
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
              });
            },
            items: <String>[
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          InkWell(
            onTap: () {
              openPaymentPortal();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Container(
                width: MediaQuery.of(context).size.width - 60.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color.fromARGB(255, 13, 161, 35),
                ),
                child: Center(
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue.shade50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
