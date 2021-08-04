import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/components/bottom_navigation.dart';
import 'package:mission_ed/screens/login_screen.dart';

class AuthenticateFirebase extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return BottomNavigation();
    } else {
      return LoginScreen();
    }
  }
}
