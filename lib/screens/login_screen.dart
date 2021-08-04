import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/helper/MyFirebaseMessaging.dart';
import 'package:mission_ed/authenticate/authenticate_firebase.dart';
import 'package:mission_ed/authenticate/methods.dart';
import 'package:mission_ed/screens/forget_password.dart';
import 'package:mission_ed/screens/home_screen.dart';
import 'package:mission_ed/components/rounded_button.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:mission_ed/components/signUP_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../authenticate/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  final emailController = TextEditingController();
  String password;
  final passwordController = TextEditingController();
  bool isLoading = false;

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

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            /*final token = SendNotification().getToken();*/
            /*print('This is $token');*/
            final databaseRef = FirebaseDatabase.instance
                .reference()
                .child('Users')
                .child(user.uid)
                .set({
              'id': user.uid,
              'username': user.displayName,
              'email': user.email,
              'imgUrl': user.photoURL==null?"":user.photoURL,
              'token': "token"
            });
            return AuthenticateFirebase();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something Went Wrong'),
            );
          } else {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 80.0,
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
                            ' Sign In with your credentials',
                            style: TextStyle(
                              color: kSecondaryColor,
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
                            controller: emailController,
                            decoration: kDecoration,
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          SizedBox(
                            height: 24.0,
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
                          RoundButton(
                            onPressed: () async {
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });
                                logIn(email, password).then((user) async {
                                  if (user != null) {
                                    final ref = FirebaseDatabase.instance
                                        .reference()
                                        .child('Users')
                                        .child(user.uid);
                                    final token =
                                    await SendNotification().getToken();
                                    ref.update({'token': token});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AuthenticateFirebase()));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    SnackBar(
                                      content:
                                      Text('Wrong Email/Password entered'),
                                      duration: Duration(seconds: 1),
                                    );
                                  }
                                });
                              }
                            },
                            colour: kPrimaryColor,
                            text: 'Log In',
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()));
                            },
                            child: Text(
                              ' Forget your password ?',
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 120,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              ' Don\'t have Account ?',
                              style: TextStyle(
                                textBaseline: TextBaseline.ideographic,
                                color: kSecondaryColor,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'SignUp',
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
                      GestureDetector(
                        onTap: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          subscribeToMissionEd();
                          provider.googleLogin();
                        },
                        child: Container(
                          height: 48,
                          child: Image.asset('images/goog.png'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
