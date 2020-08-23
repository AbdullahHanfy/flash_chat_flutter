import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/componants/nav_button.dart';
import 'package:flash_chat/constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisable = false ; 
  final _auth = FirebaseAuth.instance;
  String email, pass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      body: ModalProgressHUD(
        inAsyncCall: isVisable,
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
                    child: Image.asset('images/logopng1.png'),
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
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  pass = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              NavButton(
                  colour: Colors.lightBlueAccent,
                  buttonName: 'Log in',
                  onPressed: () async {
                    setState(() {
                      isVisable= true ; 
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: pass);
                      if(user != null){
                        Navigator.pushNamed(context,ChatScreen.id);
                      }
                      
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                        isVisable= false; 
                      });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
