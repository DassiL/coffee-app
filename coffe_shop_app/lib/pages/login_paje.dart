import 'package:coffe_shop_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/email_service.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPhoneSelected = true;
  final TextEditingController _phoneEmailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final AuthService _authService = AuthService();
  final EmailService emailService = EmailService();
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/images/iced_coffee.png', // Make sure to add your image asset here
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'היי, ברוכים הבאים',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                'הזינו את מספר הטלפון או המייל על מנת להיכנס',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ToggleButtons(
                borderColor: Colors.grey,
                fillColor: Colors.brown[100],
                borderWidth: 2,
                selectedBorderColor: Colors.brown,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('טלפון'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('מייל'),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    isPhoneSelected = index == 0;
                  });
                },
                isSelected: [isPhoneSelected, !isPhoneSelected],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneEmailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: isPhoneSelected ? 'מספר טלפון' : 'כתובת מייל',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendVerificationCode,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('שלחו לי קוד אימות'),
              ),
              if (_codeSent) ...[
                SizedBox(height: 20),
                TextField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'קוד אימות',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('אישור'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    String input = _phoneEmailController.text.trim();

    if (isPhoneSelected) {
      // Phone authentication
    } else {
      await emailService.sendVerificationEmail(input);
      setState(() {
        _codeSent = true;
      });
    }
  }

  void _verifyCode() {
    String inputCode = _verificationCodeController.text.trim();

    if (isPhoneSelected) {
      // Implement phone verification logic if needed
    } else {
      if (inputCode == emailService.verificationCode) {
        signUp();
      } else {
        // Verification failed
        print('Verification failed');
        // Show error message or perform desired actions
      }
    }
  }

  void signUp() async {
  String email = _phoneEmailController.text.trim();
    String password = '123456';

    try {
      UserCredential userCredential = await _authService.signInWithEmailPassword(email, password);
      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          UserCredential userCredential = await _authService.signUpWithEmailPassword(email, password);
          if (userCredential.user != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        } catch (e) {
          print("error in logging up");// Show error message or perform desired actions
        }
      } else {
        print('Error signing in: $e');
        // Show error message or perform desired actions
      }
    }
  }
}
