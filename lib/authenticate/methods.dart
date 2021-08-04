import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<User> createAccount(
    String username, String email, String password, String token) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child('Users').child(user.uid).set({
        'id': user.uid,
        'username': username,
        'email': email,
        'imgUrl': user.photoURL == null ? "" : user.photoURL,
        'token': token
      });
      return user;
    }
  } catch (e) {
    print(e);
  }
}

Future<User> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  } catch (e) {
    print(e);
  }
}
