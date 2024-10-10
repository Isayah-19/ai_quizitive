import 'package:ai_quizitive/pages/login.dart';
import 'package:ai_quizitive/pages/signup.dart';
import 'package:flutter/material.dart';

class SignupOrLoginPage extends StatefulWidget {
  const SignupOrLoginPage ({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpOrLoginPageState();
}
  class _SignUpOrLoginPageState extends State<SignupOrLoginPage>{
    bool showLoginPage = true;

    void togglePages(){
      setState(() {
        showLoginPage = !showLoginPage; 
      });
    }
 
    @override
    Widget build(BuildContext context){
      if(showLoginPage){
        return LoginPage(
          onTap: togglePages,
        );
      }else{
        return SignUpPage(
          onTap: togglePages,
        );
      }
    }
  }
