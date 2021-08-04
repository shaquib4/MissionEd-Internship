import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/authenticate/authenticate_firebase.dart';
import 'package:mission_ed/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/constants.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  String oldPassword;
  String newPassword;
  String confirmNewPassword;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  void validatePassword(String password, String newPassword) async {
    var firebaseUser = _auth.currentUser;
    var authCredential = EmailAuthProvider.credential(
        email: _auth.currentUser.email, password: password);
    firebaseUser.reauthenticateWithCredential(authCredential).then((value) {
      setState(() {
        showSpinner = true;
      });
      firebaseUser.updatePassword(newPassword).then((_) {
        SnackBar(
          content: Text('Password Updated Successfully'),
          duration: Duration(seconds: 1),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AuthenticateFirebase()));
        setState(() {
          showSpinner = false;
        });
      }).catchError((err) {});
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('Please check your password'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'))
              ],
            );
          });
    });
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = _auth.currentUser;
    await firebaseUser.updatePassword(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
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
                      ' Change Password',
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
                        controller: oldPasswordController,
                        obscureText: true,
                        onChanged: (value) {
                          oldPassword = value;
                        },
                        decoration: kDecoration.copyWith(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'Old Password',
                        )),
                    SizedBox(
                      height: 24.0,
                    ),
                    TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        onChanged: (value) {
                          newPassword = value;
                        },
                        decoration: kDecoration.copyWith(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'New Password',
                        )),
                    SizedBox(
                      height: 24.0,
                    ),
                    TextField(
                        controller: confirmNewPasswordController,
                        obscureText: true,
                        onChanged: (value) {
                          confirmNewPassword = value;
                        },
                        decoration: kDecoration.copyWith(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'Confirm New Password',
                        )),
                    SizedBox(
                      height: 16.0,
                    ),
                    RoundButton(
                      onPressed: () async {
                        if (oldPasswordController.text.isNotEmpty &&
                            newPasswordController.text.isNotEmpty &&
                            confirmNewPasswordController.text.isNotEmpty) {
                          if (newPassword == confirmNewPassword) {
                            validatePassword(oldPassword, newPassword);
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Alert'),
                                  content: Text('Please fill all the fields'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'))
                                  ],
                                );
                              });
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
      ),
    );
  }
}
