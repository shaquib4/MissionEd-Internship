import 'package:flutter/material.dart';
import 'package:mission_ed/authenticate/authenticate_firebase.dart';
import 'package:mission_ed/screens/login_screen.dart';
import 'package:mission_ed/components/rounded_button.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:mission_ed/authenticate/methods.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../helper/MyFirebaseMessaging.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email;
  String password;
  String username;
  String confirmPassword;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String token;

  void subscribeToMissionEd() async {
    await FirebaseMessaging.instance
        .subscribeToTopic('MissionEd')
        .then((value) => print('Mission Ed subscribed'));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 60.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ' Welcome !',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 6.5,
                    ),
                    Text(
                      ' SignUp here to explore',
                      style: TextStyle(
                        color:kSecondaryColor,
                        fontSize: 20.0,
                      ),
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
                        controller: usernameController,
                        onChanged: (value) {
                          username = value.trim();
                        },
                        decoration: kDecoration.copyWith(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            hintText: 'Enter username')),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: kDecoration,
                      onChanged: (value) {
                        email = value.trim();
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                        controller: passwordController,
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kDecoration.copyWith(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'Enter your password',
                        )),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        decoration: kDecoration.copyWith(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'Confirm password',
                        )),
                    SizedBox(
                      height: 16.0,
                    ),
                    RoundButton(
                      onPressed: () async {
                        if (usernameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            confirmPasswordController.text.isNotEmpty &&
                            password.length >= 6) {
                          if (password == confirmPassword) {
                            setState(() {
                              isLoading = true;
                            });
                            token = await SendNotification().getToken();
                            createAccount(username, email, password, token)
                                .then((user) {
                              if (user != null) {
                                subscribeToMissionEd();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AuthenticateFirebase()));
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          } else {
                            AlertDialog(
                              title: Text('Alert'),
                              content: Text('Please check your password'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Ok')),
                              ],
                            );
                          }
                        } else {
                          AlertDialog(
                            title: Text('Alert'),
                            content: Text('Please enter the fields'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Ok')),
                            ],
                          );
                        }
                      },
                      colour: kPrimaryColor,
                      text: 'Sign Up',
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        ' Already have Account ?',
                        style: TextStyle(
                          textBaseline: TextBaseline.ideographic,
                          color: kSecondaryColor,
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'LogIn',
                        style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'OR',
                  style: TextStyle(
                      color: Color(0xffeaeaea),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(height: 42, child: Image.asset('images/goog.png')),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
