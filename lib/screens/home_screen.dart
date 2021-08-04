import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:mission_ed/screens/create_post.dart';
import '../single/single_post.dart';
import '../modals/Modals.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Posts> allPosts = [];
  int size;
  String username;
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference referenceData =
  FirebaseDatabase.instance.reference().child('Posts');

  List<Posts> getData() {
    referenceData.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        allPosts.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          Posts post = new Posts(
              id: values[key]['id'],
              title: values[key]['title'],
              description: values[key]['description'],
              category: values[key]['category'],
              postedBy: values[key]['postedBy'],
              imgUrl: values[key]['imgUrl'],
              imgPostUrl: values[key]['imgPostUrl'],
              username: values[key]['username']);
          allPosts.add(post);
        }
      }
      setState(() {
        size = allPosts.length;
        print(size);
      });
    });
    return allPosts;
  }

  @override
  void initState() {
    super.initState();
    print(getData());
    print(allPosts);
  }

  @override
  Widget build(BuildContext context) {
    referenceData.onChildRemoved.listen((event) {
      setState(() {
        referenceData.once().then((DataSnapshot snapshot) {
          allPosts.clear();
          var keys = snapshot.value.keys;
          var values = snapshot.value;
          for (var key in keys) {
            Posts post = new Posts(
                id: values[key]['id'],
                title: values[key]['title'],
                description: values[key]['description'],
                category: values[key]['category'],
                postedBy: values[key]['postedBy'],
                imgUrl: values[key]['imgUrl'],
                imgPostUrl: values[key]['imgPostUrl'],
                username: values[key]['username']);
            allPosts.add(post);
          }
        });
      });
    });
    referenceData.onChildAdded.listen((event) {
      setState(() {
        referenceData.once().then((DataSnapshot snapshot) {
          allPosts.clear();
          var keys = snapshot.value.keys;
          var values = snapshot.value;
          for (var key in keys) {
            Posts post = new Posts(
                id: values[key]['id'],
                title: values[key]['title'],
                description: values[key]['description'],
                category: values[key]['category'],
                postedBy: values[key]['postedBy'],
                imgUrl: values[key]['imgUrl'],
                imgPostUrl: values[key]['imgPostUrl'],
                username: values[key]['username']);
            allPosts.add(post);
          }
        });
      });
    });
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  'MissionEd',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      letterSpacing: 3.0),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            ' Latest Posts',
                            style: TextStyle(
                              textBaseline: TextBaseline.ideographic,
                              color: kSecondaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(16.0),
                        color: kPrimaryColor),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                /*SendNotification().sendPostNotification("Hello", "sendersName", "message", "notificationType", 'csonMGODTymsMPbeWcx6m5:APA91bEPyVCRXdtdWi4jQOKsv20n-pdts1KI6xLZA2S0LwA-bobDFniQGWX0YWxxSzLcsRfs3xhoPTb0feDNOKWnDMmIwjL4JPsmxOdxEhUdKVtzLOdR3BU5xhzuHCRKKq6We9Z9EE1R');*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreatePost()));
                              },
                              child: Container(
                                child: Text(
                                  'Create +',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              allPosts.length == 0
                  ? Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(),
                ),
              )
                  : Expanded(
                child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: allPosts.length,
                    itemBuilder: (_, index) {
                      return SinglePost(
                          id: allPosts[index].id,
                          title: allPosts[index].title,
                          description: allPosts[index].description,
                          category: allPosts[index].category,
                          postedBy: allPosts[index].postedBy,
                          imgUrl: allPosts[index].imgUrl,
                          imgPostUrl: allPosts[index].imgPostUrl,
                          username: allPosts[index].username);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
