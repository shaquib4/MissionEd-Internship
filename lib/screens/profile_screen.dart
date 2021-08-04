import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/screens/change_password.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:mission_ed/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../authenticate/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username;
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('Users');

  @override
  void initState() {
    super.initState();
    setState(() {
      ref
          .child(_auth.currentUser.uid.toString())
          .once()
          .then((DataSnapshot snapshot)   {
        if (snapshot.value != null) {
          setState(() {
            username =  snapshot.value['username'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Text(
                '  Profile Section',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.white,
                        backgroundImage: user.photoURL == null
                            ? AssetImage('images/dummy profile.png')
                            : NetworkImage(user.photoURL)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 3.0),
                        child: Text(
                          username==null?"":username,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 3.0),
                        child: Text(
                          user.email,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: kSecondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                child: ProfileCard(
                  text: 'Edit Profile',
                ),
                onTap: () {
                  /*final provider = Provider.of<GoogleSignInProvider>(
                    context,
                    listen: false);
                provider.logout();*/
                  print(user);
                },
              ),
              GestureDetector(
                child: ProfileCard(
                  text: 'Change Password',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
              ),
              GestureDetector(
                child: ProfileCard(
                  text: 'Logout',
                ),
                onTap: () async {
                  for (var i in _auth.currentUser.providerData) {
                    if (i.providerId == 'password') {
                      await _auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else if (i.providerId == 'google.com') {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.logout();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  ProfileCard({@required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 5.0, 0, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: kPrimaryColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 18.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
