

import 'dart:io';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
final _firestore = FirebaseFirestore.instance;
User loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

   String message;
   var timeStamp = FieldValue.serverTimestamp();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();


  }
  void getCurrentUser()async{
    final  user=  _auth.currentUser;
    if(user!=null){
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () async{
                  _auth.signOut();
                  final SharedPreferences sharedPrefrences = await SharedPreferences
                      .getInstance();
                  sharedPrefrences.remove('email');
                  Navigator.pushNamed(context,WelcomeScreen.id);
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
              MessageStream (),
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
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                                   _firestore.collection('messages').add({
                                     'text':message?? showDialog(context: context, builder:(context)=>AlertDialog(
                                   title: const Text('Message Error'),
                                   content: SingleChildScrollView(
                                   child: Text(' Message is Empty'),
                                   ),
                                   actions: <Widget>[
                                   TextButton(
                                   child: const Text('Re-Enter'),
                                   onPressed: () {
                                   Navigator.of(context).pop();
                                   },
                                   ),
                                   ],
                                   )),
                                     'sender':loggedInUser.email,
                                     'time':timeStamp,
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
      ),
    );
  }
}

class  MessageStream extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream:  _firestore.collection("messages").orderBy('time', descending: true).snapshots(),
      builder: (context,snapshot)  {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages =snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages)
        {
          final messageText = (message.data() as Map)['text'];
          final messageSender = (message.data() as Map)['sender'];
          final tempTime =  (message.data()as Map)['time'];
          var temp1time = tempTime==null?DateTime.now() : tempTime.toDate();
            var time =  DateFormat.jm().format(temp1time);

          final currentUser = loggedInUser.email;
          final messageBubble= MessageBubble(messageText, messageSender, currentUser==messageSender,time);

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messageBubbles,
          ),
        );

      },
    );
  }
}


class MessageBubble extends StatelessWidget {
final bubbleMessage;
final bubbleSender;
final bool isMe;
final   time;



MessageBubble(this.bubbleMessage,this.bubbleSender,this.isMe,this.time);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe==true?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
            Text('$bubbleSender',style:TextStyle(color: Colors.blueGrey),),
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 5.0,
            color: isMe==true?Colors.lightBlueAccent:Colors.white,
            child: Column(
                // mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:40,left: 5,top:8,bottom: 2 ),
                  child: Text('$bubbleMessage' ,style: TextStyle(
                      fontSize: 18,fontWeight: FontWeight.w400,color: isMe==true?Colors.white:Colors.black
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0,right:5,bottom: 2),
                  child: Text('$time',style:TextStyle(fontSize:10,fontWeight: FontWeight.w400,color: isMe==true?Colors.white:Colors.black),),
                )
              ],
            ),



          ),


        ],
      ),
    );
  }
}
