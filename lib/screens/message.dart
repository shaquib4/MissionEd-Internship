import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mission_ed/components/constants.dart';
import 'package:firebase_database/firebase_database.dart';

DatabaseReference ref = FirebaseDatabase.instance.reference().child('Users');
final _auth = FirebaseAuth.instance;
/*var id = 't4V2HBES3FclQTwSvyBPOeFjsKv1';*/

class Message extends StatefulWidget {
  Message({this.id, this.name});

  final String id;
  final String name;

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final messageTextController = TextEditingController();

  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚡️Chat Room (${widget.name})'),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              id: widget.id,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      var timestamp = DateTime.now().millisecondsSinceEpoch;
                      //id is uid of person through which he chats
                      ref
                          .child(_auth.currentUser.uid)
                          .child("Messages")
                          .child(widget.id)
                          .child(timestamp.toString())
                          .set({
                        'id': timestamp.toString(),
                        'message': message,
                        'sendBy': _auth.currentUser.uid
                      });
                      ref
                          .child(widget.id)
                          .child("Messages")
                          .child(_auth.currentUser.uid)
                          .child(timestamp.toString())
                          .set({
                        'id': timestamp.toString(),
                        'message': message,
                        'sendBy': _auth.currentUser.uid
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  MessageStream({this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
      ref.child(_auth.currentUser.uid).child("Messages").child(id).onValue,
      builder: (context, AsyncSnapshot<Event> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.snapshot;
        List<MessageBubble> messageBubbles = [];
        print(messages);
        Map<dynamic, dynamic> values = messages.value;
        if (values != null) {
          values.forEach((key, value) {
            print(value);
            var messageBubble = MessageBubble(
                sender: value['id'],
                text: value['message'],
                isMe: _auth.currentUser.uid == value['sendBy']);
            messageBubbles.add(messageBubble);
          });
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: isMe ? kPrimaryColor : Colors.white,
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
