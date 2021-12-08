import 'dart:io';

import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/round_button.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller ;
  Animation animation;
  Animation animation1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =AnimationController(
        duration: Duration(seconds: 3) ,
        vsync: this,

    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    animation1 = ColorTween(begin:Colors.grey,end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  controller.dispose();
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
        backgroundColor: animation1.value,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animation.value*100,
                    ),
                  ),
                  SizedBox(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Agne',
                        color: Colors.black,
                      ),
                      child: AnimatedTextKit(
                        pause: Duration(seconds: 1),
                        totalRepeatCount: 1,

                        animatedTexts: [
                          TypewriterAnimatedText('Flash Chat'),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(buttonColor: Colors.lightBlueAccent,buttonName:'Log In',onTap: (){   Navigator.pushNamed(context, LoginScreen.id);
              },),
              RoundedButton(buttonName:'Register',buttonColor:Colors.blueAccent ,onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },),

            ],
          ),
        ),
      ),
    );
  }
}

