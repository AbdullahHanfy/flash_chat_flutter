import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  
  String messageText;
  final _auth = FirebaseAuth.instance;

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
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('message').getDocuments();
  //   for(var message in messages.documents){
  //     print(message.data);

  //   }
  // }

  // void messageSnap() async {
  //   await for(var  snap in  _firestore.collection('message').snapshots()){
  //     for(var message in snap.documents){
  //     print(message.data);

  //   }

  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamClass(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      textController.clear();

                      _firestore.collection('message').add(
                          {'text': messageText, 'sender': loggedInUser.email,
                          'timestamp': Timestamp.now(),});
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

class StreamClass extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('message').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents;
        List<MessageBuble> messagesWidgets = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final currentUser = loggedInUser.email;

          final messageWidget = MessageBuble(
              messageText: messageText, 
              messageSender: messageSender,
              isMe: currentUser==messageSender,
               
              );

          messagesWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            children: messagesWidgets,
          ),
        );
      },
    );
  }
}

class MessageBuble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final bool isMe; 
  const MessageBuble({
    @required this.messageText,
    @required this.messageSender,
    this.isMe
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Text('$messageSender',
          style: TextStyle(fontSize: 12.2,color: Colors.black54),),
          Material(
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0), 
              bottomRight: Radius.circular(30.0)

            ): BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0), 
              bottomLeft: Radius.circular(30.0)

            ),
            elevation: 10,
            color: isMe ? Colors.black54 : Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(messageText,
              style: TextStyle(color: Colors.white,
              fontSize: 20.0),
              ),
            )
            
            ),
        ],
      ),
    );
  }
}
