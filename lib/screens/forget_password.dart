import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/screens/login_screen.dart';
import 'package:mission_ed/components/rounded_button.dart';
import '../components/constants.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String email;
  final emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
@override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
          child: ListView(
            children: [
              SizedBox(
                height: 40.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ' Forget Password',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 6.5,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                      controller: emailController,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kDecoration.copyWith(
                          hintText: "Enter your registered email address")),
                  SizedBox(
                    height: 16.0,
                  ),
                  RoundButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty) {
                        _auth.sendPasswordResetEmail(email: email);
                        SnackBar(
                          content: Text(
                              'An email has been sent to your registered email address'),
                          duration: Duration(seconds: 1),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }
                    },
                    colour: kPrimaryColor,
                    text: 'Confirm',
                  ),
                ],
              ),
              SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
