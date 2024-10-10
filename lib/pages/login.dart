
import 'package:ai_quizitive/bits/signin_button.dart';
import 'package:ai_quizitive/bits/square_tile.dart';
import 'package:ai_quizitive/pages/home_page.dart';
import 'package:ai_quizitive/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_quizitive/bits/textfield.dart';
class LoginPage extends StatefulWidget{

  final Function()? onTap;
   const LoginPage ({super.key, required this.onTap });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final unameController = TextEditingController();

  final pwdController = TextEditingController();

  //sign in method
  void userSignIn() async{
//loading
   showDialog(
    context: context, 
    builder: (context){
      return const Center(
        child: CircularProgressIndicator()
        ,);});
    try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: unameController.text, 
      password: pwdController.text);
      //loading circle pop
      //Navigator.pop(context);
       } on FirebaseAuthException catch (e){
       //Navigator.pop(context);
       showErrorMsg(e.code);
       }
      
  }
 
    void showErrorMsg(String message){
    showDialog(
      context: context, 
      builder: (context) {
     return  AlertDialog(
      backgroundColor: Color.fromARGB(255, 243, 115, 106),
      title: Center(
        child: Text(message,
        style: const TextStyle(color: Colors.white),
        ),
        

      ),);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body:SafeArea(     
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                 const SizedBox(height: 30),
            
                //logo
                const Icon(
                  Icons.question_mark_outlined,
                  size: 100,
                  ),
                  const SizedBox(height: 30),
            
                //welcome back
                  const Text('Ready to ace that test?',
                  style :TextStyle(color: Colors.black,
                  fontSize: 14,
                  ),),
                  const SizedBox(height: 20),
                //username field
                
            
                TheTextfield(controller: unameController, hintText: 'Username', obscureText: false),
              
                const SizedBox(height: 15),
                //pasword textfield
                TheTextfield(controller: pwdController, hintText: 'Password', obscureText: true),
                 //forgot pasword
                 const Text('Forgot Password?',
                 style: TextStyle(color: Colors.black),),
                 const SizedBox(height: 15),
                //sign in button
                SigninButton(
                  text: 'Sign In',
                  onTap: userSignIn),
                 const SizedBox(height: 15),
                //or continue with
                const Padding(
                  padding:  EdgeInsets.symmetric(),
                  child: Text(
                    "Sign In with",
                    style: TextStyle(color:Colors.black),
                  ),),
                const SizedBox(height: 35),
            
                //google + apple sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  //google button
                  
                  SquareTile(
                      onTap: () async {
                        User? user = await AuthService().signInWithGoogle();
                        if (user != null) {
                          // User successfully signed in, navigate to the next screen
                          return const HomePage();
                        } else {
                          // Handle the case where the user cancels or sign-in fails
                          print("Google sign-in was canceled or failed");
                        }
                      },
                      imagePath: 'lib/images/google.png',
                    ),

                    SizedBox(width: 15),
                  //apple button
                  SquareTile(
                    onTap: (){},
                    imagePath: 'lib/images/applethe.png')
            
            
                ],),
            
                //register now
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Sign Up now',
                      style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold
                      ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}