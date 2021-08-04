import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mission_ed/modals/ModalNotification.dart';
import 'package:mission_ed/single/SingleNotification.dart';

import '../components/constants.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({Key key}) : super(key: key);

  @override
  _NotificationSectionState createState() => _NotificationSectionState();
}



class _NotificationSectionState extends State<NotificationSection> {
  List<NotificationModel> notificationList=[];

  Future<List<NotificationModel>> getNotificationData() async {
    DatabaseReference referenceF = FirebaseDatabase.instance
        .reference()
        .child('Notifications');
    referenceF.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        notificationList.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        for (var key in keys) {
          NotificationModel notification = new NotificationModel(
              postId: values[key]['postId'],
              title: values[key]['title'],
              username: values[key]['username'],
              postedBy: values[key]['postedBy'],
              imgUrl: values[key]['imgUrl']);
          notificationList.add(notification);

        }
        if(this.mounted)
        setState(() {
          print(notificationList);

        });
      }
    });
    return notificationList;
  }
  @override
  Widget build(BuildContext context) {
    getNotificationData();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Notification',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700),

                ),
              ),
              SizedBox(height: 15,),
              Divider(height: 0.5,color: Colors.blueGrey,),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: notificationList.length,
                  itemBuilder: (_, index) {
                    return SingleNotificationSection(
                      id:notificationList[notificationList.length-1-index].postId,
                      imgUrl: notificationList[notificationList.length-1-index].imgUrl,
                      username: notificationList[notificationList.length-1-index].username,
                      postTitle: notificationList[notificationList.length-1-index].title,);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
