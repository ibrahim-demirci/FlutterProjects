import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_firebaselogin/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterx_firebaselogin/constants/push_id_generator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
final usersRefs = Firestore.instance.collection('users');


class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _validate = false;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(user);
      }
    } catch (e) {
      print(e);
    }
  }

  getSignedInUser() async {
    var mCurrentUser = await FirebaseAuth.instance.currentUser();
    if (mCurrentUser == null || mCurrentUser.isAnonymous) {
      print("no user signed in");
    } else {
      return mCurrentUser;
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Online Users'),
          content: Container(
            width: double.maxFinite,
            height: 300.0,
            child: OnlineUsers(),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Hero(
            tag: 'chat',
            child: Icon(
              FontAwesomeIcons.paperPlane,
              size: 20,
              color: Colors.white,
            ),
          ),
          elevation: 2.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.supervised_user_circle),
              onPressed: () {
                _displayDialog(context);
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.userAlt),
              onPressed: () async {
                var fbUser =
                    await getSignedInUser(); // wait the future object complete
                var userName = fbUser.displayName;
                var userEmail = fbUser.email;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("My Profile"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              'Name: $userName',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Email: $userEmail',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Text('LOGOUT'),
                      ),
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        FlatButton(
                          child: new Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: new Text('YES'),
                          onPressed: () async {
                            FirebaseUser user = await _auth.currentUser();
                            usersRefs.document(user.uid).updateData(
                              {
                                "status": 0,
                              },
                            );
                            _auth.signOut().then((value) {
                              Navigator.of(context)
                                  .pushReplacementNamed('/landingpage');
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          title: Text('CHAT'),
          backgroundColor: Colors.white12,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration.copyWith(
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        if (messageText != null) {
                          messageTextController.clear();
                          await _firestore
                              .collection('messages')
                              .document(PushIdGenerator.generatePushChildName())
                              .setData({
                            'text': messageText,
                            'sender': loggedInUser.email,
                          });
                        } else {
                          messageTextController.clear();
                          await _firestore
                              .collection('messages')
                              .document(PushIdGenerator.generatePushChildName())
                              .setData({
                            'text': "null",
                            'sender': loggedInUser.email,
                          });
                        }
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnlineUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final users = snapshot.data.documents.reversed;
        List<OnlineUserLists> onlineUserList = [];
        for (var user in users) {
          final dName = user.data['displayName'];
          final dEmail = user.data['email'];
          final dStatus = user.data['status'];

          if (dStatus == 1) {
            final userList = OnlineUserLists(
              displayName: dName,
              email: dEmail,
            );
            onlineUserList.add(userList);
          } else {
            SizedBox(
              height: 20,
            );
          }
        }
        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: onlineUserList,
          ),
        );
      },
    );
  }
}

class OnlineUserLists extends StatelessWidget {
  OnlineUserLists({this.displayName, this.email});

  final String displayName;
  final String email;

  //final String onlineUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        displayName,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        email,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
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

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              sender,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white70,
              ),
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
