import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
class LoginScreen extends StatefulWidget {
  static String id = 'loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailTextController,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              controller: passwordTextController,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText:'Enter your password.'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(buttonColor: Colors.lightBlueAccent,buttonName:'Log In',onTap: ()async{
              try {
                final newUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  final SharedPreferences sharedPrefrences = await SharedPreferences
                      .getInstance();
                  sharedPrefrences.setString('email',emailTextController.text);
              Navigator.pushNamed(context, ChatScreen.id);
                  emailTextController.clear();
              passwordTextController.clear();
            }
              }
              catch(e) {   print(e);
              showDialog(context: context, builder:(context)=>
                  AlertDialog(
                    title: const Text('Login Error'),
                    content: SingleChildScrollView(
                      child: Text(e.toString()),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Re-Enter'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Register'),
                        onPressed: () {

                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                      ),
                    ],
                  ));


              }
            },)
          ],
        ),
      ),
    );
  }
}
