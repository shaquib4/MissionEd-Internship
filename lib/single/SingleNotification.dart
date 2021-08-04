import 'package:flutter/material.dart';
import 'package:mission_ed/screens/description_screen.dart';

import '../components/constants.dart';

class SingleNotificationSection extends StatelessWidget {
  SingleNotificationSection(
      {this.id, this.postTitle, this.username, this.imgUrl});

  final String imgUrl;
  final String postTitle;
  final String username;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Description(postId: id)));
      },
      child: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
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
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imgUrl == ""
                              ? AssetImage('images/dummy profile.png')
                              : NetworkImage(imgUrl),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postTitle != null ? postTitle : 'Internship',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        username != null ? username : 'Shaquib Khan',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
