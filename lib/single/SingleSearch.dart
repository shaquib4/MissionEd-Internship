import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/modals/ModalFFs.dart';
import 'package:mission_ed/components/constants.dart';

class SingleSearch extends StatefulWidget {
  SingleSearch({this.imageUrl, this.name, this.id});

  final String imageUrl;
  final String name;
  final String id;

  @override
  _SingleSearchState createState() => _SingleSearchState();
}

class _SingleSearchState extends State<SingleSearch> {
  bool isFollowing=false;
  String cUserImage;
  String cUserName;
  List<Ffs> _search = [];
  FirebaseAuth _auth = FirebaseAuth.instance;

  void getCurrentUserData() {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(_auth.currentUser.uid);
    reference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          _search.clear();
          var values = snapshot.value;
          cUserImage=values['imgUrl'];
          cUserName=values['username'];
        });
      }
    });
  }

  void getFData() async {
    DatabaseReference refFData = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(_auth.currentUser.uid)
        .child('Following');
    refFData.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        _search.clear();

        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          Ffs data = new Ffs(
            uid: values[key]['id'],
            name: values[key]['username'],
            image: values[key]['imgUrl'],
          );
          if (data.uid.contains(widget.id)) {
            if(this.mounted)
              setState(() {
                isFollowing = true;
              });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFData();
    getCurrentUserData();
  }
  @override
  Widget build(BuildContext context) {
    getFData();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: kSecondaryColor,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(4.0, 4.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: widget.imageUrl == ""
                              ? AssetImage('images/dummy profile.png')
                              : NetworkImage(widget.imageUrl),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.name==null?"":widget.name,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      isFollowing
                          ? SnackBar(
                        content: Text("Already Following"),
                        duration: Duration(seconds: 1),
                      )
                          : setState(() {
                        getCurrentUserData();
                        addToFollwing(
                            widget.id, widget.name, widget.imageUrl,cUserImage,cUserName);
                      });
                    },
                    child: Text(
                      isFollowing? 'Following' : 'Follow',
                      style: TextStyle(
                          color: isFollowing
                              ? Colors.lightGreen
                              : Color(0xff312C69),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

addToFollwing(String id, String username, String imageUrl ,String cUserImg ,String cUserName) {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(_auth.currentUser.uid)
      .child('Following');
  databaseRef.child(id).set({
    'id': id,
    'imgUrl': imageUrl,
    'username': username,
  });
  final databaseFollowerRef = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(id)
      .child('Followers');
  databaseFollowerRef.child(_auth.currentUser.uid).set({
    'id': _auth.currentUser.uid,
    'imgUrl': cUserImg,
    'username': cUserName,
  });
}
