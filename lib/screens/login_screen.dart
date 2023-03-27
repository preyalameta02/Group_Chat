import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_chat/components/rounded_button.dart';
import 'package:insta_chat/constants.dart';
import 'package:insta_chat/screens/chat_screen.dart';
import 'package:insta_chat/screens/welcome_screen.dart';
import 'package:get/get.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool spinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        color: Color(0xFFeacab8),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
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
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Color(0xFFff4d4d),
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });
                  try {
                    final existingUser =
                        await (_auth.signInWithEmailAndPassword(
                            email: email, password: password));
                    if (existingUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      spinner = false;
                    });
                  } catch (e) {

                    // Navigator.pushNamed(context, WelcomeScreen.id);
                    Get.snackbar('Warning', 'Email is invalid.',colorText: Colors.white,backgroundColor: Colors.blue);

                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
