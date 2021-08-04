import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:mission_ed/screens/description_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import '../components/constants.dart';

class SinglePost extends StatefulWidget {
  SinglePost(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.postedBy,
      this.imgUrl,
      this.imgPostUrl,
      this.username});

  final String id;
  final String title;
  final String description;
  final String category;
  final String postedBy;
  final String imgUrl;
  final String imgPostUrl;
  final String username;

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  bool isLiked = false;
  bool showHeartOverlay = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

/*  void getLiked() {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child('Posts').child(widget.id);
    ref.once().then((DataSnapshot snapshot) {
      var values = snapshot.value;
      var likes = values['likes'];
      var newLike = int.parse(likes) + 1;
      ref.update({'likes': newLike.toString()});
      ref.child('LikedBy').child('UserIds').set(_auth.currentUser.uid);
    });
  }*/

  _pressed() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  _doubleTapped() {
    setState(() {
      showHeartOverlay = true;
      isLiked = true;
/*      getLiked();*/
      if (showHeartOverlay) {
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            showHeartOverlay = false;
          });
        });
      }
    });
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inMinutes > 0 && diff.inMinutes < 60) {
      if (diff.inMinutes == 1) {
        time = diff.inMinutes.toString() + ' MIN AGO';
      } else {
        time = diff.inMinutes.toString() + ' MIN AGO';
      }
    } else if (diff.inHours > 0 && diff.inHours < 24) {
      if (diff.inHours == 1) {
        time = diff.inHours.toString() + ' HOUR AGO';
      } else {
        time = diff.inHours.toString() + ' HOURS AGO';
      }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else if (diff.inDays >= 7) {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    } else {
      time = 'Few Seconds Ago';
    }
    return time;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Color(0xffeaeaea),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: widget.imgUrl == ""
                                    ? AssetImage('images/dummy profile.png')
                                    : NetworkImage(widget.imgUrl)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username!=null?widget.username:'username',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(widget.category!=null?widget.category:'category'),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Icon(
                          Icons.watch_later,
                          color: Colors.blueAccent,
                          size: 32,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          widget.id!=null?readTimestamp(int.parse(widget.id)):'13 days',
                          style: TextStyle(color: Color(0xff312C69)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onDoubleTap: () => _doubleTapped(),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                    postId: widget.id,
                                  )));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              height: 210.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(widget.imgPostUrl)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      isLiked
                                          ? Icon(
                                              Icons.favorite,
                                              size: 30,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border_outlined,
                                              size: 30.0,
                                              color: Colors.blueGrey,
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        showHeartOverlay
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 80.0,
                              )
                            : Container()
                      ],
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 14,
        ),
      ],
    );
  }
}
