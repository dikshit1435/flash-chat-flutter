import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registerScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(
            builder: (context) =>Padding(
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
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress ,
                onChanged: (value) {
                  email = value;
                },
                decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your E-mail')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordTextController,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText:'Enter Your Password' )
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundedButton(buttonName: 'Register',buttonColor:Colors.blueAccent,
                 onTap:() async{
               setState(() {
                final  progress = ProgressHUD.of(context);
                 progress.show();
               });

               try { final newUser = await _auth.createUserWithEmailAndPassword( email: email, password: password);
               if(newUser!=null){
                 final SharedPreferences sharedPrefrences = await SharedPreferences
                     .getInstance();
                 sharedPrefrences.setString('email',emailTextController.text);
                 Navigator.pushNamed(context, ChatScreen.id);
                 emailTextController.clear();
                 passwordTextController.clear();
                 setState(() {
                   final  progress = ProgressHUD.of(context);
                   progress.dismiss();
                 });
               }

               }
               catch(e) {
                 showDialog(context: context, builder:(context)=>
                     AlertDialog(
                       title: const Text('Registeration Error'),
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

                       ],
                     ));
                 setState(() {
                   final  progress = ProgressHUD.of(context);
                   progress.dismiss();
                 });
               }
               }),
            ],
          ),
        ),
      ),
      )
    );
  }
}
