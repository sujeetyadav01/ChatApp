import 'package:flutter/material.dart';
import 'package:test_firebase/constants.dart';
import 'chat_screen.dart';
import 'package:test_firebase/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegistrationScreen extends StatefulWidget {
  static String id='registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email=value;


                },
                decoration: kMessageTextFieldDecoration.copyWith(hintText:'Enter you Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password=value;
                },
                decoration: kMessageTextFieldDecoration.copyWith(hintText:'Enter you Password'),

              ),
              SizedBox(
                height: 24.0,
              ),

              roundedbutton(
                title: 'Register',
                colour: Colors.blueAccent,


                onPressed: () async {

                  try {
                    setState((){
                      showSpinner=true;
                    });


                    final newuser=await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newuser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  }
                  catch(e){
                    print(e);
                  }
                  setState((){
                    showSpinner=false;
                  });



                },
              )
            ],
          ),
        ),
      ),
    );
  }
}




