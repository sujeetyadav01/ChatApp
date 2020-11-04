

import 'package:flutter/material.dart';
import 'package:test_firebase/welcome_screen.dart';
import 'package:test_firebase/login_screen.dart';
import 'package:test_firebase/registration_screen.dart';
import 'package:test_firebase/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes:
      {
        //different routes to different pages
        WelcomeScreen.id: (context)=>WelcomeScreen(),
        LoginScreen.id: (context)=>LoginScreen(),
        RegistrationScreen.id: (context)=>RegistrationScreen(),
        ChatScreen.id: (context)=>ChatScreen(),
      },
    );
  }
}
