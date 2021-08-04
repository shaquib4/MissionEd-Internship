import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/modals/ModalFFs.dart';
import 'package:mission_ed/single/SingleFollowers.dart';
import 'package:mission_ed/single/SingleSearch.dart';
import 'package:mission_ed/single/SingleFollowing.dart';
import '../components/constants.dart';

class NetworkSection extends StatefulWidget {
  const NetworkSection({Key key}) : super(key: key);

  @override
  _NetworkSectionState createState() => _NetworkSectionState();
}

class _NetworkSectionState extends State<NetworkSection> {
  bool button1 = true;
  bool button2 = false;
  bool button3 = false;
  Widget _allUsers;
  Widget _followers;
  Widget _following;
  Widget _search;
  Widget _Search;
  List<Ffs> allUsers = [];
  List<Ffs> searchData = [];
  List<Ffs> followers = [];
  List<Ffs> following = [];
  FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference _reference =
  FirebaseDatabase.instance.reference().child('Users');

  List<Ffs> searchMethod(String text) {
    DatabaseReference refFData =
    FirebaseDatabase.instance.reference().child('Users');
    refFData.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        searchData.clear();
        following.clear();
        followers.clear();
        allUsers.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          Ffs _searchData = new Ffs(
            uid: values[key]['id'],
            name: values[key]['username'],
            image: values[key]['imgUrl'],
          );
          if (_searchData.name.contains(text)) {
            print(_searchData.name.contains(text));
            searchData.add(_searchData);
          }
        }
      }
      if (this.mounted)
        setState(() {
          _allUsers = null;
          _followers = null;
          _following = null;
          _Search = Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: searchData.length,
              itemBuilder: (_, index) {
                return SingleSearch(
                    id: searchData[index].uid,
                    name: searchData[index].name,
                    imageUrl: searchData[index].image);
              },
            ),
          );
        });
    });
    return searchData;
  }

  List<Ffs> getAllData() {
    _reference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        searchData.clear();
        following.clear();
        followers.clear();
        allUsers.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          Ffs post = new Ffs(
              uid: values[key]['id'],
              name: values[key]['username'],
              image: values[key]['imgUrl']);
          allUsers.add(post);
        }
      }
      if (this.mounted)
        setState(() {
          _allUsers = Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: allUsers.length,
              itemBuilder: (_, index) {
                return SingleSearch(
                    id: allUsers[index].uid,
                    name: allUsers[index].name,
                    imageUrl: allUsers[index].image);
              },
            ),
          );
        });
    });
    return allUsers;
  }

  List<Ffs> getFollowersData() {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(_auth.currentUser.uid)
        .child('Followers');
    reference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        searchData.clear();
        following.clear();
        followers.clear();
        allUsers.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          Ffs post = new Ffs(
              uid: values[key]['id'],
              name: values[key]['username'],
              image: values[key]['imgUrl']);
          followers.add(post);
        }
      }
      if (this.mounted)
        setState(() {
          _followers = Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: followers.length,
              itemBuilder: (_, index) {
                return SingleFollowers(
                    id:followers[index].uid,
                    name: followers[index].name,
                    imageUrl: followers[index].image);
              },
            ),
          );
        });
    });
    return followers;
  }

  Future<List<Ffs>> getFollowingData() async {
    DatabaseReference referenceF = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(_auth.currentUser.uid)
        .child('Following');
    referenceF.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        searchData.clear();
        following.clear();
        followers.clear();
        allUsers.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          Ffs post = new Ffs(
              uid: values[key]['id'].toString(),
              name: values[key]['username'],
              image: values[key]['imgUrl']);
          following.add(post);
        }
      }
      if (this.mounted)
        setState(() {
          _following = Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: following.length,
              itemBuilder: (_, index) {
                return SingleFollowing(
                  id: following[index].uid,
                    name: following[index].name,
                    imageUrl: following[index].image);
              },
            ),
          );
        });
    });
    return following;
  }

  @override
  void initState() {
    super.initState();
    getFollowersData();
    print(followers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Network Section',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 62,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            getFollowersData();
                            setState(() {
                              button1 = true;
                              button2 = false;
                              button3 = false;

                              _allUsers = null;
                              _following = null;
                              _Search = null;

                              print(followers);
                              _search = null;
                            });
                          },
                          child: NetworkItems(
                            icon: Icons.person_rounded,
                            label: 'Followers',
                            isPressed: button1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            getFollowingData();
                            setState(() {
                              _followers = null;
                              _allUsers = null;
                              _Search = null;
                              button1 = false;
                              button2 = true;
                              button3 = false;
                              print(following);
                              _search = null;
                            });
                          },
                          child: NetworkItems(
                            icon: Icons.people_rounded,
                            label: 'Following',
                            isPressed: button2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            getAllData();
                            print('runs');
                            setState(() {
                              button1 = false;
                              button2 = false;
                              button3 = true;
                              _following = null;
                              _followers = null;
                              _Search = null;
                              _search = Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  decoration: kDecoration.copyWith(
                                      prefixIcon: Icon(
                                          Icons.youtube_searched_for_rounded),
                                      hintText: 'Enter username'),
                                  onChanged: (value) {
                                    searchMethod(value);
                                  },
                                ),
                              );
                            });
                          },
                          child: NetworkItems(
                            icon: Icons.search,
                            label: 'Search',
                            isPressed: button3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              _search == null ? Container() : _search,
              SizedBox(
                height: 5.0,
              ),
              _allUsers != null ? _allUsers : Container(),
              _followers != null ? _followers : Container(),
              _following != null ? _following : Container(),
              _Search != null ? _Search : Container(),
              /*   _allUsers==null&&_followers==null&&_following==null&& _Search==null?*/
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkItems extends StatelessWidget {
  NetworkItems({this.icon, this.label, this.isPressed});

  final IconData icon;
  final String label;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isPressed
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(4.0, 4.0), // shadow direction: bottom right
          )
        ],
        /*  border: Border.all(color: Color(0xff312C69),
             width: 0.2
             )*/
      )
          : BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
