import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_chat/screens/welcome_screen.dart';
import 'package:insta_chat/screens/registration_screen.dart ';
import 'package:insta_chat/screens/login_screen.dart';
import 'package:insta_chat/screens/chat_screen.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InstaChat());
}


class InstaChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context)=> WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        'registration_screen' :(context)=>RegistrationScreen(),
        ChatScreen.id:(context)=>ChatScreen(),

      },

    );
  }
}