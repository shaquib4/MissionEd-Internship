import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mission_ed/authenticate/authenticate_firebase.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AuthenticateFirebase())));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
            child: Image.asset('images/Splash.png'),
          ),
        ],
      ),
    ));
  }
}
