import 'package:flutter/material.dart';
import 'package:test_firebase/chat_screen.dart';
import 'package:test_firebase/rounded_button.dart';
import 'package:test_firebase/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Authentication',
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => MyHome(),
        '/loginpage': (BuildContext context) => MyApp(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppPage(title: 'Phone Authentication'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  static String id='login_screen';
  MyAppPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter Phone Number Eg. +910000000000'),
                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),
            ),
            (errorMessage != ''
                ? Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            )
                : Container()),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                verifyPhone();
              },
              child: Text('Verify'),
              textColor: Colors.white,
              elevation: 7,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}












































































//class LoginScreen extends StatefulWidget {
//  static String id='login_screen';
//  @override
//  _LoginScreenState createState() => _LoginScreenState();
//}
//
//class _LoginScreenState extends State<LoginScreen> {
//  final _auth=FirebaseAuth.instance;
//  String email;
//  String password;
//  bool showSpinner=false;
//
//  @override
//
//
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: ModalProgressHUD(
//        inAsyncCall: showSpinner,
//        child: Padding(
//          padding: EdgeInsets.symmetric(horizontal: 24.0),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              Hero(
//                tag: ' logo',
//                child: Container(
//                  height: 200.0,
//                  child: Image.asset('images/logo.png'),
//                ),
//              ),
//              SizedBox(
//                height: 48.0,
//              ),
//              TextField(
//                textAlign: TextAlign.center,
//                keyboardType: TextInputType.emailAddress,
//                onChanged: (value) {
//                  //Do something with the user input.
//                  email=value;
//                },
//                decoration: kMessageTextFieldDecoration.copyWith(hintText:'Enter you Email'),
//              ),
//              SizedBox(
//                height: 8.0,
//              ),
//              TextField(
//                obscureText: true,
//                textAlign: TextAlign.center,
//                onChanged: (value) {
//                  password=value;
//                  //Do something with the user input.
//                },
//                decoration: kMessageTextFieldDecoration.copyWith(hintText:'Enter you Email'),
//              ),
//              SizedBox(
//                height: 24.0,
//              ),
//              roundedbutton(
//                title: 'LogIn',
//                colour: Colors.lightBlueAccent,
//                onPressed: () async{
//                  setState(() {
//                    showSpinner=true;
//                  });
//                  try{
//                    final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
//                    if(user!=null)
//                      {
//                        Navigator.pushNamed(context, ChatScreen.id);
//                      }
//                    setState(() {
//                      showSpinner=false;
//                    });
//                  }
//                  catch(e){print(e);}
//                },
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//
