import 'dart:async';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String finalEmail;
class SplashScreen extends StatefulWidget {
  static String id = 'SplashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getValidationData().whenComplete(() async{
      Timer(Duration(milliseconds: 500),
              ()  {if(finalEmail == null)
                Navigator.pushNamed(context, WelcomeScreen.id);
              else
               {
                 Navigator.pushNamed(context, ChatScreen.id);
               }
              }
      );
    });


  }
    // TODO: implement initState
Future getValidationData() async{
  final SharedPreferences sharedPrefrences = await SharedPreferences
      .getInstance();
  var obtainedEmail = sharedPrefrences.getString('email');
  setState(() {
    finalEmail = obtainedEmail;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              height: 60,
            ),
    Text('Flash Chat',style: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'Agne',
            color: Colors.black,
    ),),

    ],
    ),
          CircularProgressIndicator(),

        ],
      ),
    );
  }
}
