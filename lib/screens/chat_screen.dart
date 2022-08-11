
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  late String messageText;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }


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
        backgroundColor: kColorPalette,
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

                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': messageText,
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

class MessagesStream extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kColorPalette,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          Map <String,dynamic> data = message.data() as Map<String,dynamic>;
          final messageText = data['text'];
          final messageSender = data['sender'];
          final currentUser = loggedInUser.email;
          if(currentUser == messageSender){
            //it is me
          }
          final messageBubble = MessageBubble(sender: messageSender, text: messageText,isMe: currentUser==messageSender,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender,required this.text, required this.isMe});
  final bool isMe;

  final String sender ;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),),
          Material(
            elevation: 5,
            borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30),bottomLeft : Radius.circular(30), bottomRight: Radius.circular(30)): (BorderRadius.only(topRight: Radius.circular(30),bottomLeft : Radius.circular(30), bottomRight: Radius.circular(30))),
            color: isMe?kColorPaletteOther:Color(0xFFf2dbd1),
            child:
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 15, color: isMe?Colors.white:Colors.black87,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
