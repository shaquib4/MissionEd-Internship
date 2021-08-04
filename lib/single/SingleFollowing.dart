import 'package:flutter/material.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:mission_ed/screens/message.dart';
import 'package:mission_ed/screens/messagefollowing.dart';

class SingleFollowing extends StatelessWidget {
  SingleFollowing({this.id,this.imageUrl,this.name});
  final String imageUrl;
  final String name;
  final String id;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageFollowing(
                  id: id,
                  name: name,
                )));
      },
      child: Column(
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imageUrl==""?AssetImage('images/dummy profile.png'):NetworkImage(imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
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
